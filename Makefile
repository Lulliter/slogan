# ------------------ Recreate analysis using Mekafile ------------------ #
# [REFERENCE:
# ---- https://www.r-bloggers.com/2015/03/makefiles-and-rmarkdown/
# ]






# ------------------ Deploy Website using Mekafile ------------------ #
# [devo capire e modificare ...]
# [REFERENCE:
# ---- https://www.r-bloggers.com/2015/03/makefiles-and-rmarkdown/
# ]

# ----- Define Makefile Variables  ----- #
RMD_FILES = $(wildcard *.Rmd)
RMD_FILES_noREADME = $(filter-out README.Rmd, $(wildcard *.Rmd))
HTML_FILES := $(patsubst %.Rmd, docs/%.html, $(RMD_FILES_noREADME))
DOCS_DIR = ./docs/*
#DATE :=  shell date '+%d/%m/%Y %H:%M:%S'
DATE = $(shell date +%F) #  invokes a shell command with syntax `$(shell date)`.
MSG = commit_as_of_$(DATE)
GHDOC = "github_document"


# ----- See Makefile Variables (aka print) ----- #
print-%:
	@echo $* = $($*) # 2 print variables use `make print-VARIABLE`

#.PHONY: variables
#variables:
#	@echo RMD_FILES: $(RMD_FILES)
#	@echo HTML_FILES: $(HTML_FILES)

# ----- Makefile RECIPES ----- #
all: clean build README.md git

git:
	git add -u
	git commit -m $(MSG)
	git push -u origin master

# Fix the weird thing that README.Rmd does not turn into README.md (for Github)
README.md: README.Rmd
	Rscript -e "rmarkdown::render("README.Rmd", output_format = "github_document")"  # "github_document"

build:
	Rscript -e "rmarkdown::render_site(encoding = 'UTF-8')"

.PHONY: clean
clean:
	rm -rf $(DOCS_DIR)
	$(info The docs folder is now empty)





# ------------------ AH  version (site in subfolder)   ----------------------- #
#remote_host = cloud
#remote_dir = ~/sites/stats/public_html/cautioning-canary
#remote_dest = $(remote_host):$(remote_dir)

#.PHONY: clean html upload serve

#serve:
#	Rscript -e "servr::httw(dir = '_site', port = 7000)"

## This is handled by targets now
#html:
#	Rscript -e "rmarkdown::render_site(encoding = 'UTF-8')"

#clean:
#	Rscript -e "rmarkdown::clean_site()"

#upload:
#	rsync -crvP --delete _site/ $(remote_dest)











# --------------------- Key RECIPE STRUCTURE --------------------- #
#target:   prerequisites ...
#          commands
#          ...

# --------------------- ASSIGNMENT  --------------------- #
    # `=`  lazy assignment
    # `:=`  immediate assignment / evaluated only once, at the very first occurrence


# ---------------------  PATTERN MATCHING--------------------- #
		# `%` 			wildcard
		# `$(...)`   tells Make to replace a variable with its value when Make is run.
		# `wildcard` gets a list of files matching
		# `patsubst` (PATTERN, REPLACEMENT string, LIST of names in that order) =
								# each name in the list that matches the pattern is replaced by the replacement string.

# --------------------- AUTOMATIC Variables --------------------- #
    # $@ refers to the target of the current rule.
    # $^ refers to the dependencies of the current rule.
    # $< refers to the first dependency of the current rule.

# --------- EXEs       -------------------------------------------------------------
#RMD_FILES  =  $(wildcard *.Rmd)

#results.txt : isles.dat abyss.dat last.dat

#	python testzipf.py abyss.dat isles.dat last.dat > results.txt
#  --> becomes:
#results.txt : isles.dat abyss.dat last.dat
#	python testzipf.py $^ > $@
