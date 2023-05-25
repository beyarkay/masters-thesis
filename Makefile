build:
	# Note: pandoc-mustache must be installed via:
	# `pip install -U pandoc-mustache`
	pandoc --filter pandoc-mustache --bibliography=cite.bib --citeproc --number-sections 00_preface.md 01_introduction.md 02_background.md 03_lit_review.md 04_methodology.md 05_results.md 06_conclusion.md 07_postmatter.md -o "26723077 TG7 Ergo Report.pdf"

preface:
	pandoc --filter pandoc-mustache --bibliography=cite.bib --citeproc --number-sections 00_preface.md -o "preface.pdf"

intro:
	pandoc --filter pandoc-mustache --bibliography=cite.bib --citeproc --number-sections 01_introduction.md -o "intro.pdf"

bg:
	pandoc --filter pandoc-mustache --bibliography=cite.bib --citeproc --number-sections 02_background.md -o "bg.pdf"

lit:
	pandoc --filter pandoc-mustache --bibliography=cite.bib --citeproc --number-sections 03_lit_review.md -o "lit.pdf"

method:
	pandoc --filter pandoc-mustache --bibliography=cite.bib --citeproc --number-sections 04_methodology.md -o "method.pdf"

results:
	pandoc --filter pandoc-mustache --bibliography=cite.bib --citeproc --number-sections 05_results.md -o "results.pdf"

conc:
	pandoc --filter pandoc-mustache --bibliography=cite.bib --citeproc --number-sections 06_conclusion.md -o "conc.pdf"

post:
	pandoc --filter pandoc-mustache --bibliography=cite.bib --citeproc --number-sections 07_postmatter.md -o "post.pdf"

open:
	open "26723077 TG7 Ergo Report.pdf"

tex:
	pandoc  --bibliography=cite.bib --citeproc report.md --standalone -o "26723077 TG7 Ergo Report.tex"

clean:
	rm *.tex *.aux *.log *.toc
