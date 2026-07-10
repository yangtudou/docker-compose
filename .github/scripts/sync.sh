#!/usr/bin/env bash

set -Eeuo pipefail

readonly PLATFORM="${PLATFORM:-linux/amd64}"
readonly REGISTRY="${ALIYUN_REGISTRY_DOMAIN}"
readonly NAMESPACE="${ALIYUN_REGISTRY_SPACE_NAME}"
readonly TOTAL=$(grep -Ec '^[[:space:]]*[^#[:space:]]' images.txt)

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
    echo "📦 [$((success + failed + 1))/$TOTAL] Source : $src"
    echo "🎯 Target : $dst"

    if crane copy \
        --platform "$PLATFORM" \
        "$src" \
        "$dst" \
        >/dev/null 2>&1
    then
        ((++success))
        echo "✅ Success"
    else
        ((++failed))
        echo "❌ Failed"
    fi

done < "images.txt"

echo
echo "========================================"
echo " Summary"
echo "----------------------------------------"
echo " Success : $success"
echo " Failed  : $failed"
echo "========================================"

if (( failed > 0 )); then
    echo "❌ ${failed} image(s) failed to sync."
    echo "========================================"
    exit 1
fi

echo "🎉 All images synced successfully."
echo "========================================"
