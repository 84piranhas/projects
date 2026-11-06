# Loin des routes

Carte interactive des zones de France métropolitaine situées à plus de X km (0,5 à 20 : par pas de 0,5 jusqu'à 5 km, puis de 1 km) d'une route,
selon les types de routes retenus.

Option « Couleur uniforme » : cochée (par défaut), les zones loin de toute route sont en orange.
Décochée, la coloration s'inverse : chaque zone prend la couleur de la route la plus importante à
moins de X km (autoroute bleu, nationale vert, départementale jaune, communale blanc, rue gris,
chemin marron) et les zones loin des routes restent sans couleur.

## Fonctionnement

Les distances sont précalculées hors ligne : pour chaque catégorie de route, `data/<catégorie>.bin.gz`
est une grille en projection Web Mercator (~280 m au sol par pixel, dimensions dans `meta.json`) dont
chaque octet vaut la distance à la route la plus proche de cette catégorie, en centaines de mètres
(254 = 25,4 km ou plus, 255 = hors de France). Chaque ligne y est stockée comme différence avec la
ligne du dessus, puis le tout est compressé en gzip. La page décompresse les catégories cochées
(`DecompressionStream`), prend le minimum pixel par pixel, puis colore les pixels au-delà du seuil.

Chaque fichier existe aussi en `data/<catégorie>.b64.txt` : le même contenu gzip, encodé en base64.
La page charge d'abord le `.bin.gz`, le plus léger. Si la requête échoue (refus d'un proxy
d'entreprise, page de blocage à la place du fichier, connexion coupée) ou si le contenu reçu n'a pas
la bonne taille, elle bascule sur la copie texte, puis l'utilise directement pour les autres couches.
Le texte pèse un tiers de plus, mais à peu près autant une fois compressé à la volée par le serveur.

Les données ne sont volontairement pas des images PNG : relire les pixels d'une image dans un
canevas n'est pas exact dans les navigateurs qui ajoutent du bruit contre le pistage par empreinte
(Safari, Brave, Firefox). La mer, codée 255, était alors relue 254 et s'affichait en orange.

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

## Précision

Les distances sont calculées sur une grille de 100 m (Lambert-93), puis chaque pixel affiché
(260 m au sol à Dunkerque, 280 m au centre, 310 m dans le sud de la Corse) prend la plus petite
distance qu'il contient : un pixel n'est marqué « loin » que si son point le plus proche d'une route
l'est. L'incertitude est d'environ ±100 m (position des routes sur la grille, arrondi à la centaine
de mètres), soit ±20 % à 500 m. C'est pourquoi le curseur commence à 0,5 km.

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
