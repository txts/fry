###########
#
# Not to be used directly.
# To be included in other Makefiles
# that have determined variables for
# Raw, Fry, Out
#
#########

typo:
	- git status
	- git commit -am "typo"
	- git push origin master

commit:
	- git status
	- git commit -a
	- git push origin master

update:
	- git pull origin master

status:
	- git status


ready:
	mkdir -p $(Raw)/verbatim


verbatims:
	@cp -vrup $(Raw)verbatim/* $(Out)
	@cd $(Out); git add --all; git commit -am "autoadd"

$(Out)slides/%.html : $(Raw)slides/%.md
	pandoc -s --webtex -i -t slidy  -c ../img/slidy.css -o $@ $<
