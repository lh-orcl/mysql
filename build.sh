#!/bin/bash

# Exit if anything fails
set -e

DOCKER_RUN_REPO="lh-orcl"
DOCKER_RUN_IMAGE="mysql57"
DOCKER_MYSQL_NET="client-net"

docker build -t	$DOCKER_RUN_REPO/$DOCKER_RUN_IMAGE:latest .

docker images
docker run -di --name "$DOCKER_RUN_IMAGE" -p 3306:3306 -t "$DOCKER_RUN_REPO/$DOCKER_RUN_IMAGE"
docker network connect $DOCKER_MYSQL_NET $DOCKER_RUN_IMAGE
docker ps -a
