# NFDI4Objects Property Graph

Dieses Repositoriy enthält Skripte und [Dokumentation](#handbuch) zur
Erstellung, Management und Nutzung des NFDI4Objects Knowledge Graphen von TA5.

*Zur Einführung in Property Graphen [siehe dieser Artikel](https://jakobib.github.io/pgraphen2024/) <https://doi.org/10.5281/zenodo.10971391>.*

## Installation

Benötigt werden eine Standard-Unix-Tools sowie Docker, Perl (ohne zusätzliche
Libraries) und Python3. Anschließend die weitere Abhängigkeiten:

Python-Umgebung

~~~sh
sudo apt install python3-venv
python3 -m venv venv
venv/bin/pip install -r requirements.txt
~~~

Node-Programme [pgraphs](https://www.npmjs.com/package/pgraphs)
und  [mermaid-cli](https://www.npmjs.com/package/@mermaid-js/mermaid-cli):

~~~sh
npm install pgraphs
npm install mermaid-cli
~~~

jq: `sudo apt-get install jq`

Quarto: siehe <https://quarto.org/docs/get-started/>

## Handbuch

Das Verzeichnis [`manual`](manual) enthält den Quelltext des Handbuchs für den
NFDI4Objects Knowledge Graphen (Quarto Markdown-Dateien mit der Endung `.qmd`).
Das Handbuch ist mit [quarto](https://quarto.org/) erstellt und enthält
Code-Beispiele in Cypher, SPARQL und Python.

Zur Aktualisierung der HTML-Version des Handbuch wird außerdem Jupyter Notebook
benötigt (Installation z.B. via `sudo apt install jupyter-notebook`).
Anschließend kann es mit `quarto render` im Ordern `manual` (bzw. `make docs`
im Wurzelverzeichnis) aktualisiert werden. Die HTML-aktualisierte HTML-Version
wird ins [`docs`](docs) geschrieben und von dort unter Anderem unter
<https://nfdi4objects.github.io/n4o-property-graph/> veröffentlicht.

