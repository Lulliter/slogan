#=========================================== (Render site Locally) ================================================#

# ====== Font Awesome Extension for Quarto
quarto add quarto-ext/fontawesome # https://github.com/quarto-ext/fontawesome#readme
#quarto install extension shafayetShafee/bsicons # https://icons.getbootstrap.com/#icons
quarto install extension schochastics/academicons # https://jpswalsh.github.io/academicons/
#quarto add mcanouil/quarto-iconify

# ====== RUN tar_make() to render reports in ./analysis/*    !!!!!!!!
Rscript -e "targets::tar_make(callr_function = NULL)"
# EACH
Rscript -e "targets::tar_make(all_proj)" # DATA dep
Rscript -e "targets::tar_make(all_proj_25)" # DATA dep
Rscript -e "targets::tar_make(all_proj_themes_25_l)"
Rscript -e "targets::tar_make(all_proj_sectors_25_l)"

Rscript -e "targets::tar_make(prep_report)"  # 01a_WB_project_pdo_prep.qmd

Rscript -e "targets::tar_make(projs_train)" # DATA dep
Rscript -e "targets::tar_make(pdo_train_t)" # DATA dep

Rscript -e "targets::tar_make(eda_report)"  # 01b_WB_project_pdo_EDA.qmd

Rscript -e "targets::tar_make(feat_class_report)"  # 01c_....qmd

Rscript -e "targets::tar_make(analysis_reports)" #
Rscript -e "targets::tar_make(post_page)"

Rscript -e "targets::tar_make(index_page)"
Rscript -e "targets::tar_make(research_page)"
Rscript -e "targets::tar_make(render_website)"

# GRAPH
Rscript -e "targets::tar_visnetwork()" (dalla console)

# ====== RENDER the entire site (not needed if you run tar_make)
         # quarto preview
         quarto preview

         # ====== RENDER the entire site
         quarto render
         quarto render analysis/01a_WB_project_pdo_prep.qmd --to html
         quarto render posts/PDO_eda.qmd --to html

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
git commit -m "analysis/00_data.qmd 📊📊"
git commit -m "maj revision analysis/ post 2025 input 🥵" -m "added 2025 data 🥵 and messeu up some stuff"
git commit -m "small upd Home 👇🏻"
		# git commit -m "revision INSTALL + cleanup slides 2"  -m "01_... + 00_carico_tab-contesto.qmd "
git commit -m "100% done blog  🍾🥂"

# Push local source (master branch) to remote reference (origin)
#cd .
git push origin master

#=========================================== ALL IN ONE  ================================================#
git add -u && git commit -a -m "small upd Home 👇🏻👇🏻" && git push

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
