#!/usr/bin/bash
set -euo pipefail

importer=http://localhost:5020/

echo "Register terminologies"
curl --fail -X PUT -d @terminologies.json ${importer}terminology/

echo "Download and extract AAT hierarchy"
wget --quiet -N --no-if-modified-since http://aatdownloads.getty.edu/VocabData/explicit.zip
unzip -p explicit.zip AATOut_HierarchicalRels.nt | \
    awk '$2~/broader/ {print $1" <http://www.w3.org/2004/02/skos/core#broader> "$3"."}' > ../data/aat-hierarchy.nt
wc -l ../data/aat-hierarchy.nt

# TODO: receive and load AAT

# TODO: receive and load KENOM Material

# TODO: register, receive and load mappings between AAT and GND and/or KENOM Material

