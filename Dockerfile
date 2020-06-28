FROM centos:7
RUN yum -y install git sudo rpm-build && yum -y install make && yum -y install centos-release-scl && \
    yum-config-manager --enable centos-sclo-rh-testing && yum-config-manager --enable centos-sclo-sclo-testing && yum install -y devtoolset-9 && \
    echo "source /opt/rh/devtoolset-9/enable" >> /etc/profile && echo "source /opt/rh/devtoolset-9/enable" >> ~/.bashrc && source ~/.bashrc

RUN yum install -y  openssl-devel bzip2-devel libffi-devel xz-devel readline-devel sqlite-devel zlib-devel wget && wget https://www.python.org/ftp/python/3.7.7/Python-3.7.7.tgz && \
    tar xzf Python-3.7.7.tgz && cd Python-3.7.7 && ./configure --with-ensurepip=install --enable-optimizations --enable-shared LDFLAGS="-Wl,-rpath /usr/local/lib" && make install && cd .. && rm Python-3.7.7.tgz

RUN curl -sL https://rpm.nodesource.com/setup_10.x | bash - && yum -y install nodejs && \
    npm config set registry https://registry.npm.taobao.org && \
    npm config set puppeteer_download_host https://npm.taobao.org/mirrors && \
    npm config set electron_mirror https://npm.taobao.org/mirrors/electron/ && \
    npm config set sass-binary-site https://npm.taobao.org/mirrors/node-sass && \
    npm install -g yarn electron-builder

RUN  yum install -y kde-l10n-Chinese && yum reinstall -y glibc-common && localedef -c -f GB18030 -i zh_CN zh_CN.GB18030
RUN yum install -y http://repo.okay.com.mx/centos/7/x86_64/release/okay-release-1-1.noarch.rpm && yum -y install cmake3 && ln -s /usr/bin/cmake3 /usr/bin/cmake
RUN pip3 install pipenv==2018.11.26

ENV PATH=/opt/rh/devtoolset-9/root/usr/bin/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV USE_HARD_LINKS=false
ENV LANG=en_US.UTF-8
ENV BASH_ENV=~/.bashrc  \
    ENV=~/.bashrc  \
    PROMPT_COMMAND="source ~/.bashrc"

