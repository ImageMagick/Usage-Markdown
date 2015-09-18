PANDOC := /usr/local/bin/pandoc
MARKDOWN_USAGE_FILES = $(shell find . -name index.md)
HTML_USAGE_FILES = $(MARKDOWN_USAGE_FILES:.md=.html)

all: $(HTML_USAGE_FILES)

%.html: %.md
	printf "[PANDOC] %-28s > %s\n" "$<" $@
	${PANDOC} -f markdown -t html5 --mathjax --toc \
		--base-header-level=2 --toc-depth=4 \
		--template=./_templates/page.html -o "$@" "$<"

clean:
	rm -f $(HTML_USAGE_FILES)

.SILENT: $(HTML_USAGE_FILES)