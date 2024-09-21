#!/bin/bash
CONTAINER_NAME=example

docker stop $CONTAINER_NAME
docker rm $CONTAINER_NAME