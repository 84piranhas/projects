# Loin des routes

Carte interactive des zones de France métropolitaine situées à plus de X km (1 à 20) d'une route,
selon les types de routes retenus.

## Fonctionnement

Les distances sont précalculées hors ligne : pour chaque catégorie de route, `data/<catégorie>.png`
est une image en niveaux de gris (projection Web Mercator, ~280 m au sol par pixel) dont chaque pixel
vaut la distance à la route la plus proche de cette catégorie, en centaines de mètres (254 = 25,4 km
ou plus, 255 = hors de France). La page charge les catégories cochées, prend le minimum pixel par
pixel, puis colore les pixels au-delà du seuil du curseur.

| Catégorie        | Tags OpenStreetMap `highway=`                                         |
|------------------|-----------------------------------------------------------------------|
| Autoroutes       | `motorway`, `motorway_link` (et `trunk` numérotées A)                  |
| Nationales       | `trunk`, et `primary` numérotées N (ou T en Corse)                     |
| Départementales  | `primary`, `secondary`, `tertiary` et bretelles                        |
| Communales       | `unclassified`, `road`                                                 |
| Rues             | `residential`, `living_street`, `pedestrian`, `service`                |
| Chemins          | `track`, `path`, `footway`, `cycleway`, `bridleway`, `steps`           |

## Régénérer les données

```bash
brew install osmium-tool gdal
mkdir -p ~/osm-work && cd ~/osm-work
curl -LO https://download.geofabrik.de/europe/france-latest.osm.pbf && mv france-latest.osm.pbf france.osm.pbf
curl -L https://etalab-datasets.geo.data.gouv.fr/contours-administratifs/latest/geojson/departements-100m.geojson.gz | gunzip > departements.geojson
/chemin/vers/loin-des-routes/build-data.sh ~/osm-work
```

Compter ~5 Go de téléchargement et une quinzaine de minutes de calcul.

Données © contributeurs OpenStreetMap (ODbL), contours © IGN / Etalab (Licence Ouverte).
