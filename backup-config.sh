#!/bin/sh
# backup-config.sh
# Description: backup perkeep config files to host dir.

CONTAINER="perkeep_perkeep_1"
SRC="/home/perkeep/.config/perkeep"
DST="config-backup"

set -e

if test ! -d "$DST"; then
  echo "$0: mkdir: $DST"
  mkdir $DST
fi

# - cd to $(dirname $SRC) => /home/perkeep/.config)
# - SRC = $(basename $SRC) => perkeep
# - write to stdout
# - read from stdin and extract to DST 
docker exec $CONTAINER tar c -C $(dirname $SRC) $(basename $SRC) \
  | tar Cxf $DST -

ls -1 $DST/perkeep

# docker cp --archive 82abbb340410:/home/perkeep/.config/perkeep ./config-backup/perkeep
