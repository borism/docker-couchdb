# ![](https://gravatar.com/avatar/11d3bc4c3163e3d238d558d5c9d98efe?s=64) aptible/couchdb
[![Docker Repository on Quay.io](https://quay.io/repository/aptible/couchdb/status)](https://quay.io/repository/aptible/couchdb)

CouchDB on Docker.

## Installation and Usage

    docker pull quay.io/aptible/couchdb
    docker run quay.io/aptible/couchdb

## Advanced Usage

### Creating a database user with password

    docker run -v <host-mountpoint>/couchdb:/var/lib/couchdb quay.io/aptible/couchdb sh -c "couchdb -b && sleep 1 && curl -X PUT localhost:5984/_config/admins/aptible -d '\"password\"'"

### Creating a database

    docker run -v <host-mountpoint>/couchdb:/var/lib/couchdb quay.io/aptible/couchdb sh -c "couchdb -b && sleep 1 && curl -X PUT http://localhost:5984/db"

## Available Tags

* `latest`: Currently CouchDB 1.5.0

## Tests

Tests are run as part of the `Dockerfile` build. To execute them separately within a container, run:

    bats test

## Deployment

To push the Docker image to Quay, run the following command:

    make release

## Copyright and License

MIT License, see [LICENSE](LICENSE.md) for details.

Copyright (c) 2014 [Aptible](https://www.aptible.com), [Frank Macreery](https://github.com/fancyremarker), and contributors.
