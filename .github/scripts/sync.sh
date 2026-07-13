#!/usr/bin/env bash

set -Eeuo pipefail

########################################
# Config
########################################

readonly PLATFORM="${PLATFORM:-linux/amd64}"
readonly REGISTRY="${ALIYUN_REGISTRY_DOMAIN}"
readonly NAMESPACE="${ALIYUN_REGISTRY_SPACE_NAME}"
readonly CONFIG_FILE="${1:-images.txt}"  # 🌟 完美解耦：默认 images.txt，也支持参数传入
readonly MAX_CONCURRENT="${MAX_CONCURRENT:-4}"

# 🎨 科技感红绿徽章定义 (Shields.io 风格)
readonly BADGE_SUCCESS="![Success](https://img.shields.io/badge/Status-Success-success?style=flat-square)"
readonly BADGE_FAILED="![Failed](https://img.shields.io/badge/Status-Failed-critical?style=flat-square)"

########################################
# Check
########################################

if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "::error::Config file '$CONFIG_FILE' not found."
    exit 1
fi

########################################
# Read Images
########################################

mapfile -t IMAGES < <(
    grep -Ev '^[[:space:]]*(#|$)' "$CONFIG_FILE" \
    | awk '!seen[$0]++'
)

readonly TOTAL=${#IMAGES[@]}

if (( TOTAL == 0 )); then
    echo "::notice::Nothing to sync."
    exit 0
fi

########################################
# Banner
########################################

START_TIME=$(date +%s)

echo "========================================"
echo " Docker Image Sync"
echo "========================================"
echo " Images      : $TOTAL"
echo " Platform    : $PLATFORM"
echo " Concurrency : $MAX_CONCURRENT"
echo "========================================"
echo

########################################
# GitHub Summary Init
########################################

SUMMARY_FILE="${GITHUB_STEP_SUMMARY:-}"

if [[ -n "$SUMMARY_FILE" ]]; then
{
    echo "# 🚀 Docker Image Sync Report"
    echo
    echo "| Image | Status | Duration |"
    echo "| :--- | :---: | ---: |"
} >> "$SUMMARY_FILE"
fi

########################################
# Temp Directory Setup
########################################

TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

failed_count=0

########################################
# Parallel Sync
########################################

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
        sum_file="${TMP_DIR}/${task_num}.sum"  # 🌟 独立的摘要缓存，杜绝并发冲突

        begin=$(date +%s)

        if crane copy \
            --platform "$PLATFORM" \
            "$src" \
            "$dst" \
            >"$log_file" 2>&1
        then
            elapsed=$(( $(date +%s) - begin ))

            printf "[%02d/%02d] %-35s ✅ %2ss\n" \
                "$task_num" "$TOTAL" "$image" "$elapsed"

            # 🌟 写入临时摘要文件
            echo "| \`$src\` | $BADGE_SUCCESS | ${elapsed}s |" > "$sum_file"
            exit 0
        fi

        elapsed=$(( $(date +%s) - begin ))

        printf "[%02d/%02d] %-35s ❌ %2ss\n" \
            "$task_num" "$TOTAL" "$image" "$elapsed"

        echo "::group::Failed - ${src}"
        cat "$log_file"
        echo "::endgroup::"

        echo "::error::Failed to sync ${src}"

        # 🌟 写入临时摘要文件
        echo "| \`$src\` | $BADGE_FAILED | ${elapsed}s |" > "$sum_file"
        exit 1

    ) &

    # 控流节流阀
    while [[ $(jobs -rp | wc -l) -ge "$MAX_CONCURRENT" ]]; do
        wait -n || failed_count=$((failed_count + 1))
    done

done

########################################
# Wait Remaining Jobs
########################################

while [[ $(jobs -rp | wc -l) -gt 0 ]]; do
    wait -n || failed_count=$((failed_count + 1))
done

########################################
# Orderly Write Summary Table
########################################

# 🌟 在主进程中按任务序号顺序、安全地将表格行追加到 Summary 文件
if [[ -n "$SUMMARY_FILE" ]]; then
    for ((i=1; i<=TOTAL; i++)); do
        if [[ -f "${TMP_DIR}/${i}.sum" ]]; then
            cat "${TMP_DIR}/${i}.sum" >> "$SUMMARY_FILE"
        fi
    done
fi

########################################
# Summary Output
########################################

SUCCESS=$((TOTAL - failed_count))
ELAPSED=$(( $(date +%s) - START_TIME ))

echo
echo "========================================"
echo " Summary"
echo "----------------------------------------"
printf " %-10s : %d\n" "Images" "$TOTAL"
printf " %-10s : %d\n" "Success" "$SUCCESS"
printf " %-10s : %d\n" "Failed" "$failed_count"
printf " %-10s : %ss\n" "Elapsed" "$ELAPSED"
echo "========================================"

if [[ -n "$SUMMARY_FILE" ]]; then
    # 决定最终大面板的徽章状态
    final_badge="$BADGE_SUCCESS"
    (( failed_count > 0 )) && final_badge="$BADGE_FAILED"
{
    echo
    echo "---"
    echo
    echo "### 📊 Metrics Summary"
    echo "- **Total Images:** $TOTAL"
    echo "- **Success:** $SUCCESS"
    echo "- **Failed:** $failed_count"
    echo "- **Execution Time:** ${ELAPSED}s"
    echo "- **Conclusion:** $final_badge"
} >> "$SUMMARY_FILE"
fi

########################################
# Exit Status
########################################

if (( failed_count > 0 )); then
    echo "::error::$failed_count image(s) failed."
    exit 1
fi

echo "::notice::All images synced successfully."
echo "🎉 All images synced successfully."
