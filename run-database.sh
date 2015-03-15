#!/bin/bash

if [[ "$1" == "--initialize" ]]; then
  # Move the config overrides file to the data volume so it persists.
  # The Dockerfile already created a symlink so that couchdb will pick it up.
  mv /tmp/couchdb/local.ini "$DATA_DIRECTORY"

  couchdb -b
  until nc -z localhost 5984; do sleep 0.1; done

  {
    curl -sX PUT localhost:5984/"${DATABASE:-db}"
    username=${USERNAME:-aptible}
    curl -sX PUT localhost:5984/_config/admins/"$username" -d "\"$PASSPHRASE\""
    curl -sX PUT "$username":"$PASSPHRASE"@localhost:5984/_config/couch_httpd_auth/require_valid_user -d '"true"'
  } > /dev/null
  kill $(cat /var/run/couchdb/couchdb.pid)
  exit
fi

couchdb
