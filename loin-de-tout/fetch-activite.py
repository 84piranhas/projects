"""Downloads places of human activity in metropolitan France from IGN (BD TOPO, ADMIN EXPRESS).

    python3 fetch-activite.py WORK_DIR      (needs the GDAL Python bindings: brew install gdal)

Writes WORK_DIR/activite.gpkg (layer "activite", Lambert-93, field "cat") from the Géoplateforme
WFS, tile by tile. Re-running resumes: finished (category, tile) pairs are listed in
WORK_DIR/activite-tiles.done.
"""
import json, os, sys, time, urllib.parse, urllib.request
from concurrent.futures import ThreadPoolExecutor
from osgeo import ogr, osr

WORK = sys.argv[1]
OUT = os.path.join(WORK, 'activite.gpkg')
DONE = os.path.join(WORK, 'activite-tiles.done')
URL = 'https://data.geopf.fr/wfs/ows'
PAGE = 5000
TILE = 50000  # metres, Lambert-93
X0, Y0, X1, Y1 = 60000, 6010000, 1280000, 7140000

# No filter on "fictif": here it only means the outline was not drawn (most hamlets are a 5 m
# square on their location), the place itself is real.
LIVE = "etat_de_l_objet='En service'"
ZAI = 'BDTOPO_V3:zone_d_activite_ou_d_interet'
HAB = 'BDTOPO_V3:zone_d_habitation'
# category -> (layer, CQL filter)
CATEGORIES = {
    'bourg': ('ADMINEXPRESS-COG.LATEST:chef_lieu_de_commune', None),
    'hameau': (HAB, f"nature IN ('Lieu-dit habité','Quartier') AND {LIVE}"),
    'chateau': (HAB, f"nature IN ('Château','Moulin') AND {LIVE}"),
    'grange': (HAB, f"nature='Grange' AND {LIVE}"),
    'industrie': (ZAI, f"categorie='Industriel et commercial' AND {LIVE}"),
    'loisirs': (ZAI, "nature IN ('Camping','Parc de loisirs','Hébergement de loisirs','Parc zoologique','Golf',"
                     f"'Centre équestre','Sports mécaniques','Stand de tir','Hippodrome') AND {LIVE}"),
    'refuge': (ZAI, f"nature IN ('Refuge','Abri de montagne') AND {LIVE}"),
    'militaire': (ZAI, f"nature='Enceinte militaire' AND {LIVE}"),
    'agricole': ('BDTOPO_V3:batiment', "usage_1='Agricole' AND etat_de_l_objet='En service'"),
}

def get(params, tries=6):
    url = URL + '?' + urllib.parse.urlencode(params)
    for k in range(tries):
        try:
            with urllib.request.urlopen(url, timeout=180) as r:
                return json.load(r)
        except Exception:
            if k == tries - 1:
                raise
            time.sleep(5 * (k + 1))

def fetch_tile(job):
    cat, x, y = job
    layer, cql = CATEGORIES[cat]
    bbox = f"BBOX(geometrie,{x},{y},{x + TILE},{y + TILE},'EPSG:2154')"
    feats, start = [], 0
    while True:
        fc = get({
            'SERVICE': 'WFS', 'VERSION': '2.0.0', 'REQUEST': 'GetFeature', 'TYPENAMES': layer,
            'SRSNAME': 'EPSG:2154', 'OUTPUTFORMAT': 'application/json', 'COUNT': PAGE, 'STARTINDEX': start,
            'SORTBY': 'cleabs', 'PROPERTYNAME': 'cleabs,geometrie',
            'CQL_FILTER': bbox + (f' AND {cql}' if cql else ''),
        })
        feats += fc['features']
        if len(fc['features']) < PAGE:
            return job, feats
        start += PAGE

def main():
    cats = sys.argv[2:] or list(CATEGORIES)
    done = set(open(DONE).read().split()) if os.path.exists(DONE) else set()
    jobs = [(c, x, y) for c in cats for x in range(X0, X1, TILE) for y in range(Y0, Y1, TILE)
            if f'{c},{x},{y}' not in done]
    srs = osr.SpatialReference(); srs.ImportFromEPSG(2154)
    if os.path.exists(OUT):
        ds = ogr.Open(OUT, 1); lyr = ds.GetLayer('activite')
    else:
        ds = ogr.GetDriverByName('GPKG').CreateDataSource(OUT)
        lyr = ds.CreateLayer('activite', srs, ogr.wkbUnknown)
        for name in ('cleabs', 'cat'):
            lyr.CreateField(ogr.FieldDefn(name, ogr.OFTString))
    seen = {(f.GetField('cat'), f.GetField('cleabs')) for f in lyr}
    defn = lyr.GetLayerDefn()
    with ThreadPoolExecutor(4) as pool, open(DONE, 'a') as log:
        for i, ((cat, x, y), feats) in enumerate(pool.map(fetch_tile, jobs), 1):
            lyr.StartTransaction()
            for f in feats:
                key = (cat, f['properties']['cleabs'])
                if key in seen or not f['geometry']:
                    continue
                seen.add(key)
                g = ogr.CreateGeometryFromJson(json.dumps(f['geometry']))
                g.FlattenTo2D()
                o = ogr.Feature(defn)
                o.SetField('cleabs', key[1]); o.SetField('cat', cat)
                o.SetGeometry(g)
                lyr.CreateFeature(o)
            lyr.CommitTransaction()
            log.write(f'{cat},{x},{y}\n'); log.flush()
            if i % 100 == 0 or i == len(jobs):
                print(f'{i}/{len(jobs)} tiles, {len(seen)} features', flush=True)
    ds = None

if __name__ == '__main__':
    main()
