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

ready : dirs verbatims talks

dirs: 
	mkdir -p $(Raw)/verbatim
	mkdir -p $(Raw)/dot
	mkdir -p $(Raw)/slides
	mkdir -p $(Out)/slides
	mkdir -p $(Out)/img/dot

verbatims:
	cp -vrup $(Raw)/verbatim/* $(Out)

talks: 
	echo 1
	echo $(call target,slides/*.md,.md,.html)

slides: $(call target,slides,md,html,$(Raw),$(Out))
dots  : $(call target,dot,dot,png,$(Raw),$(Out)/img)

$(Out)/slides/%.html : $(Raw)/slides/%.md
	pandoc -s --webtex -i -t slidy  -c ../img/slidy.css -o $@ $<

$(Out)/img/dot/%.png : $(Raw)/dot/%.dot
	dot -Tpng -o $@ $<
