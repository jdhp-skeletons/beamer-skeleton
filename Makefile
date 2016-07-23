include meta.make

###############################################################################

all: $(NAME).pdf

.PHONY : all clean init slides notes handout jdhp publish

SRCSLIDES=macros_common.tex\
		  macros.tex\
		  bibliography.bib\
		  setup_packages.tex\
		  setup_package_listings.tex\
		  setup_package_tikz.tex\
		  main.tex\
		  content/*.tex

#SRCTIKZ=

###############################################################################

slides: $(NAME).pdf

$(NAME).pdf: $(SRCSLIDES) $(SRCTIKZ) slides.tex
	pdflatex -jobname=$(NAME) slides.tex
	bibtex $(NAME)            # this is the name of the .aux file, not the .bib file !
	pdflatex -jobname=$(NAME) slides.tex
	pdflatex -jobname=$(NAME) slides.tex

notes: $(NAME)_notes.pdf

$(NAME)_notes.pdf: $(SRCSLIDES) $(SRCTIKZ) notes.tex
	pdflatex -jobname=$(NAME)_notes notes.tex
	#bibtex $(NAME)_notes      # this is the name of the .aux file, not the .bib file !
	#pdflatex -jobname=$(NAME)_notes notes.tex
	pdflatex -jobname=$(NAME)_notes notes.tex

handout: $(NAME)_handout.pdf

$(NAME)_handout.pdf: $(SRCSLIDES) $(SRCTIKZ) handout.tex
	pdflatex -jobname=$(NAME)_handout handout.tex
	#bibtex $(NAME)_handout    # this is the name of the .aux file, not the .bib file !
	#pdflatex -jobname=$(NAME)_handout handout.tex
	pdflatex -jobname=$(NAME)_handout handout.tex

# PUBLISH #####################################################################

publish: jdhp

jdhp:$(NAME).pdf
	# JDHP_DL_URI is a shell environment variable that contains the destination
	# URI of the PDF files.
	@if test -z $$JDHP_DL_URI ; then exit 1 ; fi
	
	# Upload the PDF file
	rsync -v -e ssh $(NAME).pdf ${JDHP_DL_URI}/pdf/

## CLEAN ######################################################################

clean:
	@echo "suppression des fichiers de compilation"
	@rm -f *.log *.aux *.dvi *.toc *.lot *.lof *.out *.nav *.snm *.bbl *.blg *.vrb

init: clean
	@echo "suppression des fichiers cibles"
	@rm -f $(NAME).pdf
	@rm -f $(NAME)_notes.pdf
	@rm -f $(NAME)_handout.pdf
