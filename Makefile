all: clean prepare pdf html

clean:
	sudo rm -rf $(CURDIR)/output

prepare:
	docker pull integr8/alpine-asciidoctor-helper

pdf:
	docker run --rm -v $(CURDIR):/documents/ -e 'ASCIIDOCTOR_PLUGIN=asciidoctor-diagram,chart-block-macro' integr8/alpine-asciidoctor-helper pdf docs/index-ptbr.adoc

html:
	docker run --rm -v $(CURDIR):/documents/ -e 'ASCIIDOCTOR_PLUGIN=asciidoctor-diagram,chart-block-macro' integr8/alpine-asciidoctor-helper html docs/index-ptbr.adoc