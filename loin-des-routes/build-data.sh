#!/usr/bin/env bash
# Builds data/*.png and data/meta.json.
#
#   ./build-data.sh WORK_DIR
#
# Motorways, national and departmental roads come from IGN BD TOPO (fetched by fetch-bdtopo.py);
# communal roads, streets and paths come from OpenStreetMap.
# WORK_DIR must contain france.osm.pbf (https://download.geofabrik.de/europe/france-latest.osm.pbf)
# and departements.geojson (Etalab contours-administratifs, departements-100m).
# Needs osmium-tool and gdal (brew install osmium-tool gdal).
#
# Each PNG is a grayscale raster in Web Mercator: value = distance to the nearest road of that
# category in units of 100 m (0..254, 254 meaning 25.4 km or more), and 255 outside France.
set -euo pipefail

WORK=${1:?usage: build-data.sh WORK_DIR}
HERE="$(cd "$(dirname "$0")" && pwd)"
OUT="$HERE/data"
mkdir -p "$OUT"
cd "$WORK"

CATS="autoroute nationale departementale communale rue chemin"
# Distances are computed in Lambert-93 (true metres) on a 100 m grid, then resampled.
L93_EXTENT="60000 6010000 1280000 7140000"
WM_EXTENT_LONLAT="-5.4 41.2 9.8 51.2"
WIDTH=4096

if [ ! -f highways.pbf ]; then
  osmium tags-filter -O -t -o highways.pbf france.osm.pbf \
    w/highway=motorway,motorway_link,trunk,trunk_link,primary,primary_link,secondary,secondary_link,tertiary,tertiary_link,unclassified,road,residential,living_street,pedestrian,service,track,path,footway,bridleway,cycleway,steps
fi

if [ ! -f roads.gpkg ]; then
  ogr2ogr --config OGR_INTERLEAVED_READING YES --config OSM_MAX_TMPFILE_SIZE 4000 \
    -f GPKG roads.gpkg highways.pbf -nln roads -t_srs EPSG:2154 -dialect sqlite -sql "
    SELECT highway, hstore_get_value(other_tags, 'ref') AS ref,
      hstore_get_value(other_tags, 'sac_scale') AS sac_scale, geometry
    FROM lines WHERE highway IS NOT NULL"
fi

# The road number (A, N, D...) wins over the OSM highway class: many departmental roads are
# tagged unclassified or track in OSM, especially where they end in the mountains.
ogrinfo roads.gpkg -q -sql "ALTER TABLE roads ADD COLUMN cat TEXT" 2>/dev/null || true
ogrinfo roads.gpkg -q -sql "DROP INDEX IF EXISTS roads_cat"
ogrinfo roads.gpkg -q -sql "
  UPDATE roads SET cat = CASE
    WHEN highway IN ('path','footway','bridleway','cycleway','steps','pedestrian') THEN
      CASE WHEN highway = 'pedestrian' THEN 'rue' ELSE 'chemin' END
    WHEN ref LIKE 'A%' AND highway IN ('motorway','motorway_link','trunk','trunk_link') THEN 'autoroute'
    WHEN ref LIKE 'N%' OR (ref LIKE 'T%' AND highway IN ('trunk','trunk_link','primary','primary_link')) THEN 'nationale'
    WHEN ref LIKE 'D%' OR ref LIKE 'M%' THEN 'departementale'
    WHEN highway IN ('motorway','motorway_link') THEN 'autoroute'
    WHEN highway IN ('trunk','trunk_link') THEN 'nationale'
    WHEN highway IN ('primary','primary_link','secondary','secondary_link','tertiary','tertiary_link') THEN 'departementale'
    WHEN highway IN ('unclassified','road') THEN 'communale'
    WHEN highway IN ('residential','living_street','service') THEN 'rue'
    WHEN highway = 'track' THEN 'chemin'
  END"
ogrinfo roads.gpkg -q -sql "CREATE INDEX roads_cat ON roads(cat)"
ogrinfo -ro roads.gpkg -sql "SELECT cat, COUNT(*) AS n FROM roads GROUP BY cat" | grep -E "cat \(|n \("

if [ ! -f bdtopo.gpkg ] || [ "$(wc -l < bdtopo-tiles.done)" -lt 575 ]; then
  /opt/homebrew/bin/python3 -I -W ignore "$HERE/fetch-bdtopo.py" "$WORK"
fi

