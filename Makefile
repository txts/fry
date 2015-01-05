###########
#
# Not to be used directly.
# To be included in other Makefiles
# that have determined variables for
# Raw, Fry, Out
#
#########

Pre=$(Fry)/prefix
Ext=$(Fry)/Ext


typo:
	- git status
	- git commit -am "typo"
	- git push origin master

typos:
	cd $(Fry); $(MAKE) typo
	cd $(Raw); $(MAKE) typo
	cd $(Out); $(MAKE) typo

commit:
	- git status
	- git commit -a
	- git push origin master

commits:
	cd $(Fry); $(MAKE) commit
	cd $(Raw); $(MAKE) commit
	cd $(Out); $(MAKE) commit


update:
	- git pull origin master

status:
	- git status


ready : dirs verbatims

dirs: 
	mkdir -p $(Raw)/verbatim
	mkdir -p $(Out)/slides


verbatims:
	@cp -vrup $(Raw)/verbatim/* $(Out)
	@cd $(Out); git add --all; git commit -am "autoadd"



Slides0=$(shell ls $(Raw)/slides; ls *.md)
Slides=$(subst .md,.html,$(Slides0))

slides: ready $(Out)/slides/$(subst .html ,.html $(Out)/slides/,$(Slides))

debug:
	echo $(Raw)/slides
	echo  $(Slides)

$(Out)/slides/%.html : $(Raw)/slides/%.md
	@pandoc -s --webtex -i -t slidy  -c ../img/slidy.css -o $@ $<
	git add $<
