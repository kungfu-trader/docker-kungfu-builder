FROM centos:7
COPY opt /opt
RUN bash /opt/scripts/setup.sh
ENV PATH=/opt/rh/devtoolset-9/root/usr/bin/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    USE_HARD_LINKS=false \
    LANG=en_US.UTF-8 \
    BASH_ENV=~/.bashrc  \
    ENV=~/.bashrc  \
    PROMPT_COMMAND="source ~/.bashrc"