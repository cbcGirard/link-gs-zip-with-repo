#!/usr/bin/env bash

# Extract just the git repo:
#   https://serverfault.com/questions/417241/extract-repository-name-from-github-url-in-bash

BASE_DIR=/autograder/git-repo
WITHOUT_SUFFIX="${GIT_REPO%.*}"
REPO_NAME="$(basename "${WITHOUT_SUFFIX}")"

# If no branch is specified, check it out
if [ -z "$GIT_BRANCH" ]; then
    GIT_BRANCH=master
fi

echo \$BASE_DIR=$BASE_DIR
echo \$GIT_REPO=$GIT_REPO
echo \$REPO_NAME=$REPO_NAME
echo \$GIT_BRANCH=$GIT_BRANCH
