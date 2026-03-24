#!/bin/bash

# idfm-transport-cli.sh - CLI pour les transports IDF Mobilité
Here=`dirname $0`
datafile="${Here}/datasets/arrets-lignes.csv"

# --- Fonctions de formatage ---

format_to_json() {
    # Transforme une sortie CSV (séparateur ;) en JSON
    # Champs: type_reseau;numero_ligne;id_ligne;id_station;nom_station
    jq -R -n '
        [ inputs 
          | split(";") 
          | select(length >= 4) 
          | {
              type_reseau: .[0],
              numero_ligne: .[1],
              id_ligne: .[2],
              id_station: .[3],
              nom_station: .[4]
            }
        ]
    '
}

# --- Fonctions métier à implémenter ---

recherche_stations() {
    local type_reseau="$1"
    local station_name="$2"

    if [ -z "$datafile" ]; then
        echo "[]"
        return
    fi

    if [ ! -f "$PRIM_API_KEY" ]; then
        echo "PRIM_API_KEY non renseignée."
        exit 1
    fi

    # Recherche dans arrets-lignes.csv et formatage vers 5 champs
    awk -F';' -v station="$station_name" -v reseau="$type_reseau" '
        tolower($4) == tolower(station) && $10 == reseau {
            # type_reseau; numero_ligne; id_ligne; id_station; nom_station
            print $10 ";" $2 ";" $1 ";" $3 ";" $4
        }
    ' "$datafile" | sort -u | sed 's/IDFM://g' | format_to_json
}

recherche_stations_metro() {
    local station_name="$1"
    recherche_stations "Metro" "$station_name"
}

recherche_stations_bus() {
    local station_name="$1"
    recherche_stations "Bus" "$station_name"
}

recherche_stations_rer() {
    local station_name="$1"
    recherche_stations "RapidTransit" "$station_name"
}

get_prochains_horaires() {
    local station_id="$1"
    curl -k -X 'GET' \
        "https://prim.iledefrance-mobilites.fr/marketplace/stop-monitoring?MonitoringRef=STIF%3AStopPoint%3AQ%3A${station_id}%3A" \
        -H 'accept: application/json'  \
        -H "apiKey: $PRIM_API_KEY"
}

# --- Logique CLI ---

usage() {
    echo "Usage: $0 {stations|horaires} [options]"
    echo ""
    echo "Commands:"
    echo "  stations metro <nom_station>    Rechercher des stations de métro"
    echo "  stations bus <nom_station>      Rechercher des stations de bus"
    echo "  stations rer <nom_station>      Rechercher des stations de RER"
    echo "  horaires <id_station>           Obtenir les prochains passages pour une station"
    echo ""
    exit 1
}

if [ $# -lt 1 ]; then
    usage
fi

COMMAND=$1
shift

case "$COMMAND" in
    stations)
        TYPE=$1
        QUERY=$2
        
        if [ -z "$TYPE" ] || [ -z "$QUERY" ]; then
            echo "Erreur: 'stations' nécessite un type (metro/bus/rer) et un nom de station."
            usage
        fi

        case "$TYPE" in
            metro)
                recherche_stations_metro "$QUERY"
                ;;
            bus)
                recherche_stations_bus "$QUERY"
                ;;
            rer)
                recherche_stations_rer "$QUERY"
                ;;
            *)
                echo "Type de station inconnu: $TYPE (valeurs possibles: metro, bus, rer)"
                usage
                ;;
        esac
        ;;

    horaires)
        STATION_ID=$1
        
        if [ -z "$STATION_ID" ]; then
            echo "Erreur: 'horaires' nécessite un ID de station."
            usage
        fi

        get_prochains_horaires "$STATION_ID" | jq '[ .Siri.ServiceDelivery.StopMonitoringDelivery[].MonitoredStopVisit[] | {
  DirectionName: .MonitoredVehicleJourney.DirectionName[0].value,
  StopPointName: .MonitoredVehicleJourney.MonitoredCall.StopPointName[0].value,
  VehicleAtStop: .MonitoredVehicleJourney.MonitoredCall.VehicleAtStop,
  ExpectedArrivalTime: .MonitoredVehicleJourney.MonitoredCall.ExpectedArrivalTime,
  DirectionRef: .MonitoredVehicleJourney.DirectionRef.value
} ]'
        ;;

    *)
        usage
        ;;
esac
