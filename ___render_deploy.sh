#=========================================== (Render site Locally) ================================================#

# ====== Font Awesome Extension for Quarto
quarto add quarto-ext/fontawesome # https://github.com/quarto-ext/fontawesome#readme
#quarto install extension shafayetShafee/bsicons # https://icons.getbootstrap.com/#icons
quarto install extension schochastics/academicons # https://jpswalsh.github.io/academicons/
#quarto add mcanouil/quarto-iconify

# ====== RUN tar_make() to render reports in ./analysis/*    !!!!!!!!
Rscript -e "targets::tar_make(callr_function = NULL)"
# EACH
Rscript -e "targets::tar_make(prep_report)"
Rscript -e "targets::tar_make(projs_train)" # DATA dep
Rscript -e "targets::tar_make(pdo_train_t)" # DATA dep
Rscript -e "targets::tar_make(eda_report)"
Rscript -e "targets::tar_make(feat_class_report)"
Rscript -e "targets::tar_make(analysis_reports)" # error
Rscript -e "targets::tar_make(post_page)"

Rscript -e "targets::tar_make(index_page)"
Rscript -e "targets::tar_make(research_page)"
Rscript -e "targets::tar_make(render_website)"

# GRAPH
Rscript -e "targets::tar_visnetwork()"

# ====== RENDER the entire site (not needed if you run tar_make)
         # quarto preview
         quarto preview

         # ====== RENDER the entire site
         quarto render

#=========================================== (Push to Github repo) ================================================#
cd .

# check status
git status

# Add changes to git Index.
git add -A # ALL
git add -u # tracked
git add R/*
git add data/*
git add docs/*
git add images/*
git add         _extensions/quarto-ext/fontawesome/assets/css/all.min.css
git add analysis/output/figures/*
git add analysis/output/tables/*

git add posts/
git add research/
=======
# Create Std commit "message"....
msg="rebuilt on `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
# ... Commit Those changes.
git commit -m "$msg"
=======
git commit -m "targets review"
git commit -m "major reorg structure" -m "see especially analysis/*"
git commit -m "added analysis/* but mostly hidden "
		# git commit -m "revision INSTALL + cleanup slides 2"  -m "01_... + 00_carico_tab-contesto.qmd "
git commit -m "added analysis/00_intro_NLP.qmd analysis/01_text_data.qmd"

# Push local source (master branch) to remote reference (origin)
#cd .
git push origin master

#=========================================== ALL IN ONE  ================================================#
git add -u && git commit -a -m "small upd in research/hypotheses.qmd" && git push

#=========================================== FIle pubblico  ================================================#
# https://quarto.org/docs/publishing/quarto-pub.html
#  from ./
cd .
quarto publish quarto-pub 10_Validazione.qmd   # Published at https://lulliter.quarto.pub/validazione-dati-in-regis/
#-->>>>>>>  (dare ENTER x farlo partire)

# ====== Run Script that copies things
# PRIMA CHIUDO TUTTO WORD
Rscript R/salvo_output_li.R

#=========================================== (IGNORE a file accidentally committed in the past) ================================================#
# add .env file to .gitignore
echo "accident.txt" >> .gitignore
# tell Git NOT to track this file (it gets removed from the index, but stays local system)
git rm --writings/zzzz_old/
git rm --buzzwords.bib
git rm --cached buzzwords.bib
