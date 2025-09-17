#!/usr/bin/bash
set -euo pipefail

importer=http://localhost:5020/
apis=http://localhost:8000/

POST() { curl --silent --fail -X POST "$@"; }
PUT() { curl --silent --fail -X PUT "$@"; }
download() { wget --quiet -N --no-if-modified-since "$@"; } 

echo "## Register terminologies"
PUT -d @terminologies.json ${importer}terminology/ | jq -r '.[]|[.uri,.prefLabel.en]|@tsv'
echo
echo "## Download and extract AAT hierarchy"
download http://aatdownloads.getty.edu/VocabData/explicit.zip
unzip -p explicit.zip AATOut_HierarchicalRels.nt | \
    awk '$2~/broader/ {print $1" <http://www.w3.org/2004/02/skos/core#broader> "$3"."}' > ../data/aat-hierarchy.nt
wc -l ../data/aat-hierarchy.nt

# TODO extract and filter AAT labels (English)

echo
echo "## Receive and load AAT"
POST ${importer}terminology/75/receive?from=aat-hierarchy.nt
POST ${importer}terminology/75/load

echo
echo "## Receive and load KENOM Material"
url=https://api.dante.gbv.de/export/download/kenom_material/default/kenom_material__default.jskos.ndjson
POST ${importer}terminology/20533/receive?from=$url
POST ${importer}terminology/75/load

echo
echo "## Download and extract embedded 1-to-1 mappings from KENOM Material"
download $url
jq -r '.mappings|select(.)|.[]|"<\(.from.memberSet[0].uri)> <\(.type[0])> <\(.to.memberSet[0].uri)> ."' \
    kenom_material__default.jskos.ndjson > ../data/kenom_material-mappings.nt

# TODO: register, receive and load mappings

