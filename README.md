# ![](https://gravatar.com/avatar/11d3bc4c3163e3d238d558d5c9d98efe?s=64) aptible/couchdb
[![Docker Repository on Quay.io](https://quay.io/repository/aptible/couchdb/status)](https://quay.io/repository/aptible/couchdb)

CouchDB on Docker.

## Installation and Usage

    docker pull quay.io/aptible/couchdb

This is an image conforming to the [Aptible database specification](https://support.aptible.com/topics/paas/deploy-custom-database/). To run a server for development purposes, execute

    docker create --name data quay.io/aptible/couchdb
    docker run --volumes-from data -e USERNAME=aptible -e PASSPHRASE=pass -e DB=db quay.io/aptible/couchdb --initialize
    docker run --volumes-from data -P quay.io/aptible/couchdb

The first command sets up a data container named `data` which will hold the configuration and data for the database. The second command creates a CouchDB instance with a username, passphrase and database name of your choice. The third command starts the database server.

## Available Tags

* `latest`: Currently CouchDB 1.5.0
* `1.5.0`: CouchDB 1.5.0

## Tests

Tests are run as part of the `Dockerfile` build. To execute them separately within a container, run:

    bats test

## Deployment

To push the Docker image to Quay, run the following command:

    make release

## Copyright and License

MIT License, see [LICENSE](LICENSE.md) for details.

Copyright (c) 2015 [Aptible](https://www.aptible.com) and contributors.

[<img src="https://s.gravatar.com/avatar/f7790b867ae619ae0496460aa28c5861?s=60" style="border-radius: 50%;" alt="@fancyremarker" />](https://github.com/fancyremarker)
