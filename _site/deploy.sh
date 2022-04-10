

# DEPLOY
# When you build a static site, generated files are in _site directory.

R -e `rmarkdown::render_site()`


cd _site
git add --all
git commit -m "Deploy updates"
git push origin gh-pages


# PUTTING ALL IN A SCRIPT
echo -e "\033[0;32mDeploying updates to GitHub...\033[0m"

# Build the project.
hugo # if using a theme, replace with `hugo -t <YOURTHEME>`
### or maybe my build....

# Go To Public folder
cd public

# Add changes to git.
git add .

# Commit changes.
msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

# Push source and build repos.
git push origin master

# Come Back up to the Project Root
cd ..
