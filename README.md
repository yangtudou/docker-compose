[![registry-sync demo](https://github.com/yangtudou/docker-compose/actions/workflows/registry-sync_demo.yml/badge.svg?event=workflow_dispatch)](https://github.com/yangtudou/docker-compose/actions/workflows/registry-sync_demo.yml)
![Last Run](https://img.shields.io/badge/dynamic/json?url=https://api.github.com/repos/yangtudou/docker-compose/actions/workflows/312354603/runs%3Fstatus%3Dcompleted%26per_page%3D1&query=%24.workflow_runs%5B0%5D.updated_at&label=registry-sync%20last%20run)


# 记录 docker 玩法

> [!TIP]
> 镜像通过 github action 同步到阿里云私有仓库

<!-- IMAGES_TABLE_START -->

<!-- IMAGES_TABLE_END -->

## 一把梭

### 创建网络

```
docker network create homelab-net
```
