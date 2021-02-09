#!/usr/bin/env bash
set -xe
# Install nodejs
echo "install nodejs"
curl --silent --location https://rpm.nodesource.com/setup_15.x | sudo bash -
yum -y install nodejs
echo "install yarn"
# install yarn
wget https://dl.yarnpkg.com/rpm/yarn.repo -O /etc/yum.repos.d/yarn.repo;
yum -y install yarn;
