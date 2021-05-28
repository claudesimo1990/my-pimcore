FROM nginx:1.19.5

MAINTAINER Claude Simo <jeanclaude.simo@abus-kransysteme.de>

ARG nginxconf
ARG nginxredirectsconf

RUN rm /etc/nginx/conf.d/default.conf

COPY config/$nginxconf /etc/nginx/nginx.conf

RUN mkdir /etc/nginx/config

COPY config/redirects/$nginxredirectsconf /etc/nginx/config/redirects.conf
