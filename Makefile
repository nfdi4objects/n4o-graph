.PHONY: docs preview

docs:
	quarto render manual

preview:
	quarto preview manual
