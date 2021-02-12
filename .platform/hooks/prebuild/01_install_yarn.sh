#!/usr/bin/env bash
set -xe

# Install nodejs
echo "install nodejs"
curl --silent --location https://rpm.nodesource.com/setup_15.x | sudo bash -
yum -y install nodejs

# install yarn
echo "install yarn"
wget https://dl.yarnpkg.com/rpm/yarn.repo -O /etc/yum.repos.d/yarn.repo;
yum -y install yarn;

# install webpack-cli with yarn
echo "install webpack-cli"
cd "${app}";
yarn add webpack-cli;
