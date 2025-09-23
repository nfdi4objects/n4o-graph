#!/usr/bin/bash
set -euo pipefail

[ -d .venv ] || python3 -m venv .venv && .venv/bin/pip3 install rdflib

importer=http://localhost:5020/
apis=http://localhost:8000/

POST() { curl --silent --fail -X POST "$@"; }
PUT() { curl --silent --fail -X PUT "$@"; }
download() { wget --quiet -N --no-if-modified-since "$@"; } 

echo "## Register terminologies"
PUT -d @terminologies.json ${importer}terminology/ | jq -r '.[]|[.uri,.prefLabel.en]|@tsv'
echo
echo "## Receive and load CIDOC-CRM"
POST ${importer}terminology/1644/receive?from=https://raw.githubusercontent.com/nfdi4objects/crm-rdf-ap/refs/heads/main/cidoc-crm.rdf
POST ${importer}terminology/1644/load
echo
echo "## Download and extract AAT hierarchy and terms"
download http://aatdownloads.getty.edu/VocabData/explicit.zip

unzip -p explicit.zip AATOut_HierarchicalRels.nt | \
    awk '$2~/broader/ {print $1" <http://www.w3.org/2004/02/skos/core#broader> "$3"."}' > ../data/aat.nt
wc -l ../data/aat.nt

# try to minimize triples to be processed
unzip -o explicit.zip AATOut_2Terms.nt
<AATOut_2Terms.nt awk '$2=="<http://www.w3.org/2008/05/skos-xl#prefLabel>"' | grep '-en>' > aat-xlabels-en.nt
<AATOut_2Terms.nt awk '$2=="<http://vocab.getty.edu/ontology#term>"' | grep '@en\s*\.\s*$' >> aat-xlabels-en.nt
wc -l aat-xlabels-en.nt
.venv/bin/python extract-xlabels-en.py < aat-xlabels-en.nt > aat-labels-en.nt
wc -l aat-labels-en.nt
cat aat-labels-en.nt >> ../data/aat.nt
wc -l ../data/aat.nt

echo
echo "## Receive and load AAT"
POST ${importer}terminology/75/receive?from=aat.nt
POST ${importer}terminology/75/load

echo
echo "## Receive and load KENOM Material"
url=https://api.dante.gbv.de/export/download/kenom_material/default/kenom_material__default.jskos.ndjson
POST ${importer}terminology/20533/receive?from=$url
POST ${importer}terminology/20533/load

echo
echo "## Download and extract embedded 1-to-1 mappings from KENOM Material"
download $url
jq -r '.mappings|select(.)|.[]|"<\(.from.memberSet[0].uri)> <\(.type[0])> <\(.to.memberSet[0].uri)> ."' \
    kenom_material__default.jskos.ndjson > ../data/kenom_material-mappings.nt

# TODO: register, receive and load mappings

