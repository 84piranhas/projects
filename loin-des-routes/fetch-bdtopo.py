"""Downloads motorways, national and departmental roads of metropolitan France from IGN BD TOPO.

    python3 fetch-bdtopo.py WORK_DIR      (needs the GDAL Python bindings: brew install gdal)

Writes WORK_DIR/bdtopo.gpkg (layer "bdtopo", Lambert-93) from the Géoplateforme WFS, tile by tile.
Re-running resumes: tiles already fetched are listed in WORK_DIR/bdtopo-tiles.done.
"""
import json, os, sys, time, urllib.parse, urllib.request
from concurrent.futures import ThreadPoolExecutor
from osgeo import ogr, osr

WORK = sys.argv[1]
OUT = os.path.join(WORK, 'bdtopo.gpkg')
DONE = os.path.join(WORK, 'bdtopo-tiles.done')
URL = 'https://data.geopf.fr/wfs/ows'
PAGE = 5000
TILE = 50000  # metres, Lambert-93
X0, Y0, X1, Y1 = 60000, 6010000, 1280000, 7140000
# The classification can be composite, e.g. 'Autoroute/Route nommée' or 'Départementale/Route nommée'.
FILTER = ("(cpx_classement_administratif LIKE '%Autoroute%' OR cpx_classement_administratif LIKE '%Nationale%'"
          " OR cpx_classement_administratif LIKE '%Départementale%')"
          " AND etat_de_l_objet='En service' AND fictif=false AND nature<>'Bac ou liaison maritime'")

def get(params, tries=6):
    url = URL + '?' + urllib.parse.urlencode(params)
    for k in range(tries):
        try:
            with urllib.request.urlopen(url, timeout=180) as r:
                return json.load(r)
        except Exception as e:
            if k == tries - 1:
                raise
            time.sleep(5 * (k + 1))

def fetch_tile(tile):
    x, y = tile
    feats, start = [], 0
    while True:
        fc = get({
            'SERVICE': 'WFS', 'VERSION': '2.0.0', 'REQUEST': 'GetFeature',
            'TYPENAMES': 'BDTOPO_V3:troncon_de_route', 'SRSNAME': 'EPSG:2154',
            'OUTPUTFORMAT': 'application/json', 'COUNT': PAGE, 'STARTINDEX': start, 'SORTBY': 'cleabs',
            'PROPERTYNAME': 'cleabs,nature,cpx_classement_administratif,cpx_numero,geometrie',
            'CQL_FILTER': f"BBOX(geometrie,{x},{y},{x + TILE},{y + TILE},'EPSG:2154') AND {FILTER}",
        })
        feats += fc['features']
        if len(fc['features']) < PAGE:
            return tile, feats
        start += PAGE

def main():
    done = set(open(DONE).read().split()) if os.path.exists(DONE) else set()
    tiles = [(x, y) for x in range(X0, X1, TILE) for y in range(Y0, Y1, TILE) if f'{x},{y}' not in done]
    srs = osr.SpatialReference(); srs.ImportFromEPSG(2154)
    if os.path.exists(OUT):
        ds = ogr.Open(OUT, 1); lyr = ds.GetLayer('bdtopo')
    else:
        ds = ogr.GetDriverByName('GPKG').CreateDataSource(OUT)
        lyr = ds.CreateLayer('bdtopo', srs, ogr.wkbLineString)
        for name in ('cleabs', 'nature', 'classement', 'numero'):
            lyr.CreateField(ogr.FieldDefn(name, ogr.OFTString))
    seen = set()
    for f in lyr:
        seen.add(f.GetField('cleabs'))
    defn = lyr.GetLayerDefn()
    total = len(seen)
    with ThreadPoolExecutor(4) as pool, open(DONE, 'a') as log:
        for i, (tile, feats) in enumerate(pool.map(fetch_tile, tiles), 1):
            lyr.StartTransaction()
            for f in feats:
                p = f['properties']
                if p['cleabs'] in seen or not f['geometry']:
                    continue
                seen.add(p['cleabs'])
                g = f['geometry']
                parts = g['coordinates'] if g['type'] == 'MultiLineString' else [g['coordinates']]
                for part in parts:
                    line = ogr.Geometry(ogr.wkbLineString)
                    for c in part:
                        line.AddPoint_2D(c[0], c[1])
                    o = ogr.Feature(defn)
                    o.SetField('cleabs', p['cleabs']); o.SetField('nature', p['nature'])
                    o.SetField('classement', p['cpx_classement_administratif']); o.SetField('numero', p['cpx_numero'])
                    o.SetGeometry(line)
                    lyr.CreateFeature(o)
                total += 1
            lyr.CommitTransaction()
            log.write(f'{tile[0]},{tile[1]}\n'); log.flush()
            if i % 20 == 0 or i == len(tiles):
                print(f'{i}/{len(tiles)} tiles, {total} sections', flush=True)
    ds = None

if __name__ == '__main__':
    main()
