# NFDI4Objects Graph

> Technical architecture and documentation of the NFDI4Objects Knowledge Graph

## Components

- [n4o-fuseki](https://github.com/nfdi4objects/n4o-fuseki): RDF triple store
- [n4o-graph-apis](https://github.com/nfdi4objects/n4o-graph-apis): web interface and public SPARQL endpoint
- [n4o-graph-importer](https://github.com/nfdi4objects/n4o-graph-importer): scripts to import data into the triple store
- [lido-rdf-converter](https://github.com/nfdi4objects/lido-rdf-converter): convert LIDO format to RDF

## Data flow

See the [manual](https://nfdi4objects.github.io/n4o-graph/architecture.html) for a data flow diagram.

## Installation

Clone this repository or copy file [`docker-compose.yml`](docker-compose.yml), config file [`config-apis.yml`](config-apis.yml) and referenced `queries` directory to a local directory. Then start a new set of docker containers that make the N4O Knowledge Graph:

~~~sh
docker compose up --force-recreate --remove-orphans -V
~~~

To update the locally cached Docker images, first run:

~~~sh
docker compose pull
~~~

## Usage

By default the web interface of n4o-graph-apis is made public at <http://localhost:8000/> and the web interface of n4o-graph-importer at <http://localhost:5020/>.

## Configuration

The following environment variables can be used for configuration:

- **PORT** - port to publish n4o-graph-apis (public read access)
- **IMPORT** - port to publish n4o-graph-importer (with write access!)
- **STAGE** - stage directory (default: `./stage`)
- **DATA** - data directory (optional, default: `./data`)

## Manual

[![Status](https://github.com/nfdi4objects/n4o-graph/actions/workflows/quarto-publish.yml/badge.svg)](https://github.com/nfdi4objects/n4o-graph/actions/workflows/quarto-publish.yml)

Das Handbuch zum Knowledge Graphen ist mit [quarto](https://quarto.org/) erstellt. Die Quelldateien liegen im Verzeichnis `manual`.

Die HTML-Version des Handbuch kann lokal mit `make docs` im Wurzelverzeichnis aktualisiert werden und liegt anschließend im Verzeichnis `docs`. Die publizierte Version unter <https://nfdi4objects.github.io/n4o-graph/> wird bei GitHub automatisch aus dem `main` Branch erzeugt.

## License

The content of this repository can be used freely as *Public Domain* ([CC Zero](https://creativecommons.org/publicdomain/zero/1.0/)).
