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


#!/bin/bash
directory=website/_site
branch=gh-pages
build_command() {
  jekyll build
}

echo -e "\033[0;32mDeleting old content...\033[0m"
rm -rf $directory

echo -e "\033[0;32mChecking out $branch....\033[0m"
git worktree add $directory $branch

echo -e "\033[0;32mGenerating site...\033[0m"
build_command

echo -e "\033[0;32mDeploying $branch branch...\033[0m"
cd $directory &&
  git add --all &&
  git commit -m "Deploy updates" &&
  git push origin $branch

echo -e "\033[0;32mCleaning up...\033[0m"
git worktree remove $directory
