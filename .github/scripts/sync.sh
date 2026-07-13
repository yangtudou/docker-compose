#!/usr/bin/env bash

set -Eeuo pipefail

readonly PLATFORM="${PLATFORM:-linux/amd64}"
readonly REGISTRY="${ALIYUN_REGISTRY_DOMAIN}"
readonly NAMESPACE="${ALIYUN_REGISTRY_SPACE_NAME}"
readonly CONFIG_FILE="${1:-images.txt}"
readonly MAX_CONCURRENT="${MAX_CONCURRENT:-4}"

if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "::error::Config file '$CONFIG_FILE' not found."
    exit 1
fi

# 读取并去重
mapfile -t IMAGES < <(
    grep -Ev '^[[:space:]]*(#|$)' "$CONFIG_FILE" \
    | awk '!seen[$0]++'
)

readonly TOTAL=${#IMAGES[@]}
[[ $TOTAL -eq 0 ]] && { echo "::notice::Nothing to sync."; exit 0; }

START_TIME=$(date +%s)
failed_count=0
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

echo "========================================"
echo " 🚀 Docker Image Sync Pipeline"
echo "========================================"

# 并发轰炸
for ((i=0; i<TOTAL; i++)); do
    src="${IMAGES[i]}"
    task_num=$((i + 1))

    (
        set -Eeuo pipefail
        image="${src##*/}"
        name="${image%%:*}"
        tag="${image#*:}"
        [[ "$image" == "$tag" ]] && tag="latest"

        dst="${REGISTRY}/${NAMESPACE}/${name}:${tag}"
        log_file="${TMP_DIR}/${task_num}.log"
        begin=$(date +%s)

        if crane copy --platform "$PLATFORM" "$src" "$dst" >"$log_file" 2>&1; then
            printf "[%02d/%02d] %-35s ✅ %2ss\n" "$task_num" "$TOTAL" "$image" "$(( $(date +%s) - begin ))"
            exit 0
        fi

        printf "[%02d/%02d] %-35s ❌ %2ss\n" "$task_num" "$TOTAL" "$image" "$(( $(date +%s) - begin ))"
        echo "::group::Failed Logs - ${src}"
        cat "$log_file"
        echo "::endgroup::"
        echo "::error::Failed to sync ${src}"
        exit 1
    ) &

    while [[ $(jobs -rp | wc -l) -ge "$MAX_CONCURRENT" ]]; do
        wait -n || failed_count=$((failed_count + 1))
    done
done

# 等待残余任务
while [[ $(jobs -rp | wc -l) -gt 0 ]]; do
    wait -n || failed_count=$((failed_count + 1))
done

echo "----------------------------------------"
echo " 🎉 All tasks finished in $(( $(date +%s) - START_TIME ))s. (Failed: $failed_count)"
echo "========================================"

if (( failed_count > 0 )); then
    echo "::error::$failed_count image(s) failed."
    exit 1
fi
