#!/bin/bash

usermod -s /bin/bash www-data
su - www-data
cron -f &
docker-php-entrypoint php-fpm