#!/bin/sh
echo `date` > toDeploy.txt
echo '=================== Prepare ==================='
GITHUB_DEPLOY_REPOSITORY=${GITHUB_REMOTE_REPOSITORY:-$GITHUB_REPOSITORY}
GITHUB_DEPLOY_BRANCH=${GITHUB_BRANCH:-"gh-pages"}
echo '=================== Create deploy key to push ==================='
mkdir ~/.ssh
ssh-keyscan -t rsa github.com > ~/.ssh/known_hosts && \
echo "${GIT_DEPLOY_KEY}" > ~/.ssh/id_rsa && \
chmod 400 ~/.ssh/id_rsa
echo '=================== Publish to GitHub Pages ==================='
remote_repo="git@github.com:${GITHUB_DEPLOY_REPOSITORY}.git" && \
remote_branch=${GITHUB_DEPLOY_BRANCH} && \
echo "Pushing Builds to $remote_repo:$remote_branch" && \
git init && \
git remote add deploy $remote_repo && \
git checkout $remote_branch || git checkout --orphan $remote_branch && \
git config user.name "${GITHUB_ACTOR}" && \
git config user.email "${GITHUB_ACTOR}@users.noreply.github.com" && \
git add toDeploy.txt && \
echo -n 'Files to Commit:' && ls -l | wc -l && \
timestamp=$(date +%s%3N) && \
git commit -m "Automated deployment to GitHub Pages on $timestamp" > /dev/null 2>&1 && \
git push deploy $remote_branch --force && \
rm -fr .git && \
echo '=================== Done  ==================='