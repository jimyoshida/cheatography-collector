TARGETS := $(shell cat targets)

__cheat-set.pdf: $(TARGETS)
	qpdf --empty --pages $(TARGETS) -- $@

$(TARGETS):
	bash download.sh $@

clean:
	rm *.pdf
