#!/bin/bash

LOCAL_HOST="${HOST:-localhost}"
REPLICA_SET="${REPLICA_SET_NAME:-rs0}"

until echo 27017 27018 27019 | xargs -n1 nc -z "${LOCAL_HOST}"
do sleep .02
done

mongosh --eval "rs.status()" > /dev/null 2>&1
if [ $? -ne 0 ]; then
  mongosh --eval "rs.initiate({ \"_id\": \"${REPLICA_SET}\", \"members\": [{ \"_id\": 0, \"host\": \"${LOCAL_HOST}:27017\", \"priority\": 2 }, { \"_id\": 1, \"host\": \"${LOCAL_HOST}:27018\", \"priority\": 0 }, { \"_id\": 2, \"host\": \"${LOCAL_HOST}:27019\", \"priority\": 0 }] });"
fi
