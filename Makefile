
#TODO fix erro, missing separator

GALLERY_TYPST_FILES = $(wildcard gallery/*.typ)
GALLERY_SVG_FILES = $(patsubst %.typ,%.svg,$(GALLERY_TYPST_FILES))
# Compile SVG file for each typ file in the gallery
gallery: $(GALLERY_SVG_FILES)

gallery/%.svg: gallery/%.typ
	typst c -f svg $< $@
