#!/bin/bash 

# Repositories to be updated
REPOSITORIES=(
    dependent-project
)


# Find the version inside the package.json that matchs the format "X.X.X"
VALID_VERSION="$(grep -E -o "\"version\": \"[[:digit:]]{1,}.[[:digit:]]{1,}.[[:digit:]]{1,}\"," package.json | grep -E -o "[[:digit:]]{1,}.[[:digit:]]{1,}.[[:digit:]]{1,}")"

#  Check if a valid version exits
if [ -z "$VALID_VERSION" ]
then
      exit 0
fi

# Go to the Temporary folder on the system
cd /tmp

# remove old repositories folder (if exists) and create a new one
rm -rf whg_repos 

# create a folder to store the repositories and navigate into it
mkdir whg_repos
cd whg_repos

for repo in "${REPOSITORIES[@]}"
do
    git clone git@github.com:amgfelgueiras/${repo}.git
    cd ${repo}
    npm install
    npm install @amgfelgueiras/typescript-package-starter
    npm build
    git add .
    git commit -m "ng-shared updated to v${VALID_VERSION}"
    git push
done