#!/bin/sh
set -eu

sed -i 's/html/html\/public/g' /etc/apache2/sites-enabled/000-default.conf

exec "$@"