if [ ! -f land.gpkg ]; then
  ogr2ogr -f GPKG land.gpkg departements.geojson -nln land -t_srs EPSG:3857 -makevalid -where "code NOT LIKE '97%'"
fi

rasterize() {  # rasterize SOURCE LAYER WHERE OUTPUT
  gdal_rasterize -q -burn 1 -init 0 -ot Byte -co COMPRESS=DEFLATE \
    -te $L93_EXTENT -tr 100 100 -l "$2" -where "$3" "$1" "$4"
}
# A/N/D from BD TOPO. Its classification can be composite ('Autoroute/Route nommée').
rasterize bdtopo.gpkg bdtopo "classement LIKE 'Autoroute%'" autoroute-l93.tif
rasterize bdtopo.gpkg bdtopo "classement NOT LIKE 'Autoroute%' AND classement LIKE '%Nationale%'" nationale-l93.tif
rasterize bdtopo.gpkg bdtopo "classement NOT LIKE 'Autoroute%' AND classement NOT LIKE '%Nationale%'" departementale-l93.tif
rasterize roads.gpkg roads "cat = 'rue'" rue-l93.tif
rasterize roads.gpkg roads "cat = 'chemin'" chemin-l93.tif
# Roads that OSM ranks A/N/D but that are more than 200 m from any BD TOPO A/N/D road (mostly
# unnumbered tertiary roads, and departmental roads handed over to the communes) are still
# roads: count them as communal.
rasterize bdtopo.gpkg bdtopo "1 = 1" ign-and-l93.tif
gdal_proximity -q ign-and-l93.tif ign-near.tif -values 1 -distunits GEO -maxdist 300 -nodata 300 -ot UInt16 -co COMPRESS=DEFLATE
rasterize roads.gpkg roads "cat = 'communale'" osm-communale-l93.tif
rasterize roads.gpkg roads "cat IN ('autoroute','nationale','departementale')" osm-and-l93.tif
gdal_calc --quiet --overwrite -A osm-communale-l93.tif -B osm-and-l93.tif -C ign-near.tif \
  --calc "maximum(A, B * (C > 200))" --type Byte --co COMPRESS=DEFLATE --outfile communale-l93.tif

for cat in $CATS; do
  echo "== $cat"
  gdal_proximity -q "$cat-l93.tif" "$cat-dist.tif" -values 1 -distunits GEO \
    -maxdist 25400 -nodata 25400 -ot UInt16 -co COMPRESS=DEFLATE
  rm -f "$cat-wm.tif"
  gdalwarp -q -s_srs EPSG:2154 -t_srs EPSG:3857 -te_srs EPSG:4326 -te $WM_EXTENT_LONLAT \
    -ts $WIDTH 0 -r min -srcnodata None -dstnodata None -wo INIT_DEST=25400 -co COMPRESS=DEFLATE \
    "$cat-dist.tif" "$cat-wm.tif"
  gdal_rasterize -q -i -burn 25500 -l land land.gpkg "$cat-wm.tif"
  gdal_translate -q -ot Byte -scale 0 25500 0 255 -of PNG -co ZLEVEL=9 "$cat-wm.tif" "$OUT/$cat.png"
  rm -f "$OUT/$cat.png.aux.xml"
done

OSM_DATE=$(osmium fileinfo -g header.option.osmosis_replication_timestamp france.osm.pbf | cut -c1-10)
gdalinfo -json autoroute-wm.tif | python3 -I -c "
import json, math, sys
info = json.load(sys.stdin)
w, h = info['size']
gt = info['geoTransform']
xmin, ymax = gt[0], gt[3]
xmax, ymin = xmin + gt[1] * w, ymax + gt[5] * h
R = 6378137
lat = lambda y: math.degrees(2 * math.atan(math.exp(y / R)) - math.pi / 2)
lon = lambda x: math.degrees(x / R)
d = '$OSM_DATE'
i = '$(date -r bdtopo.gpkg +%d/%m/%Y)'
json.dump({
  'width': w, 'height': h,
  'extent': [xmin, ymin, xmax, ymax],
  'boundsLatLng': [lat(ymin), lon(xmin), lat(ymax), lon(xmax)],
  'groundResolutionM': round(gt[1] * math.cos(math.radians(46.5)) / 10) * 10,
  'osmDate': '/'.join(reversed(d.split('-'))),
  'ignDate': i,
}, open('$OUT/meta.json', 'w'), indent=1)
"
ls -la "$OUT"
