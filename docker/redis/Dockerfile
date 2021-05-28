FROM redis:6.0.9

MAINTAINER Claude Simo <jeanclaude.simo@abus-kransysteme.de>

COPY config/redis.conf /usr/local/etc/redis/redis.conf
CMD [ "redis-server", "/usr/local/etc/redis/redis.conf" ]
