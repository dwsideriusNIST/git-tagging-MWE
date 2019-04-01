LATEX=pdflatex
LATEXOPT=--shell-escape
NONSTOP=--interaction=nonstopmode
NOBIBTEX=--bibtex-
VIEWER=xpdf

LATEXMK=latexmk
LATEXMKOPT=-pdf

MAIN=Qst_single
SOURCES=$(MAIN).tex Makefile
FIGURES := $(shell find Figures/* -type f) #Forces an update if anything in ./Figures is newer than $(MAIN).pdf

#Default
all:    $(MAIN).pdf

.refresh:
	touch .refresh

$(MAIN).pdf: $(MAIN).tex .refresh $(SOURCES) $(FIGURES)
	$(LATEXMK) $(LATEXMKOPT) -pdflatex="$(LATEX) $(LATEXOPT) %O %S" $(MAIN)
	rm -f *.fdb_latexmk *.fls

nobibtex:
	$(LATEXMK) $(LATEXMKOPT) $(NOBIBTEX) -pdflatex="$(LATEX) $(LATEXOPT) %O %S" $(MAIN)
	rm -f *.fdb_latexmk *.fls

#Force an update regardless of file status
force:
	touch .refresh
	rm $(MAIN).pdf
	$(LATEXMK) $(LATEXMKOPT) -pdflatex="$(LATEX) $(LATEXOPT) %O %S" $(MAIN)
	rm -f *.fdb_latexmk *.fls

#Cleanup
clean:
	$(LATEXMK) -C $(MAIN)
	rm -f $(MAIN).pdfsync
	rm -rf *~ *.tmp
	rm -f *.bbl *.blg *.aux *.end *.fls *.log *.out *.fdb_latexmk *-eps-converted-to.pdf

debug:
	$(LATEX) $(LATEXOPT) $(MAIN)

updatebib:
	git submodule update --init --recursive
	git submodule foreach git pull origin master #this assumes that we want the master branch...

commit:
	git commit -a -m "Commit of all changed files for `date`"

pull:
	git pull

push:
	git push

diff:
	git latexdiff --bibtex --no-view -o diff.pdf --main $(MAIN).tex HEAD --

bibfile:
	bibexport -o single.bib $(MAIN).aux

open:
	$(VIEWER) $(MAIN).pdf &

.PHONY: clean force once all

#OPERATIONS
#update BibTeX submodule(s)
#git commit (?)  - would have to be uncontrolled
#git pull & push
#latexdiff - why is it not examining the preamble? - this specific to achemso with two authors
# --math-markup=0

#Questions:
#Do we need debug?
