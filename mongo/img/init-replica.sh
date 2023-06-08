#!/bin/bash
set -e

LOCAL_HOST="${HOST:-localhost}"
REPLICA_SET="${REPLICA_SET_NAME:-rs0}"

wait-for-it "${LOCAL_HOST}:27017" -t 0 -q
wait-for-it "${LOCAL_HOST}:27018" -t 0 -q
wait-for-it "${LOCAL_HOST}:27019" -t 0 -q

mongosh --eval "\
  disableTelemetry(); \
  try { \
    rs.status(); \
    print('Replica set up and running!'); \
  } catch (e) { \
    print('Initializing replica set...'); \
    rs.initiate({ \
      '_id': '${REPLICA_SET}', \
      'members': [ \
        { '_id': 0, 'host': '${LOCAL_HOST}:27017', 'priority': 2 }, \
        { '_id': 1, 'host': '${LOCAL_HOST}:27018', 'priority': 0 }, \
        { '_id': 2, 'host': '${LOCAL_HOST}:27019', 'priority': 0 } \
      ] \
    }); \
    print('Replica set up and running!'); \
  }"
