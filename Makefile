
all: intro bg lit method results conc report



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
	[[ -d  "checkpoints/$$(/bin/date '+%Y-%m-%d')" ]] || mkdir "checkpoints/$$(/bin/date '+%Y-%m-%d')"
	pandoc \
		--filter pandoc-mustache \
		--bibliography=src/cite.bib \
		--citeproc \
		--number-sections \
		src/00_preface.md \
		src/01_introduction.md \
		-o "checkpoints/$$(/bin/date '+%Y-%m-%d')/01_introduction.pdf"

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

watch:
	# Install `entr` first: https://github.com/eradman/entr
	echo '01_introduction.md' | entr -s 'make intro' &
	echo '02_background.md' | entr -s 'make bg' &
	echo '03_lit_review.md' | entr -s 'make lit' &
	echo '04_methodology.md' | entr -s 'make method' &
	echo '05_results.md' | entr -s 'make results' &
	echo '06_conclusion.md' | entr -s 'make conc' &
