![Sync Status](https://img.shields.io/github/actions/workflow/status/yangtudou/docker-compose/registry-sync_demo.yml?style=flat-square&logo=github-actions&logoColor=white&label=Images%20Sync)
![Last Commit](https://img.shields.io/github/last-commit/yangtudou/docker-compose?style=flat-square&label=Last%20Update&color=green)

# 记录 docker 玩法

> [!TIP]
> 镜像通过 github action 同步到阿里云私有仓库

<!-- IMAGES_TABLE_START -->

| 序号 | 📦 镜像名称 (Image) | 🏷️ 版本 (Tag) | ⚡ 状态 (Status) |
| :---: | :--- | :---: | :---: |
| 1 | `cloudflare/cloudflared` | `latest` | 🟢 已同步 |
| 2 | `gdy666/lucky` | `v2` | 🟢 已同步 |
| 3 | `metacubex/mihomo` | `latest` | 🟢 已同步 |
| 4 | `joxit/docker-registry-ui` | `main` | 🟢 已同步 |
| 5 | `registry` | `3` | 🟢 已同步 |
| 6 | `ghcr.io/tailscale/tailscale` | `stable` | 🟢 已同步 |
| 7 | `ghcr.io/sagernet/sing-box` | `latest` | 🟢 已同步 |
| 8 | `ghcr.io/sagernet/sing-box` | `latest-testing` | 🟢 已同步 |
| 9 | `ghcr.io/hacdias/webdav` | `latest` | 🟢 已同步 |
| 10 | `ghcr.io/shadowsocks/ssserver-rust` | `latest` | 🟢 已同步 |
| 11 | `ghcr.io/dani-garcia/vaultwarden` | `latest` | 🟢 已同步 |
| 12 | `ghcr.io/finb/bark-server` | `latest` | 🟢 已同步 |
| 13 | `ghcr.io/usememos/memos` | `0.29.1` | 🟢 已同步 |

<!-- IMAGES_TABLE_END -->

## 一把梭

### 创建网络

```
docker network create homelab-net
```
