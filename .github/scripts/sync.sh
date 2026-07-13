#!/usr/bin/env bash

# 保持你优秀的严谨设置
set -Eeuo pipefail

readonly PLATFORM="${PLATFORM:-linux/amd64}"
readonly REGISTRY="${ALIYUN_REGISTRY_DOMAIN}"
readonly NAMESPACE="${ALIYUN_REGISTRY_SPACE_NAME}"
readonly CONFIG_FILE="images.yaml"

# 🎯 核心控制：控制同时并发的最大镜像数（建议 4 到 6 个，既快又安全）
readonly MAX_CONCURRENT=4

if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "❌ Error: Config file '$CONFIG_FILE' not found."
    exit 1
fi

echo "========================================"
echo " Docker Image Controlled Parallel Sync"
echo "========================================"

# 用 yq 将 YAML 里的镜像列表直接读入 Bash 数组
mapfile -t IMAGES < <(yq eval '.images[]' "$CONFIG_FILE")
readonly TOTAL=${#IMAGES[@]}

echo "📦 Found $TOTAL image(s) to sync. Concurrency limit: $MAX_CONCURRENT"
echo "----------------------------------------"

failed_count=0

# 循环遍历镜像
for ((i=0; i<TOTAL; i++)); do
    src="${IMAGES[i]}"
    task_num=$((i + 1))

    # 1. 扔进后台并发执行
    (
        set -Eeuo pipefail

        image="${src##*/}"
        name="${image%%:*}"
        tag="${image#*:}"
        [[ "$image" == "$tag" ]] && tag="latest"

        dst="${REGISTRY}/${NAMESPACE}/${name}:${tag}"

        echo "🚀 [$task_num/$TOTAL] Launched: $name:$tag"

        if crane copy --platform "$PLATFORM" "$src" "$dst" >/dev/null 2>&1; then
            echo "✅ [$task_num/$TOTAL] Success: $name:$tag"
            exit 0
        else
            echo "❌ [$task_num/$TOTAL] Failed: $name:$tag"
            exit 1
        fi
    ) &

    # 2. 🎯 节流阀：检查当前后台正在跑的任务数
    # 如果达到了最大并发限制，就阻塞等待“任意一个”先跑完，释放出坑位后才允许进下一个循环
    while [[ $(jobs -rp | wc -l) -ge "$MAX_CONCURRENT" ]]; do
        # wait -n 会等待下一个子进程结束，并返回它的 exit code
        # 如果子进程失败了（返回非0），就给失败计数器加 1
        wait -n || failed_count=$((failed_count + 1))
    done
done

# 3. 🏁 收尾：等最后一波留在后台的残余任务全部跑完
while [[ $(jobs -rp | wc -l) -gt 0 ]]; do
    wait -n || failed_count=$((failed_count + 1))
done

echo "----------------------------------------"
echo " Summary"
echo "----------------------------------------"
if (( failed_count > 0 )); then
    echo "❌ ${failed_count} image(s) failed to sync. Please check logs above."
    echo "========================================"
    exit 1
fi

echo "🎉 All images synced successfully within concurrency limits!"
echo "========================================"