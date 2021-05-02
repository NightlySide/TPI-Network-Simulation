#!/bin/bash

pandoc -s rapport.md \
		--mathjax \
		--standalone \
		--toc \
		--pdf-engine=xelatex \
		--template ./eisvogel.tex \
		--listings \
		--number-sections \
    -o rapport.pdf

pdftk garde.pdf rapport.pdf cat output rapport_complet.pdf
