#!/usr/bin/env bash
if [ "$#" -ne 6 ]; then
    PROG=$0
    echo "Invalid usage!"
    echo "usage: $PROG [email] [name] [personal access token] [branch name] [repository name] [commit message]"
    exit 1
fi
PROJECT_ROOT_DIR=`git rev-parse --absolute-git-dir | cut -d '.' -f1`
EMAIL=$1
NAME=$2
TOKEN=$3
BRANCH=$4
REPOSITORY=$5
COMMIT_MESSAGE=$6
if [[ $BRANCH == release-* ]]
then
    `git config --global user.email "$EMAIL"`
    `git config --global user.name "$NAME"`
    `git clone https://$TOKEN@github.com/Sensedia/$REPOSITORY repointegration`
    cd repointegration
    `git checkout -B $BRANCH`
    git pull origin $BRANCH
    `cp -Rf $PROJECT_ROOT_DIR/swagger-apis/* swagger-apis`
    `cp -Rf $PROJECT_ROOT_DIR/dictionary/* dictionary`
    git add .
    HAS_FILES_TO_BE_COMMITED=`git status | grep -Rin "nothing to commit"`
    if [[ $HAS_FILES_TO_BE_COMMITED == '' ]]
    then
        git commit -m "$COMMIT_MESSAGE"
        git push origin $BRANCH
        cd ..
    fi
    rm -rf repointegration
fi 