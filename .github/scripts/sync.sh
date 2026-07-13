#!/usr/bin/env bash

set -Eeuo pipefail

readonly PLATFORM="${PLATFORM:-linux/amd64}"
readonly REGISTRY="${ALIYUN_REGISTRY_DOMAIN}"
readonly NAMESPACE="${ALIYUN_REGISTRY_SPACE_NAME}"

readonly src="$1" 

image="${src##*/}"
name="${image%%:*}"
tag="${image#*:}"

[[ "$image" == "$tag" ]] && tag="latest"

dst="${REGISTRY}/${NAMESPACE}/${name}:${tag}"

echo "========================================"
echo " Docker Image Sync (Parallel Task)"
echo "========================================"
echo "📦 Source : $src"
echo "🎯 Target : $dst"
echo "----------------------------------------"


if crane copy \
    --platform "$PLATFORM" \
    "$src" \
    "$dst" \
    >/dev/null 2>&1
then
    echo "✅ Success"
else
    echo "❌ Failed"
    exit 1
fi
