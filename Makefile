PACKAGE_FILES=lib.typ intern.typ

all: gallery manual

manual: manual.pdf



GALLERY_TYPST_FILES = $(wildcard gallery/*.typ)
GALLERY_SVG_FILES = $(patsubst %.typ,%.svg,$(GALLERY_TYPST_FILES))
# Compile SVG file for each typ file in the gallery
gallery: $(GALLERY_SVG_FILES)


manual.pdf: manual.typ $(PACKAGE_FILES)
	typst c $< $@
gallery/%.svg: gallery/%.typ $(PACKAGE_FILES)
	typst c -f svg $< $@
