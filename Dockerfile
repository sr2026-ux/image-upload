FROM registry.access.redhat.com/ubi9/ubi:latest

ARG HTTP_PORT=8080

ENV APP_PORT=8080

RUN dnf -y install httpd && \
    dnf clean all && \
    sed -i 's/Listen 80/Listen ${HTTP_PORT}/g' /etc/httpd/conf/httpd.conf && \
    chgrp -R 0 /var/log/httpd /var/run/httpd && \
    chmod -R g=u /var/log/httpd /var/run/httpd

VOLUME /var/www/html

WORKDIR /var/www/html

COPY index.html .

LABEL description="My Apache web application running as container" \
      io.k8s.description="My Apache containerised application" \
      io.opensift.expose-services="8080:http" \
      io.openshift.tags="httpd, web server, apache"

EXPOSE ${APP_PORT}

USER 1001

CMD /usr/sbin/httpd -DFOREGROUND
