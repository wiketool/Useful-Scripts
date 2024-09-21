#!/bin/bash

IMAGE_NAME="example"
VERSION_FILE=".version"
DOCKERFILE_DIR=

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

# 新的小版本号
NEW_MINOR=$((MINOR + 1))

# 新的镜像名称
NEW_IMAGE="$IMAGE_NAME:$MAJOR.$NEW_MINOR"

# 在构建之前获取所有带有相同前缀的镜像ID
ALL_OLD_IMAGES=$(docker images -q "$IMAGE_NAME")

# 构建新的镜像
echo "开始构建新的 $NEW_IMAGE 镜像..."
docker build --build-arg USER_ID=$(id -u) --build-arg GROUP_ID=$(id -g) -t "$NEW_IMAGE" $DOCKERFILE_DIR

# 检查是否成功构建
if [ $? -eq 0 ]; then
    echo "新镜像 $NEW_IMAGE 构建成功！"
    
    # 获取新构建的镜像ID
    NEW_IMAGE_ID=$(docker images -q "$NEW_IMAGE")
    
    # 从所有旧镜像中排除新构建的镜像
    OLD_IMAGES=$(echo "$ALL_OLD_IMAGES" | tr '\n' ' ' | sed "s/ $NEW_IMAGE_ID //")
    
    if [ -n "$OLD_IMAGES" ]; then
        echo "正在删除旧的 $IMAGE_NAME 镜像..."
        for IMAGE_ID in $OLD_IMAGES; do
            docker rmi "$IMAGE_ID" -f
        done
    else
        echo "没有找到旧的 $IMAGE_NAME 镜像..."
    fi
    
    # 更新版本号
    NEW_VERSION="$MAJOR.$NEW_MINOR"
    echo "$NEW_VERSION" > "$VERSION_FILE"
    echo "已更新版本号至 $NEW_VERSION"
else
    echo "镜像构建失败，请检查Dockerfile或相关依赖。"
fi