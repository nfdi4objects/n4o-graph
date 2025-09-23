#!/usr/bin/bash
set -euo pipefail

[ -d .venv ] || python3 -m venv .venv && .venv/bin/pip3 install rdflib

importer=http://localhost:5020/
apis=http://localhost:8000/
DATA=${DATA:-../data}

POST() { curl --silent --fail -X POST "$@"; }
PUT() { curl --silent --fail -X PUT "$@"; }
download() { wget --quiet -N --no-if-modified-since "$@"; } 

foo() {
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
    awk '$2~/broader/ {print $1" <http://www.w3.org/2004/02/skos/core#broader> "$3"."}' > $DATA/aat.nt
wc -l $DATA/aat.nt

# try to minimize triples to be processed
unzip -o explicit.zip AATOut_2Terms.nt
<AATOut_2Terms.nt awk '$2=="<http://www.w3.org/2008/05/skos-xl#prefLabel>"' | grep '-en>' > aat-xlabels-en.nt
<AATOut_2Terms.nt awk '$2=="<http://vocab.getty.edu/ontology#term>"' | grep '@en\s*\.\s*$' >> aat-xlabels-en.nt
wc -l aat-xlabels-en.nt
.venv/bin/python extract-xlabels-en.py < aat-xlabels-en.nt > aat-labels-en.nt
wc -l aat-labels-en.nt
cat aat-labels-en.nt >> $DATA/aat.nt
wc -l $DATA/aat.nt

echo
echo "## Receive and load AAT"
POST ${importer}terminology/75/receive?from=aat.nt
POST ${importer}terminology/75/load

}
echo
echo "## Receive and load KENOM Material"
url=https://api.dante.gbv.de/export/download/kenom_material/default/kenom_material__default.jskos.ndjson
POST ${importer}terminology/20533/receive?from=$url
POST ${importer}terminology/20533/load

echo
echo "## Extract embedded mappings from KENOM Material"
download $url
jq -c '.mappings|select(.)|.[]' "${url##*/}" > $DATA/kenom_material-mappings.ndjson
echo
echo "## Register mappings"
PUT -d @mappings.json ${importer}mappings/

echo "## Receive and load mappings"
POST ${importer}mappings/1/receive?from=kenom_material-mappings.ndjson

POST ${importer}mappings/1/load

