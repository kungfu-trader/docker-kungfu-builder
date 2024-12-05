#!/bin/bash

set -e

PYTHON_VERSION="3.9.15"
PIP_INSTALL="pip3 install"
PIPX_INSTALL="pipx install"

NPM_INSTALL="npm install --location=global"
YARN_INSTALL="yarn global add"

INSTALL="apt-get install -y"
UPDATE="apt-get update"
UPGRADE="apt-get upgrade -y"

# 更新软件包列表和安装基本依赖
$UPDATE && $UPGRADE

$INSTALL software-properties-common curl locales gnupg

# 添加必要的第三方源
curl -sSL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

curl -fsSL https://deb.nodesource.com/setup_20.x | bash -

$UPDATE

# 安装必要的软件包
$INSTALL awscli \
         dnsutils \
         ccache \
         cmake \
         g++ \
         gcc \
         git \
         language-pack-zh-hans \
         make \
         nodejs \
         openjdk-8-jdk \
         openjdk-8-jdk-headless \
         maven \
         patchelf \
         nmap \
         dpkg-dev \
         tcpdump \
         traceroute \
         xz-utils \
         libbz2-dev \
         libffi-dev \
         libssl-dev \
         libreadline-dev \
         libsqlite3-dev \
         liblzma-dev \
         zlib1g-dev

# 设置语言环境
locale-gen zh_CN.GB18030
locale-gen zh_CN.UTF-8
update-locale LANG=zh_CN.UTF-8

# 使用 npm 安装全局依赖
$NPM_INSTALL glob@^8
$NPM_INSTALL yarn@^1

# 创建符号链接，便于全局依赖的查找
ln -s /usr/lib/node_modules /node_modules

# 使用 yarn 安装工具
$YARN_INSTALL lerna@^5
$YARN_INSTALL wsrun@^5
$YARN_INSTALL prettier@~2.7

# 构建并安装指定版本的 Python
mkdir /tmp/code
cd /tmp/code
curl -sSLO https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tar.xz
tar -xf Python-$PYTHON_VERSION.tar.xz
cd Python-$PYTHON_VERSION
./configure --with-ensurepip=install --enable-optimizations --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib"
make install
cd /
rm -rf /tmp/code

# 创建 Python 和 CMake 的符号链接
ln -s /usr/bin/cmake /usr/local/bin/cmake
ln -s /usr/local/bin/python3 /usr/local/bin/python

# 安装 Python 工具
$PIP_INSTALL --upgrade pip setuptools
$PIP_INSTALL pipx==1.1.0

$PIPX_INSTALL black==22.3.0
$PIPX_INSTALL clang-format==15.0.7
$PIPX_INSTALL pipenv==2022.8.15
$PIPX_INSTALL poetry==1.2.2

pipx ensurepath
