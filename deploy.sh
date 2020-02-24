#!/bin/bash

echo "Deploying image to DockerHub..."

docker login -u "$DOCKER_LOGIN" -p "$DOCKER_PASSWORD";
docker push strider2038/php-cli-dev
docker push strider2038/php-cli-dev:7.4
docker push strider2038/php-cli-dev:7.3
docker push strider2038/php-cli-dev:7.2
