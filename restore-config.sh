#!/bin/sh
# restore-config.sh
# Description: restore perkeep config files in container.

#CONTAINER="conf-test"
CONTAINER="perkeep_perkeep_1"
SRC="config-backup/perkeep"
DST="/home/perkeep/.config"

set -e

# - cd to $(dirname SRC) => config-backup
# - SRC = $(basename SRC) => perkeep
# - write to stdout
# - read from stdin and extract to DST
tar c -C $(dirname $SRC) $(basename $SRC) | docker exec -i $CONTAINER tar x -C $DST -f -

docker exec $CONTAINER ls -hl /home/perkeep/.config/perkeep
