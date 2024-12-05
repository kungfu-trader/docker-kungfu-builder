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

# 安装必要的软件包（不包括gcc，因为我们将手动编译）
$INSTALL awscli \
         dnsutils \
         ccache \
         cmake \
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

# 安装编译gcc所需的依赖
$INSTALL libgmp-dev libmpfr-dev libmpc-dev wget

# 下载并解压GCC源代码
GCC_VERSION="11.3.0"
cd /tmp
wget http://ftp.gnu.org/gnu/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.gz
tar -xvzf gcc-$GCC_VERSION.tar.gz
cd gcc-$GCC_VERSION

# 创建一个新的build目录并进入
mkdir build
cd build

# 配置GCC编译选项
../configure --prefix=/usr/local/gcc-$GCC_VERSION \
             --enable-languages=c,c++ \
             --disable-multilib \
             --with-default-libstdcxx-abi=gcc4-compatible

# 编译并安装GCC
make -j$(nproc)
make install

# 设置默认GCC和G++版本为手动编译的版本
update-alternatives --install /usr/bin/gcc gcc /usr/local/gcc-$GCC_VERSION/bin/gcc 100
update-alternatives --install /usr/bin/g++ g++ /usr/local/gcc-$GCC_VERSION/bin/g++ 100

# 确认gcc和g++版本
gcc --version
g++ --version
gcc -v

# 设置语言环境
locale-gen zh_CN.GB18030
locale-gen zh_CN.UTF-8
update-locale LANG=zh_CN.UTF-8

# 使用npm安装全局依赖
$NPM_INSTALL glob@^8
$NPM_INSTALL yarn@^1

# 创建符号链接，便于全局依赖的查找
ln -s /usr/lib/node_modules /node_modules

# 使用yarn安装工具
$YARN_INSTALL lerna@^5
$YARN_INSTALL wsrun@^5
$YARN_INSTALL prettier@~2.7

# 构建并安装指定版本的Python，确保使用gcc-11
mkdir /tmp/code
cd /tmp/code
curl -sSLO https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tar.xz
tar -xf Python-$PYTHON_VERSION.tar.xz
cd Python-$PYTHON_VERSION
CC=/usr/local/gcc-$GCC_VERSION/bin/gcc CXX=/usr/local/gcc-$GCC_VERSION/bin/g++ ./configure --with-ensurepip=install --enable-optimizations --enable-shared \
    LDFLAGS="-Wl,-rpath /usr/local/lib" \
    --with-default-libstdcxx-abi=gcc4-compatible
make install
cd /
rm -rf /tmp/code

# 创建Python和CMake的符号链接
ln -s /usr/bin/cmake /usr/local/bin/cmake
ln -s /usr/local/bin/python3 /usr/local/bin/python

# 安装Python工具
$PIP_INSTALL --upgrade pip setuptools
$PIP_INSTALL pipx==1.1.0

$PIPX_INSTALL black==22.3.0
$PIPX_INSTALL clang-format==15.0.7
$PIPX_INSTALL pipenv==2022.8.15
$PIPX_INSTALL poetry==1.2.2

pipx ensurepath
