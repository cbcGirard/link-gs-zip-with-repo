#!/usr/bin/env bash

. /autograder/source/env.sh
. /autograder/source/envVars.sh

mkdir -p /root/.ssh
cp /autograder/source/ssh_config /root/.ssh/config


apt-get install -y python3.12 python3-pip python3-dev
python3.12 -m pip install jsonschema
python3.12 -m pip install pytest


# Make sure to include your private key here

cp /autograder/source/deploy_keys/deploy_key /root/.ssh/deploy_key

chmod 600 /root/.ssh/deploy_key

# To prevent host key verification errors at runtime

ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts
ssh-keyscan -t rsa github.ucsb.edu >> ~/.ssh/known_hosts

# Clone autograder files

mkdir -p ${BASE_DIR}/${REPO_NAME}
git clone -b ${GIT_BRANCH} --single-branch ${GIT_REPO} ${BASE_DIR}/${REPO_NAME}


if [ -f ${BASE_DIR}/${REPO_NAME}/MAKE-REFERENCE.sh ]; then
    echo "Installing software for submit.cs transition diff-based testing"
    mkdir -p ${BASE_DIR}/${REPO_NAME}/gs-diff-based-testing
    git clone https://github.com/ucsb-gradescope-tools/gs-diff-based-testing.git  ${BASE_DIR}/${REPO_NAME}/gs-diff-based-testing
fi

# If there is an apt-get.sh file in the repo, install what is needed

if [ -f ${BASE_DIR}/${REPO_NAME}/apt-get.sh ]; then
    echo "Installing Linux requirements from ${GIT_REPO}/apt-get.sh"
    chmod u+x ${BASE_DIR}/${REPO_NAME}/apt-get.sh
    ${BASE_DIR}/${REPO_NAME}/apt-get.sh
else
    echo "No apt-get.sh found in repo"
fi

# If there is a requirements.txt file in the repo, Install python dependencies

if [ -f ${BASE_DIR}/${REPO_NAME}/requirements.txt ]; then
    echo "Installing Python requirements from ${GIT_REPO}/requirements.txt"
    pip install -r ${BASE_DIR}/${REPO_NAME}/requirements.txt
else
    echo "No requirements.txt found in repo"
fi

# If there is a requirements3.txt file in the repo, install python3 dependencies

if [ -f ${BASE_DIR}/${REPO_NAME}/requirements3.txt ]; then
    echo "Installing Python3 requirements from ${GIT_REPO}/requirements.txt"
    python3.12 -m pip install -r ${BASE_DIR}/${REPO_NAME}/requirements3.txt
else
    echo "No requirements3.txt found in repo"
fi


