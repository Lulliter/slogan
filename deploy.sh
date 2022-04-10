# --------------  set up `gh-pages` in SUBFOLDER  -------------- #
# general configuration is to have sources in `master` branch and put generated files in `gh-pages` branch
# Static site generators usually generate files in the subdirectory such as _site.
# Since there are two branches, `master` and `gh-pages`, you need to move them from `master` branch
# to the root directory of `gh-pages` branch. It is required whenever you want to deploy.

# SET UP
# you need to have a `gh-pages` branch which is going to be mounted as a subdirectory.
git add website && git commit -m "Initial website subtree commit"
git subtree push --prefix website origin gh-pages


#...

# DEPLOY
# When you build a static site, generated files are in _site directory.
# Since _site is now gh-pages branch, you can deploy by just creating a commit and pushing it.
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
