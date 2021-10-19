FROM alpine:3.14

RUN apk add --no-cache --update \
    nginx \
    php7 \
    php7-fpm \
    php7-ctype \
    php7-mbstring \
    php7-json \
    php7-opcache \
    curl \
    tzdata \
    tini \
    supervisor \
    logrotate \
    dcron \
    libcap \
    && chown nobody:nobody /usr/sbin/crond \
    && setcap cap_setgid=ep /usr/sbin/crond \
    && mkdir -p /app /logs \
    && rm -rf /tmp/* \
    /var/{cache,log}/* \
    /etc/logrotate.d \
    /etc/crontabs/* \
    /etc/periodic/daily/logrotate

COPY rootfs /

RUN chown -R nobody:nobody /app \
    && chown -R nobody:nobody /logs \
    && chown -R nobody:nobody /run \
    && chown -R nobody:nobody /var/lib \
    && chown -R nobody:nobody /var/log/nginx \
    && chown -R nobody:nobody /etc/crontabs 

USER nobody

WORKDIR /app

COPY --chown=nobody:nobody app /app

VOLUME "/logs"

EXPOSE 8080

ENTRYPOINT ["/sbin/tini", "--", "/usr/bin/docker-entrypoint.sh"]

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

HEALTHCHECK --timeout=10s CMD curl --silent --fail http://127.0.0.1:8080/fpm-ping
