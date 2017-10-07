#!/bin/bash

# build
pdflatex report.tex
bibtex report
pdflatex report.tex
pdflatex report.tex

# cleanup
rm *.aux
rm *.toc
rm *.idx
rm *.mtc*
rm *.thm
rm *.lof
rm *.maf
rm *.out
rm *.bbl
rm *.blg
rm *.log
rm *.lot
rm *.nlo
