---
name: transport-paris-idf
description: Interact with the IDF Mobilité transport network (Metro and Bus) in Paris/Ile-de-France
metadata: {"nanobot":{"emoji":"🚌"}}
---
# Skill: IDF Mobilité Transport CLI

This skill allows an AI agent to interact with the IDF Mobilité transport network (Metro and Bus) in Paris/Ile-de-France to search for stations and retrieve real-time schedules using the `idfm-transport-cli.sh` script.

## Capabilities

- Search for Metro stations by name.
- Search for Bus stations by name.
- Retrieve real-time upcoming departures (horaires) for a specific station ID.

## Usage

All commands are executed via the `{baseDir}/scripts/idfm-transport-cli.sh` script. The output is always in JSON format, making it easy to parse and process.

### 1. Searching for Stations

To find the IDs of a station (required for fetching schedules), use the `stations` command.

**Metro stations:**
```bash
{baseDir}/scripts/idfm-transport-cli.sh stations metro "Châtelet"
```

**Bus stations:**
```bash
{baseDir}/scripts/idfm-transport-cli.sh stations bus "Mairie de Montreuil"
```

**RER stations:**
```bash
{baseDir}/scripts/idfm-transport-cli.sh stations rer "Nation"
```

**Output format:**
A JSON array of objects:
```json
[
  {
    "type_reseau": "Metro",
    "numero_ligne": "1",
    "id_ligne": "C01371",
    "id_station": "47391",
    "nom_station": "Châtelet"
  }
]
```
*Note: The `id_station` is the value needed for the `horaires` command.*

### 2. Retrieving Real-time Schedules

For each `id_station`, use the `horaires` command to get the next departures.

```bash
{baseDir}/scripts/idfm-transport-cli.sh horaires <id_station>
```

**Example:**
```bash
{baseDir}/scripts/idfm-transport-cli.sh horaires 47391
```

**Output format:**
A JSON array of departures:
```json
[
  {
    "DirectionName": "Château de Vincennes",
    "StopPointName": "Châtelet",
    "VehicleAtStop": false,
    "ExpectedArrivalTime": "2026-03-22T14:35:00.000Z",
    "DirectionRef": "Aller"
  }
]
```

## Guidelines for the AI Agent

1.  **Search First:** Always search for the station using `stations metro` or `stations bus` before attempting to get schedules, unless the `id_station` is already known.
2.  **Handle Multiple Results:** The search might return multiple lines for the same station name (e.g., Châtelet has lines 1, 4, 7, 11, 14). Filter the results based on the user's specific line if mentioned.
3.  **Data Source:** The script uses a local dataset `datasets/arrets-lignes.csv` for station lookups and makes live API calls to IDF Mobilité for schedules. Ensure the dataset exists.
4.  **Error Handling:** If a command returns an empty array `[]`, inform the user that no stations or schedules were found for the given input.
