default:
	quarto render

images: img/data-flow.mmd

img/data-flow.mmd: data-flow.pg
	npm run --silent -- pgraph $< --html -t mmd > $@
