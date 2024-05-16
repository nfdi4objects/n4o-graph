default:
	quarto render

pgraph=npm run --silent pgraph --

images: img/data-flow.mmd

img/data-flow.mmd: data-flow.pg
	 $(pgraph) $< --html -t mmd > $@
