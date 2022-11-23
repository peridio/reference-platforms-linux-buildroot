#!/usr/bin/env bash
set -e

if [[ -n "$UID" ]] && [[ "$UID" != "0" ]] && [[ -n "$GID" ]] && [[ "$GID" != "0" ]]; then
  echo "Setting User"
  echo "UID: $UID"
  echo "GID: $GID"

  groupadd -o -g "$GID" peridio
  useradd -o -g "$GID" -u "$UID" -m peridio

  echo "Switching user"

  gosu peridio "$@"
else
  exec "$@"
fi


