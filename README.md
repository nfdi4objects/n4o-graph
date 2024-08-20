# NFDI4Objects Graph

Dieses Repositoriy enthält Skripte und [Dokumentation](#handbuch) zur
Erstellung, Management und Nutzung des NFDI4Objects Knowledge Graphen von TA5.

Das Handbuch enthält eine Beschreibung der Architektur und Workflows des
Knowledge Graphen und Abfrage-Beispiele in Cypher und SPARQL in Python und
JavaScript.

## Übersicht

- Verzeichnis [voc](voc) enthält Informationen zu unterstützen Ontologien und
  Normdateien.

- Verzeichnis [manual](manual) enthält den Quelltext des Handbuchs, das
  lokal mit `make docs` oder auf GitHub nach jedem Commit auf dem `main` Branch
  gebaut und unter <https://nfdi4objects.github.io/n4o-graph/> publiziert wird.
  [![Status](https://github.com/nfdi4objects/n4o-graph/actions/workflows/quarto-publish.yml/badge.svg)](https://nfdi4objects.github.io/n4o-graph/)

- Verzeichnis [import](import) wird temporär für Importe in den Graphen verwendet.

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

## Konfiguration und Starten der Datenbank

Die Datei [neo4j.json](neo4j.json) enthält die interne und externe
Konfiguration für eine oder zwei Neo4j-Datenbanken:

- `uri`, `url`, `user`, `password`: Interne Zugangsdaten für temporäre Datenbank
- `public`: Öffentliche API (Lese-Zugriff)

Zum Starten eines Docker-Containers mit der internen Neo4j-Datenbank:

~~~sh
./neo4j.sh start neo4j.json
~~~

## Import von Daten

*Muss noch dokumentiert werden*

## Expansion der Klassenhierarchie

Aufruf via

~~~sh
./venv/bin/python ./pg-expand-labels.py -c neo4j.json < crm-expand.txt
~~~

Wobei in `neo4j.json` (bzw. einer anderen Konfigurationsdatei) die Verbindungsdaten zur jeweiligen Neo4J-Datenbank stehen müssen.

## Lizenz

Alle Inhalte und Beiträge in diesem Repository können als *Public Domain* frei
verwendet werden ([CC Zero](https://creativecommons.org/publicdomain/zero/1.0/)).
