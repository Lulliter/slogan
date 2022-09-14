# ------------------ I) Recreate analysis using Mekafile ------------------ #
# [REFERENCE]
# ---- https://www.r-bloggers.com/2015/03/makefiles-and-rmarkdown/

RDIR = .
KNIT = Rscript -e "require(rmarkdown); render('$<')"

# all: $(GATHER_OUT) $(PROCESS_OUT) $(ANALYSIS_OUT) $(PRESENTATION_OUT)

################################################################################
# ---------- STEP I.a) Gather data
################################################################################
# DATA_DIR = $(RDIR)/data
# GATHER_DIR = $(DATA_DIR)/gather
# GATHER_SOURCE = $(wildcard $(GATHER_DIR)/*.Rmd)
# GATHER_OUT = $(GATHER_SOURCE:.Rmd=.docx)

# not now....
# $(GATHER_DIR)/%.docx:$(GATHER_DIR)/%.Rmd
# 	$(KNIT)

################################################################################
# ---------- STEP I.b) Process data {== all the files that start with "01..." and their dependencies}
################################################################################
PROCESS_DIR = $(RDIR)/_process
PROCESS_SOURCE = $(wildcard 01*.Rmd)
PROCESS_OUT = $(PROCESS_SOURCE:.Rmd=.html) 01b_WDR_data-exploration_abstracts_files 01c_WDR_data-exploration_subjects_files site_libs

# $(PROCESS_DIR)/%.docx:$(PROCESS_DIR)/%.Rmd $(GATHER_OUT)
# 	$(KNIT)
.PHONY: all_process
all_process: clean_process render_process move_process

move_process:
	mv $(PROCESS_OUT) $(PROCESS_DIR)

# Render ALL process .Rmd files as html + dependencies
render_process: 01a_intro_text_analytics.html 01b_WDR_data-exploration_abstracts.html 01c_WDR_data-exploration_subjects.html 01d_WBoper_data-exploration.html

# Render EACH process .Rmd files as html + dependencies
01a_intro_text_analytics.html: 01a_intro_text_analytics.Rmd slogan.bib
	#Rscript -e 'rmarkdown::render("01a_intro_text_analytics.Rmd"'
	$(KNIT)

01b_WDR_data-exploration_abstracts.html: 01b_WDR_data-exploration_abstracts.Rmd R/f_facetted_bar_plot.R
	#Rscript -e 'rmarkdown::render("01b_WDR_data-exploration_abstracts.Rmd")'
	$(KNIT)

01c_WDR_data-exploration_subjects.html: 01c_WDR_data-exploration_subjects.Rmd slogan.bib
	$(KNIT)

01d_WBoper_data-exploration.html: 01d_WBoper_data-exploration.Rmd slogan.bib
	$(KNIT)

clean_process:
	rm -rf $(PROCESS_DIR)/*

################################################################################
# ---------- STEP I.c) Analyze data
################################################################################
#ANALYSIS_DIR = $(RDIR)/analysis
#ANALYSIS_SOURCE = $(wildcard $(ANALYSIS_DIR)/*.Rmd)
#ANALYSIS_OUT = $(ANALYSIS_SOURCE:.Rmd=.docx)

# $(ANALYSIS_DIR)/%.docx:$(ANALYSIS_DIR)/%.Rmd $(PROCESS_OUT)
# 	$(KNIT)



# ------------------ II) Deploy Website using Mekafile ------------------ #

################################################################################
# ----- STEP II.a) Present data
################################################################################
#PRESENTATION_DIR = $(RDIR)/presentation
#PRESENTATION_SOURCE = $(wildcard $(PRESENTATION_DIR)/*.Rmd)
#PRESENTATION_OUT = $(PRESENTATION_SOURCE:.Rmd=.html)

# $(PRESENTATION_DIR)/%.docx:$(PRESENTATION_DIR)/%.Rmd $(ANALYSIS_OUT)
# 	$(KNIT)

# clean:
# 	rm -fv $(GATHER_OUT)
# 	rm -fv $(PROCESS_OUT)
# 	rm -fv $(ANALYSIS_OUT)
# 	rm -fv $(PRESENTATION_OUT)


# [REFERENCE]
# ---- https://www.r-bloggers.com/2015/03/makefiles-and-rmarkdown/


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
	@echo $* = $($*) # 2 print variables use `make print-VARIABLE` (es: make print-RMD_FILES)


#.PHONY: variables
#variables:
#	@echo RMD_FILES: $(RMD_FILES)
#	@echo HTML_FILES: $(HTML_FILES)

# ----- Makefile RECIPES ----- #
.PHONY: all_site
all_site: clean_site build_site git

all_site_noclean: build_site  git

# git add -> commit -> push
git:
	git add -u
	git commit -m $(MSG)
	git push -u origin master

# Fix the weird thing that README.Rmd does not turn into README.md (for Github)
#README.md: README.Rmd
#	Rscript -e "rmarkdown::render("README.Rmd")"  #  output_format =  "github_document"

# Render the a collection of Rmarkdown files as website (if there are "index.Rmd" + "_site.yml")
# [the implicit INPUT of render_site is ".", EXCLUDING what starts with "_" or ".", R source code (".Rmd", .R), or anything excluded in _site.yml]
# [the implicit OUTPUT of render_site is "./docs/Blah.html" + dependencies in separate folder "./docs/Blah_files" + CSS/JavaScript in"site_libs" sub-directory ]
# ** [All output and supporting files are copied to a "_site" | "/docs" subdirectory]
build_site:
	Rscript -e "rmarkdown::render_site(encoding = 'UTF-8')"

# clean ./docs/*
.PHONY: clean_site
clean_site:
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
		# `%` 			wildcard (when a bunch of files are built the same way)
		# `$(...)`   tells Make to replace a variable with its value when Make is run.
		# `wildcard` gets a list of files matching
		# `patsubst` (PATTERN, REPLACEMENT string, LIST of names in that order) =
								# each name in the list that matches the pattern is replaced by the replacement string.

# --------------------- AUTOMATIC Variables --------------------- #
    # $@ refers to the target of the current rule.
    # $(@D) the directory part of the target of the current rule.
    # $(@F) the file part of the target of the current rule.

    # $^ refers to ALL dependencies of the current rule.
    # $< refers to the first dependency of the current rule.
  	# $(<D) the directory part of the first dependency.
    # $(<F) the file part of the first dependency

# --------- EXEs       -------------------------------------------------------------
#RMD_FILES  =  $(wildcard *.Rmd)

#results.txt : isles.dat abyss.dat last.dat

#	python testzipf.py abyss.dat isles.dat last.dat > results.txt
#  --> becomes:
#results.txt : isles.dat abyss.dat last.dat
#	python testzipf.py $^ > $@
