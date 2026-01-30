## This is powertargets (manually forked from bbmisc/sesoi)
## https://github.com/bbolker/powertargets
all: powertargets.html

current: target
-include target.mk
Ignore = target.mk

vim_session:
	bash -cl "vmt"

######################################################################

## Clarity simulations

Sources += *.R *.qmd *_notes.md README.md
Ignore += *.html

autopipeR = defined

Ignore += Rmisc/*.html
Sources += $(wildcard Rmisc/*.*md Rmisc/*.R)

shiny_powertargets:
	Rscript --vanilla app.R

Ignore += powertargets.pdf powertargets_files/

powertargets.pdf: powertargets.qmd powertargets_funs.Rout  powertargets.bib
	quarto render $< -t pdf -o $@

## To make and stage the docs version, please use target below.
## This avoids automatic churn
## powertargets.html.docs: powertargets.qmd
powertargets.html: powertargets.qmd powertargets_funs.Rout powertargets.bib
	$(qr)

## wrapR is how you put old code into a pipeR pipeline; use sparingly
powertargets_funs.Rout: powertargets_funs.R
	$(wrapR)

## Fixed rule 2026 Jan 30 (Fri) (modern dependency for modern recipe)
## Something else is broken
simfun2_test.Rout: simfun2_test.R powertargets_funs.rda

## claritySims.md
## claritySims.Rout: claritySims.R clarityFuns.R
claritySims.Rout: claritySims.R clarityFuns.rda categories.tsv
	$(pipeR)

######################################################################

qr = quarto render $<

######################################################################

### Makestuff

Sources += Makefile

Ignore += makestuff
msrepo = https://github.com/dushoff

## ln -s ../makestuff . ## Do this first if you want a linked makestuff
Makefile: makestuff/00.stamp
makestuff/%.stamp: | makestuff
	- $(RM) makestuff/*.stamp
	cd makestuff && $(MAKE) pull
	touch $@
makestuff:
	git clone --depth 1 $(msrepo)/makestuff

-include makestuff/os.mk

-include makestuff/pipeR.mk

-include makestuff/git.mk
-include makestuff/visual.mk
