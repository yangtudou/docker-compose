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

[[ -f "$CONFIG_FILE" ]] || {
    echo "❌ Config file '$CONFIG_FILE' not found."
    exit 1
}

########################################
# Read images
########################################

mapfile -t IMAGES < <(
    grep -Ev '^[[:space:]]*(#|$)' "$CONFIG_FILE" \
    | awk '!seen[$0]++'
)

readonly TOTAL=${#IMAGES[@]}

(( TOTAL > 0 )) || {
    echo "Nothing to sync."
    exit 0
}

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
# Temp
########################################

TMPDIR=$(mktemp -d)

cleanup() {
    rm -rf "$TMPDIR"
}
trap cleanup EXIT

########################################
# Worker
########################################

sync_image() {

    local index="$1"
    local src="$2"

    local image
    local name
    local tag
    local dst

    image="${src##*/}"
    name="${image%%:*}"
    tag="${image#*:}"

    [[ "$image" == "$tag" ]] && tag="latest"

    dst="${REGISTRY}/${NAMESPACE}/${name}:${tag}"

    local logfile="${TMPDIR}/${index}.log"

    local start end elapsed

    start=$(date +%s)

    if crane copy \
        --platform "$PLATFORM" \
        "$src" \
        "$dst" \
        >"$logfile" 2>&1
    then

        end=$(date +%s)
        elapsed=$((end-start))

        printf "[%02d/%02d] %-35s ✅ %2ss\n" \
            "$index" "$TOTAL" "$image" "$elapsed"

        return 0
    fi

    end=$(date +%s)
    elapsed=$((end-start))

    printf "[%02d/%02d] %-35s ❌ %2ss\n" \
        "$index" "$TOTAL" "$image" "$elapsed"

    echo "::group::Failed - ${src}"
    cat "$logfile"
    echo "::endgroup::"

    return 1
}

########################################
# Parallel
########################################

running=0
failed=0

for ((i=0;i<TOTAL;i++)); do

    sync_image "$((i+1))" "${IMAGES[$i]}" &

    ((running+=1))

    if (( running >= MAX_CONCURRENT )); then

        if ! wait -n; then
            ((failed+=1))
        fi

        ((running-=1))
    fi

done

while (( running > 0 )); do

    if ! wait -n; then
        ((failed+=1))
    fi

    ((running-=1))

done

########################################
# Summary
########################################

END_TIME=$(date +%s)

ELAPSED=$((END_TIME-START_TIME))

SUCCESS=$((TOTAL-failed))

echo
echo "========================================"
echo " Summary"
echo "----------------------------------------"
printf " %-10s : %d\n" "Images" "$TOTAL"
printf " %-10s : %d\n" "Success" "$SUCCESS"
printf " %-10s : %d\n" "Failed" "$failed"
printf " %-10s : %ss\n" "Elapsed" "$ELAPSED"
echo "========================================"

(( failed == 0 )) && {
    echo "🎉 All images synced successfully."
    exit 0
}

echo "❌ ${failed} image(s) failed."
exit 1