all: clean prepare pdf html

clean:
	sudo rm -rf $(CURDIR)/output

prepare:
	docker pull integr8/alpine-asciidoctor-helper

pdf:
	docker run --rm -v $(CURDIR):/documents/ -e 'ASCIIDOCTOR_PLUGIN=asciidoctor-diagram,chart-block-macro' -e 'ASCIIDOCTOR_PDF_THEMES_DIR=docs/resources/themes' -e 'ASCIIDOCTOR_PDF_THEME=default' -e 'ASCIIDOCTOR_PDF_FONTS_DIR=docs/resources/fonts' integr8/alpine-asciidoctor-helper pdf docs/index-ptbr.adoc

html:
	docker run --rm -v $(CURDIR):/documents/ -e 'ASCIIDOCTOR_PLUGIN=asciidoctor-diagram,chart-block-macro' integr8/alpine-asciidoctor-helper html docs/index-ptbr.adoc