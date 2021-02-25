FROM centos:7
COPY opt /opt
RUN bash /opt/scripts/setup.sh
ENV USE_HARD_LINKS=false \
    LANG=en_US.UTF-8