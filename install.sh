#!/bin/bash

# https://docs.gitlab.com/ce/ci/docker/using_docker_build.html#using-docker-build

REGISTRATION_TOKEN=$1
DESCRIPTION=$2

echo "Updating ubuntu repository and installing some dependencies"
sudo apt-get -y update && sudo apt-get -y install build-essentials

echo "Installing docker"
curl -sSL https://get.docker.com/ | sh

echo "Add Gitlab's official repository"
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-ci-multi-runner/script.deb.sh | sudo bash

echo "Installing gitlab-ci-multi-runner"
sudo apt-get -y install gitlab-ci-multi-runner

echo "Registering a gitlab-ci-multi-runner"
sudo gitlab-ci-multi-runner register -n \
  --url https://gitlab.com/ci \
  --registration-token $(REGISTRATION_TOKEN) \
  --executor shell \
  --description $(DESCRIPTION)

echo "Adding gitlab-runner user to docker group"
sudo usermod -aG docker gitlab-runner

echo "Adding docker user to "${USER}" group"
sudo usermod -a -G docker ${USER}

echo "Running gitlab-ci-multi-runner"
sudo gitlab-runner run

echo "Verifying gitlab-ci-multi-runner"
sudo gitlab-ci-multi-runner verify
