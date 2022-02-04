#!/bin/bash

set -e

PYTHON_VERSION="3.9.10"

INSTALL="yum -y install"
REINSTALL="yum -y reinstall"

$INSTALL centos-release-scl epel-release
yum-config-manager --enable centos-sclo-rh-testing centos-sclo-sclo-testing

curl -sSL https://dl.yarnpkg.com/rpm/yarn.repo -o /etc/yum.repos.d/yarn.repo
curl -sSL https://rpm.nodesource.com/setup_14.x | bash -

$INSTALL awscli \
         bind-utils \
         cmake3 \
         devtoolset-10 \
         rh-git227 \
         kde-l10n-Chinese \
         make \
         nodejs \
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
         yarn \
         zlib-devel

source /opt/rh/devtoolset-10/enable
source /opt/rh/rh-git227/enable

$REINSTALL glibc-common
localedef -c -f GB18030 -i zh_CN zh_CN.GB18030

npm install -g lerna@4.0.0

mkdir /tmp/code
cd /tmp/code
curl -sSLO https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tar.xz
tar -xf Python-$PYTHON_VERSION.tar.xz
cd Python-$PYTHON_VERSION
./configure --with-ensurepip=install --enable-optimizations --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib"
make install
cd /
rm -rf /tmp/code

pip3 install --upgrade pip
pip3 install pipenv==2022.1.8

ln -s /usr/bin/cmake3 /usr/bin/cmake
ln -s /usr/local/bin/python3 /usr/local/bin/python