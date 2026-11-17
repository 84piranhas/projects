# Loin de tout (prototype)

Carte interactive des zones de France métropolitaine éloignées de toute activité humaine, et des
routes qui permettent de les atteindre. Compagne de la carte [Loin des routes](../loin-des-routes/).

## Deux modes

- **Loin des hommes** (par défaut) : zones à X km ou plus de toute activité humaine cochée. Les
  routes ne comptent pas comme activité : être sur la route ou le chemin reste permis. Avec
  « Accès par la route », seules les zones à Y km ou moins d'une route cochée sont colorées, selon
  la route la plus importante (autoroute bleu, nationale vert, départementale jaune, communale
  blanc, rue gris, chemin marron).
- **Loin de tout** : les routes cochées comptent aussi comme activité ; les zones sont en orange.

## Activité humaine

| Catégorie | Source |
|---|---|
| Bourgs | ADMIN EXPRESS (IGN) : chef-lieu de chaque commune |
| Hameaux et lieux-dits habités | BD TOPO : zones d'habitation « Lieu-dit habité » et « Quartier » |
| Châteaux et moulins | BD TOPO : zones d'habitation |
| Granges | BD TOPO : zones d'habitation (souvent inhabitées) |
| Zones industrielles et commerciales | BD TOPO : zones d'activité « Industriel et commercial » (ZI, usines, carrières, déchèteries, centrales, élevages, marchés, mines…) |
| Loisirs et tourisme | BD TOPO : campings, parcs de loisirs, hébergements de loisirs, parcs zoologiques, golfs, centres équestres, sports mécaniques, stands de tir, hippodromes |
| Refuges et abris de montagne | BD TOPO |
| Enceintes militaires | BD TOPO |
| Bâtiments agricoles | BD TOPO : bâtiments d'usage agricole |

Seuls les objets « en service » sont retenus ; les ruines sont exclues.

Contrôle sur 5 zones rurales de 20 × 20 km (novembre 2026) : 95 à 99 % des bâtiments sont à moins
de 300 m d'un lieu-dit habité ou d'un chef-lieu. Les exceptions sont surtout des bâtiments
agricoles isolés (jusqu'à 63 % d'entre eux dans les Landes), d'où leur catégorie à part.

## Données

Même grille et même encodage que « Loin des routes » (Web Mercator, ~280 m au sol, distances en
centaines de mètres, `.bin.gz` et copie `.b64.txt`). Les distances aux routes ne sont pas dupliquées :
la page lit `../loin-des-routes/data`.

```bash
brew install gdal
mkdir -p ~/activite-work && cd ~/activite-work
curl -L https://etalab-datasets.geo.data.gouv.fr/contours-administratifs/latest/geojson/departements-100m.geojson.gz | gunzip > departements.geojson
/chemin/vers/loin-de-tout/build-data.sh ~/activite-work
```

Le script appelle `fetch-activite.py`, qui télécharge les catégories depuis le service WFS de la
Géoplateforme (reprise possible).

Données BD TOPO et ADMIN EXPRESS © IGN (Licence Ouverte), contours © IGN / Etalab (Licence Ouverte).
