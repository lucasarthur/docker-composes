#!/bin/bash
set -e

/bin/bash /usr/local/bin/init-replica.sh &
/bin/bash /usr/local/bin/init-dbs.sh
