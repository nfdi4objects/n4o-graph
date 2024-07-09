#!/usr/bin/bash
set -eou pipefail

usage() {
  echo "Usage: $0 [start|status] CONFIG [CONTAINER_NAME]"
  echo "Examples:"
  echo "   $0 start neo4j.json neo4j"
  echo "   $0 status neo4j.json"
  exit 1
}

error() {
  echo "$@" >&2
  exit 1
}

[[ ${1:-} =~ ^(start|status)$ ]] || usage

cmd=$1
config=${2:-}
name=${3:-neo4j}

[[ -f "$config" ]] || error "Missing config file $config"


# Get settings from config file
apiport=$(jq -r '.uri|split(":")[2] // 7687' "$config")
webport=$(jq -r '.url|split(":")[2] // 7474' "$config")
user=$(jq -r .user "$config")
password=$(jq -r .password "$config")

# start new docker container
if [[ $cmd == "start" ]]; then
    cwd=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

    mkdir -p "$cwd/data"
    mkdir -p "$cwd/import"

    echo "Starting Neo4j container $name at port $apiport and http://localhost:$webport/"

    docker run -d \
        --name=$name \
        --publish=$webport:7474 --publish=$apiport:7687 \
        --env NEO4J_AUTH=none \
        --user $(id -u):$(id -g) \
        --volume=$cwd/data:/data \
        --volume=$cwd/import:/var/lib/neo4j/import \
        neo4j 

else
    bolt=$(jq -r '.uri|sub("^neo4j";"http")|if test(":[0-9]+";"i") then . else (.+":7687") end' "$config")
    curl -s "$bolt" || error "No Neo4j API available at $bolt"
    echo "Neo4j API seems to be available at $bolt"

    # TODO: check docker container?
fi
