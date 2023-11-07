pandoc:
	pandoc src/00_abstract.md          -o tex/00_abstract.tex
	pandoc src/00_acknowledgements.md  -o tex/00_acknowledgements.tex
	pandoc src/00_dedication.md        -o tex/00_dedication.tex
	pandoc src/00_preface.md           -o tex/00_preface.tex
	pandoc src/01_introduction.md      -o tex/01_introduction.tex
	pandoc src/02_background.md        -o tex/02_background.tex
	pandoc src/03_lit_review.md        -o tex/03_lit_review.tex
	pandoc src/04_methodology.md       -o tex/04_methodology.tex
	pandoc src/05_results.md           -o tex/05_results.tex
	pandoc src/06_conclusion.md        -o tex/06_conclusion.tex
	pandoc src/07_appendix.md          -o tex/07_appendix.tex
	pandoc src/07_postmatter.md        -o tex/07_postmatter.tex

clean:
	trash *.{aux,bbl,blg,brf,lof,log,lot,out,toc} **/*.{aux,bbl,blg,brf,lof,log,lot,out,toc} 2> /dev/null || true

dev: pandoc clean
	pdflatex -halt-on-error -jobname=tmp main.tex # Create the auxiliary pdflatex files
	bibtex tmp 2> /dev/null || true # Create the auxiliary bib files, ignore errors
	pdflatex -halt-on-error -jobname=tmp main.tex # Add the bibliography to the end of the pdf
	pdflatex -halt-on-error -jobname=tmp main.tex # Provide links from inline citations to bibliography
	$(MAKE) clean
	mv tmp.pdf main.pdf
	echo "file://$$(pwd)/main.pdf"

release: pandoc clean
	pdflatex -halt-on-error -jobname=tmp main.tex # Create the auxiliary pdflatex files
	bibtex tmp 2> /dev/null || true # Create the auxiliary bib files, ignore errors
	pdflatex -halt-on-error -jobname=tmp main.tex # Add the bibliography to the end of the pdf
	pdflatex -halt-on-error -jobname=tmp main.tex # Provide links from inline citations to bibliography
	pdflatex -halt-on-error -jobname=tmp main.tex # Provide links from bibliography to inline citations
	mv tmp.pdf "Boyd Kane MSc Thesis.pdf"
	$(MAKE) clean
	echo "file://$$(pwd)/Boyd Kane MSc Thesis.pdf"

watch:
	exa src/0*.md src/cite.bib src/imgs/* main.tex | entr -s 'make dev'
