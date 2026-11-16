**Objet : L'Hebdo des Machines — Semaine du 9 au 15 novembre 2026 — Nvidia décapitée, Anthropic en piste**

Deux événements ont dominé la semaine : le départ immédiat du fondateur de Nvidia et le lancement de la tournée de l'introduction en bourse d'Anthropic. Dans le même temps, la Fed a classé l'IA en tête des risques pour la stabilité financière. Côté produits, la baisse des prix des modèles de pointe continue, tandis qu'un incident chez un hébergeur d'inférence rappelle la fragilité de la chaîne de sous-traitance.

**Suites de l'édition précédente.** Anthropic : la fourchette de prix est publiée et la tournée a commencé le 10 novembre (fait n° 2). CoreWeave et Cisco : résultats publiés aux dates prévues (rubrique 2). Inkling 2 Small : les poids sont désormais publiés (rubrique 9). Nvidia maintient la date de ses résultats au 17 novembre. Seconde tranche du tour d'OpenAI : non confirmée dans nos sources (n/c).

## Les 5 faits de la semaine

1. **Nvidia : Jensen Huang quitte la direction avec effet immédiat (statut : annoncé par le conseil le 12 novembre).** Le communiqué indique qu'il démissionne de ses fonctions de président-directeur général et d'administrateur, sans en donner la raison. Colette Kress, directrice financière depuis 2013, devient directrice générale par intérim et conserve ses fonctions financières. Harvey C. Jones, ancien dirigeant de Synopsys, devient le premier président du conseil de l'histoire du groupe. Il fait suite à des déclarations du conseil (8 et 10 novembre) et à une enquête indépendante portant, selon Tom's Hardware et ABC News, sur des informations de presse faisant du dirigeant la cible d'une opération de renseignement étrangère (allégations non vérifiées ; Pékin dément). L'action avait déjà perdu plus de 4 % le 9 novembre (Fortune) et a reculé de plus de 10 % à l'ouverture le 12. Les résultats du troisième trimestre de l'exercice 2027 restent prévus le 17 novembre.
   *Ce que ça change pour une grande banque d'investissement :* le risque « personne clé » chez le fournisseur quasi unique de GPU devient concret. Il touche la valorisation (desks actions et crédit exposés au secteur), mais aussi les feuilles de route de capacité négociées par la DSI. La gouvernance de Nvidia (séparation des fonctions, président indépendant) sera scrutée par les investisseurs dès la publication du 17.

2. **Anthropic fixe sa fourchette et lance sa tournée (statut : S-1/A déposé le 10 novembre ; prix et date de cotation non fixés).** L'amendement n° 2 au S-1 prévoit une fourchette de 70 à 78 $ par action, pour 825 millions d'actions de classe A (dont environ 801 millions émises par la société), soit jusqu'à 64,4 Md$ en haut de fourchette. L'option de surallocation porte sur 123,75 millions d'actions supplémentaires. Sept partenaires stratégiques, dont Google et Nvidia, se sont engagés à acheter 26 Md$ d'actions sans droit de vote au prix de l'introduction. Fortune évoque une valorisation allant jusqu'à 1 400 Md$ sur base entièrement diluée ; MEXC calcule environ 916 à 1 020 Md$ sur les actions en circulation après l'opération : l'écart tient à la base de calcul. Le dépôt fait état d'un chiffre d'affaires annualisé d'environ 81 Md$ fin octobre, contre 71 Md$ fin septembre. Il comporte aussi un facteur de risque selon lequel l'entreprise pourrait atteindre « imminemment » un seuil de sa Responsible Scaling Policy lié à l'auto-amélioration récursive (Fortune). Cotation au Nasdaq sous le code ANT ; 22 banques, Goldman Sachs et Morgan Stanley en tête. La presse anticipe une première cotation vers les 18-19 novembre, date non confirmée par l'émetteur.
   *Ce que ça change pour une grande banque d'investissement :* l'opération teste la capacité du marché à absorber plus de 60 Md$ dans un secteur en correction ; ses conditions de prix serviront de référence pour l'introduction d'OpenAI annoncée pour 2027. Côté fournisseur, la publication trimestrielle à venir donnera une visibilité inédite sur la santé financière d'un éditeur de modèles critique. Le facteur de risque sur l'auto-amélioration devra être lu par les comités de risque de modèle.

