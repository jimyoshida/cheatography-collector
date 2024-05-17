OUTFILE := out/cheat-set.pdf
PAGE_IDS := $(shell cat targets)
PAGE_FILES := $(addprefix downloads/, $(PAGE_IDS))

$(OUTFILE): $(PAGE_FILES)
	mkdir -p out
	qpdf --empty --pages $(PAGE_FILES) -- $@

$(PAGE_FILES):
	bash fetch.sh $@

clean:
	rm -fr out downloads
