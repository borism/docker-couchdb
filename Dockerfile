FROM quay.io/aptible/ubuntu:14.04

RUN apt-get install -y couchdb curl
RUN mkdir -p /var/run/couchdb

ADD test /tmp/test
RUN bats /tmp/test

VOLUME ["/var/lib/couchdb"]
EXPOSE 5984

CMD /usr/bin/couchdb
