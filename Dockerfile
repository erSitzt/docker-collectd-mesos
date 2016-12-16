FROM gliderlabs/alpine:3.1

ARG http_proxy=http://proxy.expert.de:8080
ARG https_proxy=http://proxy.expert.de:8080

RUN apk-install collectd collectd-python collectd-network py-pip && \
    pip install envtpl

ADD collectd.conf.tpl /etc/collectd/collectd.conf.tpl

RUN apk-install git && \
    git clone https://github.com/rayrod2030/collectd-mesos.git /usr/share/collectd/plugins/mesos && \
    git clone https://github.com/criteo-forks/collectd-marathon.git /usr/share/collectd/plugins/marathon && \
    apk del git

ADD ./run.sh /run.sh

ENTRYPOINT ["/run.sh"]
