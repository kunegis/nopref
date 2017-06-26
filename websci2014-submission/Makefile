

nopref.pdf:  \
  nopref.tex konect.bib kunegis.bib nopref.bib ref.bib
	rm -f *.aux *.log *.out *.bbl *.blg
	pdflatex -file-line-error -halt-on-error nopref.tex
	bibtex nopref
	pdflatex -file-line-error -halt-on-error nopref.tex
	pdflatex -file-line-error -halt-on-error nopref.tex

konect.bib:  ../../projects/konect/extr/konect.bib
	cp ../../projects/konect/extr/konect.bib $@

kunegis.bib:  ../../bibtex/kunegis.bib
	cp ../../bibtex/kunegis.bib $@

ref.bib:  ../../bibtex/ref.bib
	cp ../../bibtex/ref.bib $@
