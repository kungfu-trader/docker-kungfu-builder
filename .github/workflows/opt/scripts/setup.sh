#!/bin/bash

yum -y install git \
         sudo \
         rpm-build \
         make \
         openssl-devel \
         bzip2-devel \
         libffi-devel \
         xz-devel \
         readline-devel \
         sqlite-devel \
         zlib-devel \
         wget \
         centos-release-scl

yum-config-manager --enable centos-sclo-rh-testing
yum-config-manager --enable centos-sclo-sclo-testing

yum install -y devtoolset-9

echo "source /opt/rh/devtoolset-9/enable" >> /etc/profile
echo "source /opt/rh/devtoolset-9/enable" >> ~/.bashrc

source ~/.bashrc

mkdir /tmp/python
cd /tmp/python
wget https://www.python.org/ftp/python/3.7.7/Python-3.7.7.tgz
tar xzf Python-3.7.7.tgz
cd Python-3.7.7
./configure --with-ensurepip=install --enable-optimizations --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib"
make install
cd /
rm -rf /tmp/python

curl -sL https://rpm.nodesource.com/setup_10.x | bash - && yum -y install nodejs

yum install -y kde-l10n-Chinese
yum reinstall -y glibc-common
localedef -c -f GB18030 -i zh_CN zh_CN.GB18030

yum install -y http://repo.okay.com.mx/centos/7/x86_64/release/okay-release-1-1.noarch.rpm
yum install -y cmake3
ln -s /usr/bin/cmake3 /usr/bin/cmake

pip3 install pipenv==2020.11.15

echo "127.0.0.1 local-test" >> /etc/hosts