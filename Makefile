
all: intro bg lit method results conc report


md_to_tex:
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

combine: md_to_tex
	trash main.aux main.lof main.log main.lot main.out main.toc
	pdflatex -draftmode tex/main.tex # First compile all the labels and references
	pdflatex tex/main.tex -o main.pdf # Then compile the document to be linked
	echo "file://$$(pwd)/main.pdf"

report:
	# Make the directory if it doesn't exist
	[[ -d  "checkpoints/$$(/bin/date '+%Y-%m-%d')" ]] || mkdir "checkpoints/$$(/bin/date '+%Y-%m-%d')"
	# Note: pandoc-mustache must be installed via:
	# `pip install -U pandoc-mustache`
	# Compile the entire project
	pandoc \
		--verbose \
		--filter pandoc-mustache \
		--bibliography=src/cite.bib \
		--citeproc \
		--number-sections \
		src/00_preface.md \
		src/01_introduction.md \
		src/02_background.md \
		src/03_lit_review.md \
		src/04_methodology.md \
		src/05_results.md \
		src/06_conclusion.md \
		src/07_postmatter.md \
		-o "checkpoints/$$(/bin/date '+%Y-%m-%d')/Boyd Kane Master's Thesis.pdf"

intro:
	# Make the directory if it doesn't exist
	# [[ -d  "checkpoints/$$(/bin/date '+%Y-%m-%d')" ]] || mkdir "checkpoints/$$(/bin/date '+%Y-%m-%d')"
	pandoc \
		--filter pandoc-mustache \
		--bibliography=src/cite.bib \
		--citeproc \
		--number-sections \
		src/01_introduction.md \
		-o "tex/01_introduction.tex"
	# echo "file://$$(pwd)/checkpoints/$$(/bin/date '+%Y-%m-%d')/01_introduction.pdf"

bg:
	# Make the directory if it doesn't exist
	[[ -d  "checkpoints/$$(/bin/date '+%Y-%m-%d')" ]] || mkdir "checkpoints/$$(/bin/date '+%Y-%m-%d')"
	pandoc \
		--filter pandoc-mustache \
		--bibliography=src/cite.bib \
		--citeproc \
		--number-sections \
		src/00_preface.md \
		src/02_background.md \
		-o "checkpoints/$$(/bin/date '+%Y-%m-%d')/02_background.pdf"
	echo "file://$$(pwd)/checkpoints/$$(/bin/date '+%Y-%m-%d')/02_background.pdf"

lit:
	# Make the directory if it doesn't exist
	[[ -d  "checkpoints/$$(/bin/date '+%Y-%m-%d')" ]] || mkdir "checkpoints/$$(/bin/date '+%Y-%m-%d')"
	pandoc \
		--filter pandoc-mustache \
		--bibliography=src/cite.bib \
		--citeproc \
		--number-sections \
		src/00_preface.md \
		src/03_lit_review.md \
		-o "checkpoints/$$(/bin/date '+%Y-%m-%d')/03_lit_review.pdf"
	echo "file://$$(pwd)/checkpoints/$$(/bin/date '+%Y-%m-%d')/03_lit_review.pdf"

method:
	# Make the directory if it doesn't exist
	[[ -d  "checkpoints/$$(/bin/date '+%Y-%m-%d')" ]] || mkdir "checkpoints/$$(/bin/date '+%Y-%m-%d')"
	pandoc \
		--filter pandoc-mustache \
		--bibliography=src/cite.bib \
		--citeproc \
		--number-sections \
		src/00_preface.md \
		src/04_methodology.md \
		-o "checkpoints/$$(/bin/date '+%Y-%m-%d')/04_methodology.pdf"
	echo "checkpoints/$$(/bin/date '+%Y-%m-%d')"
	echo "file://$$(pwd)/checkpoints/$$(/bin/date '+%Y-%m-%d')/04_methodology.pdf"

05_results:
	# Make the directory if it doesn't exist
	pandoc \
		--filter pandoc-mustache \
		--bibliography=src/cite.bib \
		--citeproc \
		--number-sections \
		src/00_preface.md \
		src/05_results.md \
		--standalone \
		-o "tex/05_results.tex"
	pdflatex tex/05_results.tex
	echo "file://$$(pwd)/05_results.pdf"

results:
	# Make the directory if it doesn't exist
	[[ -d  "checkpoints/$$(/bin/date '+%Y-%m-%d')" ]] || mkdir "checkpoints/$$(/bin/date '+%Y-%m-%d')"
	pandoc \
		--filter pandoc-mustache \
		--bibliography=src/cite.bib \
		--citeproc \
		--number-sections \
		src/00_preface.md \
		src/05_results.md \
		-o "checkpoints/$$(/bin/date '+%Y-%m-%d')/05_results.pdf"
	echo "file://$$(pwd)/checkpoints/$$(/bin/date '+%Y-%m-%d')/05_results.pdf"

conc:
	# Make the directory if it doesn't exist
	[[ -d  "checkpoints/$$(/bin/date '+%Y-%m-%d')" ]] || mkdir "checkpoints/$$(/bin/date '+%Y-%m-%d')"
	pandoc \
		--filter pandoc-mustache \
		--bibliography=src/cite.bib \
		--citeproc \
		--number-sections \
		src/00_preface.md \
		src/06_conclusion.md \
		-o "checkpoints/$$(/bin/date '+%Y-%m-%d')/06_conclusion.pdf"
	echo "file://$$(pwd)/checkpoints/$$(/bin/date '+%Y-%m-%d')/06_conclusion.pdf"

ack:
	pandoc \
		src/00_acknowledgements.md \
		-o "tex/00_acknowledgements.tex"

dedication:
	pandoc \
		src/00_dedication.md \
		-o "tex/00_dedication.tex"

abstract:
	pandoc \
		src/00_abstract.md \
		-o "tex/00_abstract.tex"

watch:
	# Install `entr` first: https://github.com/eradman/entr
	echo 'src/01_introduction.md' | entr -s 'make intro' &
	echo 'src/02_background.md' | entr -s 'make bg' &
	echo 'src/03_lit_review.md' | entr -s 'make lit' &
	echo 'src/04_methodology.md' | entr -s 'make method' &
	echo 'src/05_results.md' | entr -s 'make results' &
	echo 'src/06_conclusion.md' | entr -s 'make conc' &
