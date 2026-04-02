# Citations seem good enough for now, but can change formatting with CSL
# CSL = chicago-author-date

R_SCRIPT = Rscript
IMPORT_DIR = program/import
DERIVED_DIR = derived

.PHONY: clean sample.Rds

sample.Rds: $(DERIVED_DIR)/sample.Rds

$(DERIVED_DIR):
	mkdir -p $@

$(DERIVED_DIR)/census-bps.Rds: $(IMPORT_DIR)/import-bps.R .Renviron | $(DERIVED_DIR)
	$(R_SCRIPT) $<

$(DERIVED_DIR)/census-cbp.csv: $(IMPORT_DIR)/import-cbp.R .Renviron | $(DERIVED_DIR)
	$(R_SCRIPT) $<

$(DERIVED_DIR)/mhs-state-year.Rds $(DERIVED_DIR)/mhs-national-year.Rds &: $(IMPORT_DIR)/import-mhs.R .Renviron | $(DERIVED_DIR)
	$(R_SCRIPT) $<

$(DERIVED_DIR)/nberces-industries.Rds $(DERIVED_DIR)/nberces-mh.Rds &: $(IMPORT_DIR)/import-nberces.R | $(DERIVED_DIR)
	$(R_SCRIPT) $<

$(DERIVED_DIR)/sample-state.Rds $(DERIVED_DIR)/sample.Rds &: \
	$(IMPORT_DIR)/databuild.R \
	$(DERIVED_DIR)/mhs-state-year.Rds \
	$(DERIVED_DIR)/mhs-national-year.Rds \
	$(DERIVED_DIR)/census-cbp.csv \
	$(DERIVED_DIR)/census-bps.Rds \
	$(DERIVED_DIR)/nberces-mh.Rds | $(DERIVED_DIR)
	$(R_SCRIPT) $<

%.pdf: %.tex manufactured-productivity.bib
	pdflatex $*
	bibtex $*
	pdflatex $*
	pdflatex $*

%.tex: %.md
	pandoc --citeproc --natbib $< --template=latex.template -o $@

paper.html: paper.md
	pandoc --citeproc paper.md --template=html.template -o $@

# Blog post for Jekyll site
BLOG_DIR ?= ../../williamsca.github.io
BLOG_IMG = $(BLOG_DIR)/assets/images
BLOG_POST = $(BLOG_DIR)/_posts/$(shell date +%Y-%m-%d)-manufactured-productivity.md
BLOG_PNGS = $(wildcard output/*.png)

blog: paper.md blog-filter.lua manufactured-productivity.bib $(BLOG_PNGS)
	@mkdir -p $(BLOG_IMG)
	cp $(BLOG_PNGS) $(BLOG_IMG)/
	pandoc -L blog-filter.lua -t html --wrap=none \
		--template=blog.template paper.md > $(BLOG_POST)
	@echo "Blog post written to $(BLOG_POST)"

# Latex and CSL templates available at: '~/.pandoc/templates' and '~/.pandoc/csl'

# Clean target
clean:
	rm -f paper.pdf
	rm -f proposal.pdf
	rm -f Rplots.pdf
	rm -f .RData
	rm -f *.aux
	rm -f *.log
	rm -f *.gz
	rm -f *.out
	rm -f *.bbl
	rm -f *.blg
