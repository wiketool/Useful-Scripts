#!/bin/bash

IMAGE_NAME="example"
VERSION_FILE=".version"
CONTAINER_NAME=example
# 初始化版本文件
touch "$VERSION_FILE" 2>/dev/null

# 获取当前版本号
CURRENT_VERSION=$(cat "$VERSION_FILE")

# 如果版本文件为空或不存在，则设置默认版本号为1.0
if [ -z "$CURRENT_VERSION" ]; then
    CURRENT_VERSION="1.0"
fi

# 解析版本号
read MAJOR MINOR <<< $(echo $CURRENT_VERSION | sed 's/\./ /g')

IMAGE="$IMAGE_NAME:$MAJOR.$MINOR"

docker run -itd --restart always --name $CONTAINER_NAME $IMAGE