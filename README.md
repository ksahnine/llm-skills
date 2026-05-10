# llm-skills

Collection de **skills** (compétences) pour agents LLM. Chaque skill définit un ensemble de capacités qu'un agent peut exploiter via des scripts shell et des instructions structurées.

## Skills inclus

### 🚇 transport-paris-idf

Interaction avec le réseau de transport **IDF Mobilités** (Métro, Bus, RER) en Île-de-France.

- **Localiser** les stations proches d'une adresse
- **Rechercher** des stations par nom (métro, bus, RER)
- **Consulter** les horaires temps réel d'une plateforme

👉 [`transport-paris-idf/SKILL.md`](transport-paris-idf/SKILL.md)

### 📷 webcam

Capture de photos via la webcam de l'agent en résolution 1280×720.

- Prendre une photo avec `fswebcam`
- Sauvegarder l'image dans `/tmp/image.jpg`

👉 [`webcam/SKILL.md`](webcam/SKILL.md)

## Structure

```
llm-skills/
├── README.md
├── transport-paris-idf/
│   ├── SKILL.md
│   └── scripts/
│       ├── idfm-transport-cli.sh
│       └── .env
└── webcam/
    └── SKILL.md
```

## Utilisation

Chaque skill est auto-documenté dans son propre `SKILL.md`. Pour activer un skill dans un agent compatible, il suffit de lui fournir le contenu du fichier `SKILL.md` correspondant.

## Prérequis

- **transport-paris-idf** : `curl`, `jq`, `awk`
- **webcam** : `fswebcam`
