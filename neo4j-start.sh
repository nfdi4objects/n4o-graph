#!/usr/bin/bash
# start new docker container
set -eou pipefail

if [ $# == 0 ]; then
  echo "Usage: $0 CONFIG [CONTAINER]"
  echo "Example: $0 neo4j.json neo4j"
  exit
fi

config=$1
name=${2:-neo4j}

# Get settings from config file
apiport=$(jq -r '.uri|split(":")[2] // 7474' "$config")
webport=$(jq -r '.url|split(":")[2] // 7687' "$config")
user=$(jq -r .user "$config")
password=$(jq -r .password "$config")

cwd=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

docker run -d \
    --name=$name \
    --publish=$apiport:7474 --publish=$webport:7687 \
    --env NEO4J_AUTH=none \
    --user $(id -u):$(id -g) \
    --volume=$cwd/data:/data \
    neo4j 

# --volume=$cwd/import:/var/lib/neo4j/import \

mkdir -p "$cwd/data"
mkdir -p "$cwd/import"
