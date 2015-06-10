#!/bin/bash

. /usr/bin/utilities.sh

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

elif [[ "$1" == "--client" ]]; then
  echo "This image does not support the --client option. Use curl instead." && exit 1

elif [[ "$1" == "--dump" ]]; then
  [ -z "$2" ] && echo "docker run aptible/couchdb --dump couchdb://... > dump.couch" && exit
  parse_url "$2"
  # For some reason, the output of `couchdb-dump` terminates lines with \r\r\n
  # and `couchdb-load` can't handle it. Pipe to `tr` to remove all \r.
  #
  # `couchdb-dump` outputs "Dumping document..." to stderr, and `docker run -t`
  # blurs the distinction between stdout and stderr, so it's important to not
  # use `-t` for invoking this.
  #
  # Note that these `couchdb-dump` and `couchdb-load` tools are part of the
  # python-couchdb package installed with apt-get in the Dockerfile.
  # CouchDB does not have usable dump/restore capabilities built in.
  couchdb-dump "http://"$user":"$password"@"$host":"${port:-5984}"/"$database"" 2>/dev/null | tr -d '\r'

elif [[ "$1" == "--restore" ]]; then
  [ -z "$2" ] && echo "docker run -i aptible/couchdb --restore couchdb://... < dump.couch" && exit
  parse_url "$2"
  couchdb-load "http://"$user":"$password"@"$host":"${port:-5984}"/"$database""

elif [[ "$1" == "--readonly" ]]; then
  # CouchDB doesn't have a daemon-wide read-only mode. Instead, while the
  # server is running, install a "design document" on a given database which
  # rejects update. Example of installing this design document:
  #
  # curl -X PUT http://user:pass@host:5984/db/_design/readonly --data '{"validate_doc_update":"function(){}"}'
  #
  # To remove read-only mode, the design document should be deleted.
  # Deleting it requires the document's revision id, which can be found by
  # issuing a GET or by taking note when the initial PUT returns.
  #
  # This is documented here:
  # design documents in general: http://couchdb-13.readthedocs.org/en/latest/api/design/
  # validate_doc_update: http://docs.couchdb.org/en/latest/couchapp/ddocs.html#vdufun
  #
  # With all of that said, leaving off read-only mode for now.
  echo "This image does not support read-only mode. Starting database normally."
  couchdb

else
  couchdb

fi
