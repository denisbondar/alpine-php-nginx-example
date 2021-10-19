#!/bin/sh
set -e
export TZ=$(test -e /etc/timezone && cat /etc/timezone || echo "UTC")

exec "$@"
