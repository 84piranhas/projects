# Loin des routes

Carte interactive des zones de France métropolitaine situées à plus de X km (1 à 20) d'une route,
selon les types de routes retenus.

## Fonctionnement

Les distances sont précalculées hors ligne : pour chaque catégorie de route, `data/<catégorie>.png`
est une image en niveaux de gris (projection Web Mercator, ~280 m au sol par pixel) dont chaque pixel
vaut la distance à la route la plus proche de cette catégorie, en centaines de mètres (254 = 25,4 km
ou plus, 255 = hors de France). La page charge les catégories cochées, prend le minimum pixel par
pixel, puis colore les pixels au-delà du seuil du curseur.

## Sources

| Catégorie        | Source                                                                                  |
|------------------|-----------------------------------------------------------------------------------------|
| Autoroutes       | BD TOPO (IGN), classement administratif « Autoroute »                                   |
| Nationales       | BD TOPO (IGN), classement « Nationale » (dont les routes territoriales T… de Corse)      |
| Départementales  | BD TOPO (IGN), classement « Départementale »                                            |
| Communales       | OSM `highway=unclassified`, `road`, et les routes qu'OSM classe A/N/D à plus de 200 m d'une route A/N/D de la BD TOPO (tertiaires sans numéro, départementales transférées aux communes ou métropoles) |
| Rues             | OSM `highway=residential`, `living_street`, `pedestrian`, `service`                     |
| Chemins          | OSM `highway=track`, `path`, `footway`, `cycleway`, `bridleway`, `steps`                |

Le classement administratif de la BD TOPO peut être composite (« Autoroute/Route nommée »,
« Départementale/Route nommée »…) : il est filtré par motif, pas par égalité. Les bacs et les
tronçons fictifs sont exclus.

## Fiabilité (contrôles de novembre 2026)

- Autoroutes, nationales, départementales : sur 30 zones tests, aucun tronçon officiel ne tombe dans
  une zone affichée comme vide. Avec OSM seul, c'était 1,9 % du linéaire (routes numérotées D mais
  étiquetées `unclassified` ou `track`, ou sans numéro du tout).
- Chemins : la couverture OSM est inégale. Selon les zones, 1 % (Fontainebleau) à 40 % (Morvan)
  des chemins et sentiers de la BD TOPO manquent dans OSM ; à l'inverse, OSM contient des sentiers
  de haute montagne absents de la BD TOPO (jusqu'à 28 % dans les Pyrénées).

## Régénérer les données

```bash
brew install osmium-tool gdal
mkdir -p ~/osm-work && cd ~/osm-work
curl -LO https://download.geofabrik.de/europe/france-latest.osm.pbf && mv france-latest.osm.pbf france.osm.pbf
curl -L https://etalab-datasets.geo.data.gouv.fr/contours-administratifs/latest/geojson/departements-100m.geojson.gz | gunzip > departements.geojson
/chemin/vers/loin-des-routes/build-data.sh ~/osm-work
```

Le script appelle `fetch-bdtopo.py`, qui télécharge les ~2,7 millions de tronçons A/N/D de la
BD TOPO depuis le service WFS de la Géoplateforme (environ 5 minutes, reprise possible).
Compter ~5 Go de téléchargement pour OSM et une quinzaine de minutes de calcul.

Données BD TOPO © IGN (Licence Ouverte), © contributeurs OpenStreetMap (ODbL),
contours © IGN / Etalab (Licence Ouverte).
