#!/usr/bin/env bash

set -Eeuo pipefail

readonly PLATFORM="${PLATFORM:-linux/amd64}"
readonly REGISTRY="${ALIYUN_REGISTRY_DOMAIN}"
readonly NAMESPACE="${ALIYUN_REGISTRY_SPACE_NAME}"

success=0
failed=0

echo "========================================"
echo " Docker Image Sync"
echo "========================================"

while IFS= read -r src || [[ -n "$src" ]]; do

    # Ignore comments and empty lines
    [[ -z "$src" || "$src" =~ ^# ]] && continue

    image="${src##*/}"
    name="${image%%:*}"
    tag="${image#*:}"

    [[ "$image" == "$tag" ]] && tag="latest"

    dst="${REGISTRY}/${NAMESPACE}/${name}:${tag}"

    echo
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "📦 Source : $src"
    echo "🎯 Target : $dst"

    if crane copy \
        --platform "$PLATFORM" \
        "$src" \
        "$dst"
    then
        ((success++))
        echo "✅ Success"
    else
        ((failed++))
        echo "❌ Failed"
    fi

done < images.txt

echo
echo "========================================"
echo " Summary"
echo "----------------------------------------"
echo " Success : $success"
echo " Failed  : $failed"
echo "========================================"

(( failed == 0 ))
