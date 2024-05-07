# NFDI4Objects Property Graph

Dieses Repositoriy enthält Skripte und [Dokumentation](#handbuch) zur
Erstellung, Management und Nutzung des NFDI4Objects Knowledge Graphen von TA5.

## Installation

Benötigt werden eine Standard-Unix-Tools sowie Docker, Perl (ohne zusätzliche
Libraries), Python3 und Node >= v18. Anschließend die weitere Abhängigkeiten:

Python-Umgebung

~~~sh
sudo apt install python3-venv
python3 -m venv venv
venv/bin/pip install -r requirements.txt
~~~

Node-Programme [pgraphs](https://www.npmjs.com/package/pgraphs)
und  [mermaid-cli](https://www.npmjs.com/package/@mermaid-js/mermaid-cli)
(letzteres nur falls die Dokumentation neu erstellt werden soll):

~~~sh
npm install pgraphs
npm install mermaid-cli
~~~

jq: `sudo apt-get install jq`

## Handbuch

Das Verzeichnis [`manual`](manual) enthält den Quelltext des Handbuchs für den
NFDI4Objects Knowledge Graphen (Quarto Markdown-Dateien mit der Endung `.qmd`).
Das Handbuch ist mit [quarto](https://quarto.org/) erstellt und enthält
Code-Beispiele in Cypher, SPARQL und Python.

Die HTML-Version des Handbuch kann mit `quarto render` im Ordern `manual` (bzw.
`make docs` im Wurzelverzeichnis) aktualisiert werden. Das aktualisierte
Handbuch wird ins Verzeichnis [`docs`](docs) geschrieben und von dort unter
Anderem unter <https://nfdi4objects.github.io/n4o-property-graph/>
veröffentlicht.

