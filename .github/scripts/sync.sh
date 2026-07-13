#!/usr/bin/env bash

set -Eeuo pipefail

########################################
# Config
########################################

readonly PLATFORM="${PLATFORM:-linux/amd64}"
readonly REGISTRY="${ALIYUN_REGISTRY_DOMAIN}"
readonly NAMESPACE="${ALIYUN_REGISTRY_SPACE_NAME}"
readonly CONFIG_FILE="images.txt"
readonly MAX_CONCURRENT="${MAX_CONCURRENT:-4}"

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
# GitHub Summary
########################################

SUMMARY_FILE="${GITHUB_STEP_SUMMARY:-}"

if [[ -n "$SUMMARY_FILE" ]]; then
{
echo "# Docker Image Sync"
echo
echo "| Image | Status | Time |"
echo "|------|:------:|------:|"
} >> "$SUMMARY_FILE"
fi

########################################
# Temp
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

            if [[ -n "$SUMMARY_FILE" ]]; then
                echo "| \`$src\` | ✅ | ${elapsed}s |" >> "$SUMMARY_FILE"
            fi

            exit 0
        fi

        elapsed=$(( $(date +%s) - begin ))

        printf "[%02d/%02d] %-35s ❌ %2ss\n" \
            "$task_num" "$TOTAL" "$image" "$elapsed"

        echo "::group::Failed - ${src}"
        cat "$log_file"
        echo "::endgroup::"

        echo "::error::Failed to sync ${src}"

        if [[ -n "$SUMMARY_FILE" ]]; then
            echo "| \`$src\` | ❌ | ${elapsed}s |" >> "$SUMMARY_FILE"
        fi

        exit 1

    ) &

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
# Summary
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
{
echo
echo "---"
echo
echo "**Images:** $TOTAL  "
echo "**Success:** $SUCCESS  "
echo "**Failed:** $failed_count  "
echo "**Elapsed:** ${ELAPSED}s"
} >> "$SUMMARY_FILE"
fi

########################################
# Exit
########################################

if (( failed_count > 0 )); then
    echo "::error::$failed_count image(s) failed."
    exit 1
fi

echo "::notice::All images synced successfully."
echo "🎉 All images synced successfully."