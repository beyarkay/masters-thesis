
all: intro bg lit method results conc report

report: checkpoint
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
		-o "checkpoints/$$(date '+%Y-%m-%d')/Boyd Kane Master's Thesis.pdf"

checkpoint:
	# Make the directory if it doesn't exist
	[[ -d  "checkpoints/$(date '+%Y-%m-%d')" ]] || mkdir "checkpoints/$(date '+%Y-%m-%d')"

intro: checkpoint
	pandoc \
		--filter pandoc-mustache \
		--bibliography=src/cite.bib \
		--citeproc \
		--number-sections \
		src/00_preface.md \
		src/01_introduction.md \
		-o "checkpoints/$$(date '+%Y-%m-%d')/01_introduction.pdf"

bg: checkpoint
	pandoc \
		--filter pandoc-mustache \
		--bibliography=src/cite.bib \
		--citeproc \
		--number-sections \
		src/00_preface.md \
		src/02_background.md \
		-o "checkpoints/$$(date '+%Y-%m-%d')/02_background.pdf"

lit: checkpoint
	pandoc \
		--filter pandoc-mustache \
		--bibliography=src/cite.bib \
		--citeproc \
		--number-sections \
		src/00_preface.md \
		src/03_lit_review.md \
		-o "checkpoints/$$(date '+%Y-%m-%d')/03_lit_review.pdf"

method: checkpoint
	pandoc \
		--filter pandoc-mustache \
		--bibliography=src/cite.bib \
		--citeproc \
		--number-sections \
		src/00_preface.md \
		src/04_methodology.md \
		-o "checkpoints/$$(date '+%Y-%m-%d')/04_methodology.pdf"

results: checkpoint
	pandoc \
		--filter pandoc-mustache \
		--bibliography=src/cite.bib \
		--citeproc \
		--number-sections \
		src/00_preface.md \
		src/05_results.md \
		-o "checkpoints/$$(date '+%Y-%m-%d')/05_results.pdf"

conc: checkpoint
	pandoc \
		--filter pandoc-mustache \
		--bibliography=src/cite.bib \
		--citeproc \
		--number-sections \
		src/00_preface.md \
		src/06_conclusion.md \
		-o "checkpoints/$$(date '+%Y-%m-%d')/06_conclusion.pdf"

watch:
	# Install `entr` first: https://github.com/eradman/entr
	echo '01_introduction.md' | entr -s 'make intro' &
	echo '02_background.md' | entr -s 'make bg' &
	echo '03_lit_review.md' | entr -s 'make lit' &
	echo '04_methodology.md' | entr -s 'make method' &
	echo '05_results.md' | entr -s 'make results' &
	echo '06_conclusion.md' | entr -s 'make conc' &
