#!/usr/bin/env bash
# Builds data/*.bin.gz, data/*.b64.txt and data/meta.json for "Loin de tout".
#
#   ./build-data.sh WORK_DIR
#
# Places of human activity come from IGN (fetched by fetch-activite.py). Road distances are not
# rebuilt here: the page reuses ../loin-des-routes/data, so the grid below must stay identical
# to the one in ../loin-des-routes/build-data.sh.
# WORK_DIR must contain departements.geojson (Etalab contours-administratifs, departements-100m).
# Needs gdal (brew install gdal).
#
# Each .bin.gz is a byte grid in Web Mercator: value = distance to the nearest place of that
# category in units of 100 m (0..254, 254 meaning 25.4 km or more), and 255 outside France.
set -euo pipefail

WORK=${1:?usage: build-data.sh WORK_DIR}
HERE="$(cd "$(dirname "$0")" && pwd)"
OUT="$HERE/data"
mkdir -p "$OUT"
cd "$WORK"

CATS="bourg hameau chateau grange industrie loisirs refuge militaire agricole"
L93_EXTENT="60000 6010000 1280000 7140000"
WM_EXTENT_LONLAT="-5.4 41.2 9.8 51.2"
WIDTH=4096

if [ ! -f activite.gpkg ] || [ "$(wc -l < activite-tiles.done)" -lt $((575 * 9)) ]; then
  /opt/homebrew/bin/python3 -I -W ignore "$HERE/fetch-activite.py" "$WORK"
fi
ogrinfo -ro activite.gpkg -sql "SELECT cat, COUNT(*) AS n FROM activite GROUP BY cat" | grep -E "cat \(|n \("

if [ ! -f land.gpkg ]; then
  ogr2ogr -f GPKG land.gpkg departements.geojson -nln land -t_srs EPSG:3857 -makevalid -where "code NOT LIKE '97%'"
fi

for cat in $CATS; do
  echo "== $cat"
  # ALL_TOUCHED: buildings and hamlets smaller than a 100 m cell must still mark it.
  gdal_rasterize -q -at -burn 1 -init 0 -ot Byte -co COMPRESS=DEFLATE \
    -te $L93_EXTENT -tr 100 100 -l activite -where "cat = '$cat'" activite.gpkg "$cat-l93.tif"
  gdal_proximity -q "$cat-l93.tif" "$cat-dist.tif" -values 1 -distunits GEO \
    -maxdist 25400 -nodata 25400 -ot UInt16 -co COMPRESS=DEFLATE
  rm -f "$cat-wm.tif"
  gdalwarp -q -s_srs EPSG:2154 -t_srs EPSG:3857 -te_srs EPSG:4326 -te $WM_EXTENT_LONLAT \
    -ts $WIDTH 0 -r min -srcnodata None -dstnodata None -wo INIT_DEST=25400 -co COMPRESS=DEFLATE \
    "$cat-dist.tif" "$cat-wm.tif"
  gdal_rasterize -q -i -burn 25500 -l land land.gpkg "$cat-wm.tif"
  gdal_translate -q -ot Byte -scale 0 25500 0 255 -co COMPRESS=DEFLATE "$cat-wm.tif" "$cat-byte.tif"
  # Same encoding as ../loin-des-routes: rows as differences from the row above, gzipped, plus
  # a base64 text copy for proxies that refuse .gz downloads.
  /opt/homebrew/bin/python3 -I -W ignore -c "
import base64, gzip, sys
import numpy as np
from osgeo import gdal
a = gdal.Open(sys.argv[1]).ReadAsArray().astype(np.uint8)
d = a.copy()
d[1:] = a[1:] - a[:-1]
z = gzip.compress(d.tobytes(), 9, mtime=0)
open(sys.argv[2] + '.bin.gz', 'wb').write(z)
open(sys.argv[2] + '.b64.txt', 'wb').write(base64.b64encode(z))
" "$cat-byte.tif" "$OUT/$cat"
done

gdalinfo -json bourg-wm.tif | python3 -I -c "
import json, sys
info = json.load(sys.stdin)
w, h = info['size']
roads = json.load(open('$HERE/../loin-des-routes/data/meta.json'))
assert (w, h) == (roads['width'], roads['height']), 'grid differs from loin-des-routes'
json.dump({**roads, 'activiteDate': '$(date -r activite.gpkg +%d/%m/%Y)'}, open('$OUT/meta.json', 'w'), indent=1)
"
ls -la "$OUT"
