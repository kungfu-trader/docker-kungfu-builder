FROM centos:7
COPY opt /opt
RUN bash /opt/scripts/setup.sh
ENV USE_HARD_LINKS=false \
    LANG=en_US.UTF-8 \
    PATH=/opt/rh/rh-git218/root/usr/bin:/opt/rh/devtoolset-9/root/usr/bin:${PATH}