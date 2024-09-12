# NFDI4Objects Graph

> Skripte und [Dokumentation](#handbuch) zur Erstellung, Management und Nutzung des N4O Knowledge Graphen

[![Status](https://github.com/nfdi4objects/n4o-graph/actions/workflows/quarto-publish.yml/badge.svg)](https://nfdi4objects.github.io/n4o-graph/)

Das [Handbuch](https://nfdi4objects.github.io/n4o-graph/) enthält eine
Beschreibung der Konzepte, Architektur und Workflows des Knowledge Graphen.
Die Dokumentation wird aus Markdown-Quelltexten im Verzeichnis
[manual](manual) erstellt (lokale mit Aufruf von `make docs` oder
auf GitHub nach jedem Commit auf dem `main` Branch).

Das Handbuchs dient gleichzeitig als Integrationstest für den Knowledge Graphen.

## Installation

Benötigt werden eine Standard-Unix-Tools (incl. curl und jq):

~~~sh
sudo apt install curl jq
~~~

Sowie Docker, Python3, Node >= v18 (deren Installation hier nicht erklärt).

Anschließend müssen weitere Python- und Node-Bibliotheken installiert werden:

~~~sh
sudo apt install python3-venv
python3 -m venv .venv
. .venv/bin/activate
pip install -r requirements.txt
~~~

Node-Programme [pgraphs](https://www.npmjs.com/package/pgraphs)
und  [mermaid-cli](https://www.npmjs.com/package/@mermaid-js/mermaid-cli)
(letzteres nur falls die Dokumentation neu erstellt werden soll):

~~~sh
npm install pgraphs
npm install mermaid-cli
~~~

## Konfiguration und Starten der Datenbanken

Die Datei [neo4j.json](neo4j.json) enthält die interne und externe
Konfiguration für eine oder zwei Neo4j-Datenbanken:

- `uri`, `url`, `user`, `password`: Interne Zugangsdaten für temporäre Datenbank
- `public`: Öffentliche API (Lese-Zugriff)

Zum Starten eines Docker-Containers mit der internen Neo4j-Datenbank:

~~~sh
./neo4j.sh start neo4j.json
~~~

Zur Installation eines RDF-Triple-Stores mit Fuseki gibt es [hier ein Debian-Paket](https://github.com/gbv/fuseki.deb/releases). In Fuseki muss zunächst eine Datenbank erstellt werden, z.B. `n4o-rdf-import`:

~~~sh
curl --data "dbName=n4o-rdf-import&dbType=tdb2" http://localhost:3030/$/datasets
~~~

Zusätzlich muss die Konfiguration der Datenbank so erweitert werden, dass der Default Graph alle Teilgraphen umfasst:

~~~turtle
# In Datei /etc/fuseki/configuration/n4o-rdf-import.ttl

:tdb_dataset_readwrite tdb2:unionDefaultGraph true .
~~~

## Import von Daten

Siehe Repository [n4o-import](https://github.com/nfdi4objects/n4o-import).

## Expansion der Klassenhierarchie

Aufruf via

~~~sh
./venv/bin/python ./pg-expand-labels.py -c neo4j.json < crm-expand.txt
~~~

Wobei in `neo4j.json` (bzw. einer anderen Konfigurationsdatei) die Verbindungsdaten zur jeweiligen Neo4J-Datenbank stehen müssen.

## Sonstiges

Verzeichnis [voc](voc) enthält Informationen zu unterstützen Ontologien und Normdateien.

## Lizenz

Alle Inhalte und Beiträge in diesem Repository können als *Public Domain* frei
verwendet werden ([CC Zero](https://creativecommons.org/publicdomain/zero/1.0/)).
