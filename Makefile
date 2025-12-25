## This is powertargets (manually forked from bbmisc/sesoi)
## https://github.com/bbolker/powertargets
all: docs/powertargets.html

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

docs/powertargets.html: powertargets.html
	mv powertargets.html docs/

shiny_powertargets:
	Rscript --vanilla app.R

Ignore += powertargets.pdf powertargets_files/

powertargets.pdf: powertargets.qmd powertargets_funs.Rout
	quarto render $< -t pdf -o $@

powertargets.html: powertargets.qmd powertargets_funs.Rout
	$(qr)

## This is how you put things into a pipeR pipeline without updating them.
powertargets_funs.Rout: powertargets_funs.R
	$(wrapR)

simfun2_test.Rout: simfun2_test.R powertargets_funs.Rout

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
