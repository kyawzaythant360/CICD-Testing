#!/bin/bash
set -e

sudo chown -R www-data:www-data /var/www/html
sudo chown -R www-data:www-data /var/www/moodledata
# Continue with the original CMD
exec "$@"
