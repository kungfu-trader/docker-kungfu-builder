#!/bin/bash

set -e

INSTALL="yum -y install"
REINSTALL="yum -y reinstall"

$INSTALL http://repo.okay.com.mx/centos/7/x86_64/release/okay-release-1-1.noarch.rpm
$INSTALL centos-release-scl

yum-config-manager --enable centos-sclo-rh-testing centos-sclo-sclo-testing

curl -sSL https://rpm.nodesource.com/setup_10.x | bash -

$INSTALL awscli \
         cmake3 \
         devtoolset-9 \
         git \
         kde-l10n-Chinese \
         make \
         nodejs \
         rpm-build \
         xz \
         openssl-devel \
         bzip2-devel \
         libffi-devel \
         xz-devel \
         readline-devel \
         sqlite-devel \
         zlib-devel

$REINSTALL glibc-common
localedef -c -f GB18030 -i zh_CN zh_CN.GB18030

echo "source /opt/rh/devtoolset-9/enable" >> /etc/profile
echo "source /opt/rh/devtoolset-9/enable" >> /etc/bashrc

source /opt/rh/devtoolset-9/enable

ln -s /usr/bin/cmake3 /usr/bin/cmake

mkdir /tmp/code
cd /tmp/code
curl -sSL -o python.tar.xz https://www.python.org/ftp/python/3.7.10/Python-3.7.10.tar.xz
mkdir python
tar -xf python.tar.xz -C python
cd python
./configure --with-ensurepip=install --enable-optimizations --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib"
make install
cd /
rm -rf /tmp/code

pip3 install pipenv==2020.11.15