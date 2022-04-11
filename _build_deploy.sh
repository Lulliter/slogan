# Go to the right directory
cd ~/My\ Drive/Github/slogan

# PUTTING ALL IN A SCRIPT
echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

# DEPLOY
# When you build a static site, generated files are in _site directory (REPLACED WITH "docs")
# [in R] clean local website
#Rscript -e "rmarkdown::clean_site(preview = FALSE)"
rm -rf ./docs/*

# [in R] (re) build local website
Rscript -e "rmarkdown::render_site(encoding = 'UTF-8')"

# check
git status
# Stage
git add -u # git add --all  # git add README.html
# Commit (way 1)
#git commit -m "Added Lexicon tab"
# Commit (way 2)
          msg="rebuilding site `date`"
          if [ $# -eq 1 ]
            then msg="$1"
          fi
          git commit -m "$msg"
# Push source and build repos.
git push origin master
