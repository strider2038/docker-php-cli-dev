FROM php:8.1-cli-alpine

ENV COMPOSER_HOME=/var/run/composer \
    XDEBUG_CONFIG="remote_enable=1 remote_mode=req remote_port=9001 remote_host=172.17.0.1 remote_log=/app/var/xdebug.log" \
    PHP_IDE_CONFIG="serverName=default"

RUN set -xe \
    && apk add --update \
        nano \
        iputils \
        bash \
        curl \
        git \
    && apk add --no-cache --update --virtual .build-deps \
        $PHPIZE_DEPS \
        icu-dev \
        libxml2-dev \
    && pecl install xdebug \
    && docker-php-ext-install \
        bcmath \
        intl \
        soap \
    && docker-php-ext-enable \
        xdebug \
        bcmath \
        intl \
        soap \
    && runDeps="$( \
        scanelf --needed --nobanner --format '%n#p' --recursive /usr/local/lib/php/extensions \
            | tr ',' '\n' \
            | sort -u \
            | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
    )" \
    && apk add --no-cache --virtual .php-phpexts-rundeps $runDeps \
    && apk del .build-deps \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && chmod -R 0777 $COMPOSER_HOME

COPY ./.docker /

WORKDIR /app

EXPOSE 9001

CMD [ "/idle.sh" ]
