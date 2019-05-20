FROM php:7.2-cli-alpine

ENV COMPOSER_HOME=/var/run/composer \
    XDEBUG_CONFIG="remote_enable=1 remote_mode=req remote_port=9001 remote_host=172.17.0.1 remote_log=/app/var/xdebug.log" \
    PHP_IDE_CONFIG="serverName=default"

RUN set -xe \
    && apk add --update \
        $PHPIZE_DEPS \
        nano \
        iputils \
        bash \
        curl \
        git \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && docker-php-ext-install \
        bcmath \
        mbstring \
        intl \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && chmod -R 0777 $COMPOSER_HOME

COPY ./.docker /

WORKDIR /app

EXPOSE 9001

CMD [ "/idle.sh" ]
