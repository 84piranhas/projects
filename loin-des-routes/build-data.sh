#!/usr/bin/env bash
# Builds data/*.png and data/meta.json from an OpenStreetMap extract of France.
#
#   ./build-data.sh WORK_DIR
#
# WORK_DIR must contain france.osm.pbf (https://download.geofabrik.de/europe/france-latest.osm.pbf)
# and departements.geojson (Etalab contours-administratifs, departements-100m).
# Needs osmium-tool and gdal (brew install osmium-tool gdal).
#
# Each PNG is a grayscale raster in Web Mercator: value = distance to the nearest road of that
# category in units of 100 m (0..254, 254 meaning 25.4 km or more), and 255 outside France.
set -euo pipefail

WORK=${1:?usage: build-data.sh WORK_DIR}
OUT="$(cd "$(dirname "$0")" && pwd)/data"
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
    SELECT CASE
      WHEN highway IN ('motorway','motorway_link') THEN 'autoroute'
      WHEN highway IN ('trunk','trunk_link') AND ref LIKE 'A%' THEN 'autoroute'
      WHEN highway IN ('trunk','trunk_link','primary','primary_link') AND (ref LIKE 'N%' OR ref LIKE 'T%') THEN 'nationale'
      WHEN highway IN ('trunk','trunk_link') AND (ref IS NULL OR ref NOT LIKE 'D%') THEN 'nationale'
      WHEN highway IN ('trunk','trunk_link','primary','primary_link','secondary','secondary_link','tertiary','tertiary_link') THEN 'departementale'
      WHEN highway IN ('unclassified','road') THEN 'communale'
      WHEN highway IN ('residential','living_street','pedestrian','service') THEN 'rue'
      WHEN highway IN ('track','path','footway','bridleway','cycleway','steps') THEN 'chemin'
    END AS cat, geometry
    FROM (SELECT highway, hstore_get_value(other_tags, 'ref') AS ref, geometry FROM lines)
    WHERE highway IS NOT NULL"
  ogrinfo roads.gpkg -sql "CREATE INDEX roads_cat ON roads(cat)" >/dev/null
fi
ogrinfo -ro roads.gpkg -sql "SELECT cat, COUNT(*) AS n FROM roads GROUP BY cat" | grep -E "cat \(|n \("

if [ ! -f land.gpkg ]; then
  ogr2ogr -f GPKG land.gpkg departements.geojson -nln land -t_srs EPSG:3857 -makevalid -where "code NOT LIKE '97%'"
fi

for cat in $CATS; do
  echo "== $cat"
  gdal_rasterize -q -burn 1 -init 0 -ot Byte -co COMPRESS=DEFLATE \
    -te $L93_EXTENT -tr 100 100 -l roads -where "cat = '$cat'" roads.gpkg "$cat-l93.tif"
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
json.dump({
  'width': w, 'height': h,
  'extent': [xmin, ymin, xmax, ymax],
  'boundsLatLng': [lat(ymin), lon(xmin), lat(ymax), lon(xmax)],
  'groundResolutionM': round(gt[1] * math.cos(math.radians(46.5)) / 10) * 10,
  'osmDate': '/'.join(reversed(d.split('-'))),
}, open('$OUT/meta.json', 'w'), indent=1)
"
ls -la "$OUT"