3. **La Fed place l'IA en tête des risques pour la stabilité financière (statut : rapport de stabilité financière publié le 13 novembre).** Selon le compte rendu de CASRAI, le rapport (données arrêtées au 28 octobre) juge les valorisations toujours élevées, en partie du fait de l'engouement pour la « super intelligence ». Dans une enquête du personnel de la Fed de New York auprès de 23 contacts de marché, l'IA est le risque le plus cité, avec trois préoccupations : une correction des actions, la cybersécurité (y compris liée aux modèles de pointe) et les montages de financement complexes. Un encadré chiffre les émissions de dette liée au calcul avancé à plus de 680 Md$ à fin octobre 2026, soit environ 31 % des émissions investment grade non financières, contre moins de 6 % en 2023. Les baux non encore commencés dépasseraient 1 000 Md$, et les plus grandes holdings bancaires américaines auraient près de 1 000 Md$ d'expositions sur les grands groupes technologiques, les promoteurs de data centers, leurs véhicules ad hoc, le crédit privé et les services publics. Nous n'avons pas pu consulter directement le document de la Fed ; ces chiffres sont rapportés par CASRAI.
   *Ce que ça change pour une grande banque d'investissement :* l'exposition au cycle de l'IA ne se limite plus aux actions. Elle passe par le crédit, les garanties de valeur résiduelle et les engagements de type « take-or-pay ». Les fonctions risques ont intérêt à consolider ces expositions indirectes avant que les superviseurs ne le demandent.

4. **Modèles de pointe : Anthropic et Google relancent la course prix-performance (statut : disponibles ; Mythos 5.2 en accès restreint).** **Anthropic** a lancé le 9 novembre Claude Fable 5.2, disponible sur ses plateformes, AWS, Google Cloud et Azure, à 8 $ / 40 $ par million de jetons en entrée et en sortie, avec un mode rapide à 16 $ / 80 $. Claude Mythos 5.2, même modèle sans certaines restrictions cyber et biologie, est réservé aux organisations agréées via ses programmes Life Sciences et Cyber Verification. Benchmarks auto-déclarés : 49,1 % sur FrontierCode 2.0 pour Fable 5.2 et 89,6 % sur CVE Rediscovery pour Mythos 5.2 (TestingCatalog). Selon SemiAnalysis (relayé par AISDG), le coût par tâche augmenterait néanmoins de 31 % sur son test de tâches professionnelles, malgré un prix unitaire plus bas. **Google** a lancé le 12 novembre Gemini 4 Hydrogen, modèle rapide et économique pour le code et les agents, à 1,50 $ / 7,50 $ par million de jetons (benchmarks auto-déclarés). Google prévoit aussi de doubler les prix de Gemini 4 Carbon et Argon au 1er décembre (note.com).
   *Ce que ça change pour une grande banque d'investissement :* le prix unitaire ne suffit plus à comparer les modèles ; c'est le coût par tâche, qui dépend de la consommation de jetons, qu'il faut mesurer sur les cas d'usage internes. Les hausses tarifaires annoncées chez Google rappellent que les conditions des API peuvent changer à 30 jours : les contrats doivent prévoir des clauses de stabilité de prix.

5. **Fuite chez Fireworks AI : les données de clients d'un hébergeur d'inférence exposées (statut : incident d'octobre, divulgué les 9-10 novembre).** Fireworks AI, qui sert des modèles à poids ouverts pour des éditeurs comme Notion ou Cursor, a publié un nouvel avis de sécurité. Un fournisseur cloud tiers hébergeant ses machines de R&D a été compromis le 23 octobre, et l'intrus a atteint ses machines de développement (le 23 ou le 24 selon les sources). Ont été exposés des métadonnées, des données de facturation, ainsi que des jeux de données et des poids de modèles incomplets de certains clients (BleepingComputer, 10 novembre). Notion a confirmé que moins de 1 % de ses espaces de travail sont concernés : des conversations Notion AI complètes, le plus souvent sans métadonnées permettant d'identifier l'utilisateur. Notion s'est déconnecté de Fireworks le 3 novembre.
   *Ce que ça change pour une grande banque d'investissement :* les données confiées à un éditeur SaaS peuvent transiter par des sous-traitants d'inférence de rang 2 ou 3, invisibles dans les contrats. La cartographie des sous-traitants d'IA de chaque fournisseur, avec droit d'audit et notification d'incident, devient une exigence de base pour le risque tiers (et, dans l'UE, pour DORA).

## 1. Modèles et laboratoires

- **Fable 5.2, Mythos 5.2, Gemini 4 Hydrogen** : voir fait n° 4.
- **Google DeepMind** : AlphaGenome 2 (11 novembre), accessible par API pour la recherche non commerciale et en préversion privée pour la recherche commerciale. Gemini Robotics 2.5 (10 novembre), en déploiement auprès de partenaires (tracker No Code MBA).

