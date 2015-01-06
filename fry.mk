###########
#
# Not to be used directly.
# To be included in other Makefiles
# that have determined variables for
# Raw, Fry, Out
#
#########

Dirs=$(Fry) $(Raw) $(Out)

Pre=$(Fry)/prefix
Ext=$(Fry)/Ext

define hi
 echo "\n\n===| $(1) |==========================\n"
endef 

define target
   $(subst $4,$5,\
      $(subst .$2,.$3,\
         $(shell ls $(Raw)/$1/*.$2)))
endef

ready : dirs verbatims dots talks plots

commit: ready
	- git status
	- git commit -a
	- git push origin master

addll:
	git add --all 

typo:
	- git status
	- git commit -am "typo"
	- git push origin master

update:
	- git pull origin master

status:
	- git status

addalls:; @$(foreach d,$(Dirs), cd $d; $(call hi,$d); git add --all;)
typos:;   @$(foreach d,$(Dirs), cd $d; $(call hi,$d); $(MAKE) -s typo;)
commits:; @$(foreach d,$(Dirs), cd $d; $(call hi,$d); $(MAKE) -s commit;)
updates:; @$(foreach d,$(Dirs), cd $d; $(call hi,$d); $(MAKE) -s update;)
statuz :; @$(foreach d,$(Dirs), cd $d; $(call hi,$d); $(MAKE) -s status;)

Skeleton=dot etc plot slides verbatim/img
dirs: 
	$(foreach d,$(Skeleton),mkdir -p $(Raw)/$d(Raw))
	mkdir -p $(Out)/slides
	mkdir -p $(Out)/img/dot
	mkdir -p $(Out)/img/plot
	cp -vrup $(Fry)/etc $(Raw)
	cp -vrup $(Fry)/slidy.css $(Raw)/verbatim

verbatims:
	cp -vrup $(Raw)/verbatim/* $(Out)

talks:  $(call target,slides,md,html,$(Raw),$(Out))
dots  : $(call target,dot,dot,png,$(Raw),$(Out)/img)
plots : $(call target,plot,plt,png,$(Raw),$(Out)/img)

$(Out)/slides/%.html : $(Raw)/slides/%.md
	pandoc -s \
              --webtex -i -t slidy \
              -r markdown+simple_tables+table_captions \
              --biblio $(Raw)/biblio.bib \
	      -c        ../img/slidy.css \
              -o $@ $<

$(Out)/img/dot/%.png : $(Raw)/dot/%.dot
	dot -Tpng -o $@ $<

$(Out)/img/plot/%.png : $(Raw)/plot/%.plt
	gnuplot $< > $@

overRideSomething:
	@echo do something
