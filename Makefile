PANDOC := /usr/local/bin/pandoc
MARKDOWN_USAGE_FILES = $(shell find . -name index.md)
HTML_USAGE_FILES = $(MARKDOWN_USAGE_FILES:.md=.html)
BASH_USAGE_FILES = $(MARKDOWN_USAGE_FILES:.md=.sh)

all: $(HTML_USAGE_FILES) $(BASH_USAGE_FILES)

%.sh: %.md
	printf "[PANDOC] %-28s > %s\n" "$<" $@
	${PANDOC} -f markdown -t _writers/script.lua \
		--normalize -o "$@" "$<"

%.html: %.md
	printf "[PANDOC] %-28s > %s\n" "$<" $@
	${PANDOC} -f markdown -t html5 --mathjax --toc \
		--base-header-level=2 --toc-depth=4 \
		--template=./_templates/page.html -o "$@" "$<"

clean:
	rm -f $(HTML_USAGE_FILES) $(BASH_USAGE_FILES)

advanced: advanced/index.html advanced/index.sh

backgrounds: backgrounds/index.html backgrounds/index.sh

basics: basics/index.html basics/index.sh

blur: blur/index.html blur/index.sh

canvas: canvas/index.html canvas/index.sh

color_basics: color_basics/index.html color_basics/index.sh

color_mods: color_mods/index.html color_mods/index.sh

compare: compare/index.html compare/index.sh

compose: compose/index.html compose/index.sh

compose/tables: compose/tables/index.html compose/tables/index.sh

convolve: convolve/index.html convolve/index.sh

crop: crop/index.html crop/index.sh

distorts: distorts/index.html distorts/index.sh

distorts/affine: distorts/affine/index.html distorts/affine/index.sh

draw: draw/index.html draw/index.sh

files: files/index.html files/index.sh

filter: filter/index.html filter/index.sh

filter/nicolas: filter/nicolas/index.html filter/nicolas/index.sh

fonts: fonts/index.html fonts/index.sh

formats: formats/index.html formats/index.sh

fourier: fourier/index.html fourier/index.sh

layers: layers/index.html layers/index.sh

lens: lens/index.html lens/index.sh

mapping: mapping/index.html mapping/index.sh

masking: masking/index.html masking/index.sh

misc: misc/index.html misc/index.sh

montage: montage/index.html montage/index.sh

morphology: morphology/index.html morphology/index.sh

photos: photos/index.html photos/index.sh

quantize: quantize/index.html quantize/index.sh

resize: resize/index.html resize/index.sh

text: text/index.html text/index.sh

thumbnails: thumbnails/index.html thumbnails/index.sh

transform: transform/index.html transform/index.sh

video: video/index.html video/index.sh

warping: warping/index.html warping/index.sh

windows: windows/index.html windows/index.sh

.SILENT: $(HTML_USAGE_FILES) $(BASH_USAGE_FILES)
