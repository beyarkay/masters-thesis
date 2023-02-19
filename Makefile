build:
	# Note: pandoc-mustache must be installed via:
	# `pip install -U pandoc-mustache`
	pandoc --filter pandoc-mustache --bibliography=cite.bib --citeproc --number-sections report.md -o "26723077 TG7 Ergo Report.pdf"

open:
	open "26723077 TG7 Ergo Report.pdf"

tex:
	pandoc  --bibliography=cite.bib --citeproc report.md --standalone -o "26723077 TG7 Ergo Report.tex"

clean: 
	rm *.tex *.aux *.log *.toc
