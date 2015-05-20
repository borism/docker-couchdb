FROM quay.io/aptible/ubuntu:14.04

RUN apt-get install -y couchdb curl
RUN apt-get install -y python2.7 python-pip python-dateutil
RUN pip install couchdb
RUN mkdir -p /var/run/couchdb

ADD templates/etc/couchdb /var/lib/couchdb
RUN rm -f /etc/couchdb/local.ini && \
    ln -s /var/lib/couchdb/local.ini /etc/couchdb/

ADD test /tmp/test
RUN bats /tmp/test

VOLUME ["/var/lib/couchdb"]
EXPOSE 5984

CMD /usr/bin/couchdb
