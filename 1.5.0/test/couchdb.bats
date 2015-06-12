#!/usr/bin/env bats

@test "It should install CouchDB 1.5.0" {
  run couchdb -V
  [[ "$output" =~ "Apache CouchDB 1.5.0"  ]]
}