## 2. Infrastructure et compute

- **CoreWeave** (résultats du T3 le 10 novembre) : chiffre d'affaires de 3,66 Md$ (+168 %), perte nette de 709 M$ et charges d'intérêts de 846 M$. Le carnet de commandes atteint environ 132,5 Md$. La prévision 2026 est relevée à 13,0-13,3 Md$ de chiffre d'affaires, avec un capex de 37 à 39 Md$. OpenAI, Perplexity, Cohere et Jane Street figurent parmi les nouveaux contrats ; une émission convertible d'environ 4,2 Md$ a été réalisée.
- **Cisco** (T1 de l'exercice 2027, 12 novembre, communiqué déposé à la SEC) : chiffre d'affaires de 18,5 Md$ (+24 %), réseau +43 %. Cisco relève à 9 Md$ son objectif de revenus d'infrastructure IA auprès des hyperscalers pour l'exercice 2027, plus du double de l'exercice 2026, et sa prévision annuelle à 74,8-75,8 Md$.
- **SpaceX** (12 novembre, Reuters) : plus de 74 Md$ pour deux campus de supercalcul, plus de 24 Md$ à Starbase (Texas) avec une centrale au gaz dédiée, et environ 50 Md$ dans le comté de Cochise (Arizona). Le projet d'Arizona attend un permis du comté, avec une audience publique en décembre et une pétition d'opposition.
- **SoftBank** : charge de 3,7 Md$ après la révision de commandes d'équipements électriques pour data centers (Semafor, relayé par The Neuron ; non vérifié dans le document de SoftBank).

## 3. Adoption en entreprise (focus banque et finance)

- **OpenAI, ChatGPT Wallet** (13 novembre) : déploiement progressif aux États-Unis pour les abonnés Pro, avec American Express, Mastercard et Visa. Chaque achat effectué par l'agent est validé par biométrie, avec un identifiant de paiement de substitution.
- **United Airlines** (11 novembre, CNBC relayé par AISDG) : ses conditions de transport interdisent désormais aux agents d'IA non autorisés de réserver ou de modifier des billets, sous peine d'annulation et de retrait des miles.
- **Anthropic** : Claude Managed Agents en mode auto-hébergé, en bêta privée, qui permet d'exécuter les agents et de stocker l'historique sur ses propres serveurs (annonce relayée par The Neuron le 13 novembre).

## 4. Régulation et politique publique

- **États-Unis, Fed** : voir fait n° 3. Aucune autre mesure fédérale nouvelle repérée.
- **UE–Royaume-Uni** : lors du sixième forum de régulation financière (Bruxelles, 10 novembre ; déclaration publiée le 11), les deux parties ont pris acte de l'évolution des risques cyber et opérationnels, « y compris l'IA ». Aucun engagement chiffré.
- **AI Act** : rien de nouveau cette semaine. Rappel : le 2 décembre, fin du délai de marquage prévu par l'article 50(2) pour les systèmes déjà sur le marché avant le 2 août (Reed Smith).
- **Chine** : rien de significatif vérifié cette semaine.

## 5. Agents et outils de développement

- **OpenAI** (12 novembre, événement « Cyber at the Frontier ») : Daybreak Red Team, en accès anticipé sur candidature, et Daybreak Defense Factory, en préversion de recherche via le marketplace de plugins Codex. Les correctifs proposés sont revus par des ingénieurs avant déploiement ; prix non communiqués. Aucun nouveau modèle n'a été annoncé.
- **OpenAI, Businesses in ChatGPT** (10 novembre, bêta) : les entreprises peuvent revendiquer une fiche et déployer un agent commercial, réservé pour l'instant aux commerçants en ligne américains.

## 6. Recherche

- **Balestriero, Varaku, LeCun, « Counterfactual World Models: Natura Non Facit Saltus »** (révélé par The Register le 9 novembre). Les auteurs sont affiliés à Brown University, à NYU et à AMI Labs. Le papier propose une règle de prédiction contrefactuelle pour les modèles de monde : le résultat observé, corrigé de l'écart prédit entre l'action alternative et l'action prise. Elle est conçue pour les modèles de type JEPA mais vaut, selon eux, pour tout modèle prédisant l'état moyen suivant. Sur des tâches simulées, les auteurs annoncent 35 à 69 % d'objectifs atteints, contre 14 à 23 % pour un planificateur connaissant le vrai simulateur mais ignorant les résultats observés. Préprint non évalué par les pairs ; mise en ligne sur arXiv annoncée pour la semaine, mais non vérifiée dans nos sources (n/c).
- **Rattrapage, Balestriero et LeCun, « Proving and Improving the Platonic Representation Hypothesis with JEPAs »** (arXiv 2610.39302, soumis le 29 octobre ; commenté par la presse spécialisée les 5 et 8 novembre). Les auteurs affirment démontrer l'hypothèse de la représentation platonicienne pour les JEPA, et un modèle d'environ 109 M de paramètres dépasserait des modèles jusqu'à 72 Md sur une mesure d'alignement des représentations. Une analyse de Pebblous souligne que le résultat porte sur un seul critère d'alignement, et non sur les capacités linguistiques. Non évalué par les pairs.
- **AMI Labs** : aucune levée ni aucun partenariat nouveau repérés dans la semaine, au-delà du papier ci-dessus.
- **Amazon et University of Washington** (arXiv 2611.12953, date de soumission n/c) : sur 13 jeux de tâches métier, les configurations multi-agents consomment 1,4 à 4,7 fois plus de jetons et prennent 2,6 à 5,8 fois plus de temps, pour des gains généralement faibles (AISDG).

## 7. Sécurité, risques et incidents

- **Fireworks AI / Notion** : voir fait n° 5.
- **Action visant un gel du développement de l'IA de pointe** (déposée le 12 novembre) : Irreplaceable Education Fund, Public Citizen, Heat Initiative et The Alliance for Secure AI assignent Anthropic, Google, Meta, OpenAI et la division IA de SpaceX devant la Cour supérieure de Californie (comté de San Francisco). Fondée sur la loi californienne sur la concurrence déloyale, l'action demande l'arrêt du développement de modèles plus capables que les systèmes existants. Stade : dépôt de la plainte (63 pages ; note.com, The Neuron, d'après Reuters).
- **Fraude au faux PDG par IA** : trois hommes inculpés aux États-Unis pour une escroquerie de 129 M$. Les appelants se faisaient passer pour des dirigeants grâce à des voix ou des images générées ; parmi les victimes figurent une fintech britannique (11,6 M$) et un réseau hospitalier du Missouri (4,8 M$) (TNW, relayé par AISDG).

