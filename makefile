MAKE  = make
NAME  = dtk-biber-tool
NAMEtypeout = $(CYAN)*** $(NAME) ***$(NC)
SHELL = bash
PWD   = $(shell pwd)
TEMP := $(shell mktemp -d -t tmp.XXXXXXXXXX)
TDIR  = $(TEMP)/$(NAME)
VERS  = $(shell /bin/date "+%Y-%m-%d---%H-%M-%S")
LOCAL = $(shell kpsewhich --var-value TEXMFLOCAL)
# Colors
RED   = \033[0;31m
CYAN  = \033[0;36m
NC    = \033[0m
echoPROJECT = @echo -e "$(CYAN) <$(NAME)>$(RED)"



all: $(NAME).bib
	-latexmk -lualatex $(NAME).tex

$(NAME).bib:
	-ctanbib biber > $(NAME).bib
	-biber \
	  --tool \
	  --outfile $(NAME).bib \
	  --output_align \
	  --output_indent=3 \
	  --output_fieldcase=lower \
	  --output-field-order=author,title,date \
	  $(NAME).bib
	$(echoPROJECT) "* bib information processed and cleaned * $(NC)"


# zip files up for sending etc.
zip: $(NAME).pdf $(PAKET).pdf
	rm -f $(NAME)*.zip
	mkdir $(TDIR)
	cp $(NAME).{tex,pdf,bib} $(PAKET).dtx README.md makefile $(TDIR)
	cd $(TEMP); zip -Drq $(PWD)/$(NAME)-$(VERS).zip $(NAME)
	$(echoPROJECT) "* files zipped * $(NC)"




# clean:
# 	@find . \
# 	! -name '$(NAME).pdf' \
# 	! -name '$(NAME).tex' \
# 	! -name '$(NAME).bib' \
# 	! -name '$(PAKET).dtx' \
# 	! -name '$(PAKET).sty' \
# 	! -name '$(PAKET).pdf' \
# 	! -name 'README.md' \
# 	! -name '"makefile"' \
# 	! -name '.git*' \
# 	-type f -exec rm -f {} +
