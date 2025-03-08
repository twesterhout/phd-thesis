export max_print_line := "10000"
	
full: clean bibliography
	xelatex -shell-escape 00_main.tex \
		&& bibtex 00_main.aux \
		&& xelatex -shell-escape 00_main.tex \
		&& xelatex -shell-escape 00_main.tex

once:
	xelatex -shell-escape 00_main.tex

bibliography:
	rm -f 80_references.bib && papis export --all --format bibtex --out 80_references.bib '*'

clean:
	rm -f 00_main.{aux,auxlock,bbl,blg,dep,log,toc,out} 00_main-{1,2}.cpt 00_main-figure*.{dpth,log,md5} notes2bib*.bib
