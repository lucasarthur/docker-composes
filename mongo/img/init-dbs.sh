#!/bin/bash
set -e

REPLICA_SET="${REPLICA_SET_NAME:-rs0}"

mongod --dbpath /var/lib/mongo1 --logpath /var/log/mongo1/mongod.log --fork --port 27017 --bind_ip_all --replSet "${REPLICA_SET}"
mongod --dbpath /var/lib/mongo2 --logpath /var/log/mongo2/mongod.log --fork --port 27018 --bind_ip_all --replSet "${REPLICA_SET}"
mongod --dbpath /var/lib/mongo3 --logpath /var/log/mongo3/mongod.log --port 27019 --bind_ip_all --replSet "${REPLICA_SET}"
