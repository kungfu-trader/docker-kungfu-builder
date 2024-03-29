#!/bin/bash

set -e

PYTHON_VERSION="3.9.15"
PIP_INSTALL="pip3 install"
PIPX_INSTALL="pipx install"

NPM_INSTALL="npm install --location=global"
YARN_INSTALL="yarn global add"

INSTALL="yum -y install"
REINSTALL="yum -y reinstall"

$INSTALL centos-release-scl epel-release
yum-config-manager --enable centos-sclo-rh-testing centos-sclo-sclo-testing

$INSTALL https://repo.ius.io/ius-release-el7.rpm

curl -sSL https://dl.yarnpkg.com/rpm/yarn.repo -o /etc/yum.repos.d/yarn.repo
curl -sSL https://rpm.nodesource.com/setup_16.x | bash -

$INSTALL awscli \
         bind-utils \
         ccache \
         cmake3 \
         devtoolset-11 \
         rh-git227 \
         kde-l10n-Chinese \
         make \
         nodejs \
         java-1.8.0-openjdk \
         java-1.8.0-openjdk-devel \
         rh-maven35-maven \
         patchelf \
         nmap \
         rpm-build \
         tcpdump \
         traceroute \
         xz \
         bzip2-devel \
         libffi-devel \
         openssl-devel \
         readline-devel \
         sqlite-devel \
         xz-devel \
         yum-utils \
         zlib-devel

source /opt/rh/devtoolset-11/enable
source /opt/rh/rh-git227/enable

$REINSTALL glibc-common
localedef -c -f GB18030 -i zh_CN zh_CN.GB18030
localedef -c -f UTF-8 -i zh_CN zh_CN.UTF-8

# use npm to install global dependencies
$NPM_INSTALL glob@^8
$NPM_INSTALL yarn@^1

# link system node_modules folder to find global deps
ln -s /usr/lib/node_modules /node_modules

# use yarn to install executables
$YARN_INSTALL lerna@^5
$YARN_INSTALL wsrun@^5
$YARN_INSTALL prettier@~2.7

mkdir /tmp/code
cd /tmp/code
curl -sSLO https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tar.xz
tar -xf Python-$PYTHON_VERSION.tar.xz
cd Python-$PYTHON_VERSION
./configure --with-ensurepip=install --enable-optimizations --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib"
make install
cd /
rm -rf /tmp/code

ln -s /usr/bin/cmake3 /usr/bin/cmake
ln -s /usr/local/bin/python3 /usr/local/bin/python

$PIP_INSTALL --upgrade pip setuptools
$PIP_INSTALL pipx==1.1.0

$PIPX_INSTALL black==22.3.0
$PIPX_INSTALL clang-format==15.0.7
$PIPX_INSTALL pipenv==2022.8.15
$PIPX_INSTALL poetry==1.2.2

pipx ensurepath