## 8. Marché et financement

- **Anthropic** : voir fait n° 2.
- **Nvidia–Hugging Face** : la clôture du rachat annoncé de 12,9 Md$ reste attendue en 2027 malgré le changement de direction (TechCrunch, 12 novembre, relayé par The Neuron).
- **OpenAI** : montant final du tour à 1 250 Md$ de valorisation non confirmé (n/c).

## 9. Open source

- **Thinking Machines, Inkling 2 Small** : poids publiés sur Hugging Face sous licence Apache 2.0 (annonce de l'entreprise relayée par The Neuron, 12-13 novembre).
- **Runway, Praxis-1** (11 novembre) : 27 Md de paramètres, sous Apache 2.0. **Salesforce, SOV-Transcribe-1** (12 novembre) : reconnaissance vocale à poids ouverts. **MiniMax-H3-Image** (11 novembre) : génération d'images, à poids ouverts.

## À surveiller la semaine prochaine

*Semaine du 16 au 22 novembre 2026.*

- **17 novembre** : résultats du T3 de l'exercice 2027 de Nvidia, communiqué vers 13 h 20 et conférence à 14 h (heure du Pacifique), date confirmée par l'émetteur.
- **17 au 20 novembre** : Microsoft Ignite à San Francisco (dates publiées par plusieurs agendas d'événements).
- **Probable, non confirmé** : fixation du prix et première cotation d'Anthropic au Nasdaq, que la presse situe vers les 18-19 novembre (Fortune, MEXC).
- **Horizon** : 1er décembre, doublement des prix de Gemini 4 Carbon et Argon ; 2 décembre, échéance de l'AI Act (article 50(2)) ; 9 décembre, examen de l'abattement fiscal du campus de Starbase  ; décembre, audience du comté de Cochise sur le campus d'Arizona.

L'Hebdo des Machines

## Sources

- [NVIDIA Announces CEO Transition — Nvidia](https://nvidianews.nvidia.com/news/nvidia-announces-ceo-transition)
- [Nvidia confirms Jensen Huang has resigned as CEO — Tom's Hardware](https://www.tomshardware.com/tech-industry/nvidia-confirms-jensen-huang-has-resigned-as-ceo-colette-kress-executive-vice-president-and-chief-financial-officer-appointed-interim-ceo)
- [Nvidia CEO Jensen Huang resigns — ABC News](https://abcnews.com/Business/nvidia-ceo-jensen-huang-resigns-amid-alleged-affair/story?id=138076256)
- [Anthropic sets IPO range valuing it at up to $1.4 trillion — Fortune](https://fortune.com/2026/11/10/anthropic-ipo-price-range-ai-stock-sell-off/)
- [Anthropic IPO Roadshow: $70–$78 Price Range — MEXC](https://www.mexc.com/learn/article/anthropic-ipo-roadshow)
- [Fed report: AI valuations and data center debt — CASRAI](https://casrai.org/news/federal-reserve-financial-stability-report-ai-november-2026)
- [Anthropic introduces Claude Fable 5.2, Mythos 5.2 — SD Times](https://sdtimes.com/ai/anthropic-introduces-claude-fable-5-2-mythos-5-2/)
- [Anthropic ships Claude Fable 5.2 and vetted-tier Mythos 5.2 — AI Weekly](https://aiweekly.co/alerts/anthropic-ships-claude-fable-52-and-vetted-tier-mythos-52)
- [Anthropic launches Claude Fable 5.2 and Mythos 5.2 — TestingCatalog](https://www.testingcatalog.com/anthropic-launches-claude-fable-5-2-and-mythos-5-2/)
- [AI Tech Morning Paper, November 13, 2026 — note.com](https://note.com/jsn525/n/n02bf9ce89f07?hl=en)
- [Fireworks AI discloses new breach after cloud provider hack — BleepingComputer](https://bleepingcomputer.com/news/security/fireworks-ai-discloses-new-breach-after-cloud-provider-hack)
- [Fireworks AI Hit by Second Breach — eSecurity Planet](https://www.esecurityplanet.com/threats/news-fireworks-ai-second-breach-notion-chat-transcripts/)
- [Notice about the Fireworks AI incident — Notion](https://notion.com/help/security-incident-involving-a-third-party-ai-vendor)
- [AI Release Tracker — No Code MBA](https://www.nocode.mba/ai-release-tracker)
- [OpenAI release notes — Releasebot](https://releasebot.io/updates/openai)
- [CoreWeave Reports Strong Third Quarter 2026 Results — CoreWeave](https://investors.coreweave.com/news/news-details/2026/CoreWeave-Reports-Strong-Third-Quarter-2026-Results/default.aspx)
- [Cisco Q1 FY2027 results, Form 8-K exhibit 99.1 — SEC](https://www.sec.gov/Archives/edgar/data/0000858877/000085887726000170/exhibit991pressrelease-q1f.htm)
- [SpaceX to invest over $74 billion in supercompute facilities (Reuters) — The Star](https://www.thestar.com.my/tech/tech-news/2026/11/13/spacex-to-invest-over-74-billion-in-supercompute-facilities-in-texas-arizona)
- [Everything That Happened in AI Today, Friday November 13 — The Neuron](https://www.theneuron.ai/digest/everything-that-happened-in-ai-today-friday-november-13-2026/)
- [AI News for November 13, 2026 — AISDG](https://aisdg.substack.com/p/ai-news-for-november-13-2026)
- [GPT-6.2 Did Not Ship: What OpenAI Launched on 12 Nov — OrcaRouter](https://www.orcarouter.ai/blog/gpt-6-2-cyber-at-the-frontier-no-show)
- [Joint EU-UK Financial Regulatory Forum, November 2026 — GOV.UK](https://www.gov.uk/government/publications/joint-statement-eu-uk-financial-regulatory-forum-november-2026/joint-eu-uk-financial-regulatory-forum-november-2026)
- [Transparency obligations for AI-generated content — Reed Smith](https://www.reedsmith.com/our-insights/blogs/viewpoints/102nbz0/transparency-obligations-for-ai-generated-content-the-code-of-practice-adequacy/)
- [Insight about how nature makes no leaps promises better robot predictions — The Register](https://www.theregister.com/ai-and-ml/2026/11/09/insight-about-how-nature-makes-no-leaps-promises-better-robot-predictions/5308301)
- [Yann LeCun JEPA Paper, Explained — Pebblous](https://blog.pebblous.ai/report/lecun-platonic-representation-good-views/en/)
- [Yann LeCun's JEPA Paper — MindStudio](https://www.mindstudio.ai/blog/yann-lecun-jepa-world-model-paper)
- [Microsoft Ignite 2026 (17 to 20 November) — eCorpIT](https://ecorpit.com/microsoft-ignite-2026-azure-ai-agents-watchlist/)
