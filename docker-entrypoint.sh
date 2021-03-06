#!/bin/sh
# docker-entrypoint.sh
# Description: create default config and launch perkeep.
# Reference: https://perkeep.org/doc/server-config

CONFIG="$HOME/.config/perkeep/server-config.json"
USERPASS="perkeep:perkeep"

set -e

if test ! -f "$CONFIG"; then
  pk-put init --newkey
  KEY="$(cat ~/.config/perkeep/client-config.json | jq -r ".identity")"
  echo "$0: Key ID: $KEY"
  echo "$0: Creating $CONFIG"
  echo "$0: Initial user:passwd is $USERPASS - Change it!"
cat >"$CONFIG" << EOT
{
    "auth": "userpass:$USERPASS:+localhost",
    "listen": ":3179",
    "baseURL": "",
    "camliNetIP": "",
    "identity": "$KEY",
    "identitySecretRing": "$HOME/.config/perkeep/identity-secring.gpg",
    "blobPath": "/storage/blobs",
    "packRelated": true,
    "levelDB": "/storage/index.leveldb"
}
EOT
fi

exec perkeepd -configfile "$CONFIG"
