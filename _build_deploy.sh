# Go to the right directory
cd ~/My\ Drive/Github/slogan

# PUTTING ALL IN A SCRIPT
echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

# DEPLOY
# When you build a static site, generated files are in _site directory (REPLACED WITH "docs")
# [in R] clean local website
#Rscript -e "rmarkdown::clean_site(preview = FALSE)"

#=====  (Clean Everiting *INSIDE* ./docs/*)
setopt rmstarsilent # prevent from asking me permission
rm -rf  docs/*
unsetopt rmstarsilent

# [in R] (re) build local website
Rscript -e "rmarkdown::render_site(encoding = 'UTF-8')"

# check
git status
# Stage
git add -u # git add --all  # git add README.html
# Commit (way 1)
# git commit -m "worked on WRD from API" -m "Put work in _my_stuff/_01_data-overview.Rmd bc it exe But not knit  "
# Commit (way 2)
          msg="rebuilding site `date`"
          if [ $# -eq 1 ]
            then msg="$1"
          fi
          git commit -m "$msg"
# Push source and build repos.
git push origin master






#=========================================== (accidentally committed files to the repository) ================================================#
git rm -r --cached _my_stuff/*  # followed by a commit and adding the file to .gitignore

