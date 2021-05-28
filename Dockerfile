FROM centos:7
COPY opt /opt
RUN bash /opt/scripts/setup.sh
ENV USE_HARD_LINKS=false \
    LANG=en_US.UTF-8 \
    PATH=/opt/rh/rh-git218/root/usr/bin:/opt/rh/devtoolset-9/root/usr/bin:${PATH} \
    PERL5LIB=/opt/rh/rh-git218/root/usr/share/perl5/vendor_perl${PERL5LIB:+:${PERL5LIB}} \
    LD_LIBRARY_PATH=/opt/rh/httpd24/root/usr/lib64:${LD_LIBRARY_PATH}