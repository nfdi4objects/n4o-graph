# NFDI4Objects Graph

Dieses Repositoriy enthält Skripte und [Dokumentation](#handbuch) zur
Erstellung, Management und Nutzung des NFDI4Objects Knowledge Graphen von TA5.

## Übersicht

- Verzeichnis [voc](voc) enthält Informationen zu unterstützen Ontologien und
  Normdateien.

- Verzeichnis [manual](manual) enthält den Quelltext des Handbuchs, das
  lokal mit `make docs` oder auf GitHub nach jedem Commit auf dem `main` Branch
  gebaut und unter <https://nfdi4objects.github.io/n4o-graph/> publiziert wird.

- ...

## Installation

Benötigt werden eine Standard-Unix-Tools sowie Docker, Python3 und Node >= v18.
Anschließend die weitere Abhängigkeiten:

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

## Lizenz

Alle Inhalte und Beiträge in diesem Repository können als *Public Domain* frei
verwendet werden ([CC Zero](https://creativecommons.org/publicdomain/zero/1.0/)).
