![Sync Status](https://img.shields.io/github/actions/workflow/status/yangtudou/docker-compose/registry-sync_demo.yml?style=flat-square&logo=github-actions&logoColor=white&label=Images%20Sync)
![Last Commit](https://img.shields.io/github/last-commit/yangtudou/docker-compose?style=flat-square&label=Last%20Update&color=green)

# 记录 docker 玩法

> [!TIP]
> 镜像通过 github action 同步到阿里云私有仓库

<!-- IMAGES_TABLE_START -->

| 镜像名称 | 标签 |
| :--- | :-: |
| cloudflare/cloudflared | ![latest](https://img.shields.io/badge/-latest-4470c4?style=flat-square) |
| gdy666/lucky | ![v2](https://img.shields.io/badge/-v2-3da95e?style=flat-square) |
| ghcr.io/dani-garcia/vaultwarden | ![latest](https://img.shields.io/badge/-latest-4470c4?style=flat-square) |
| ghcr.io/finb/bark-server | ![latest](https://img.shields.io/badge/-latest-4470c4?style=flat-square) |
| ghcr.io/hacdias/webdav | ![latest](https://img.shields.io/badge/-latest-4470c4?style=flat-square) |
| ghcr.io/sagernet/sing-box | ![latest](https://img.shields.io/badge/-latest-4470c4?style=flat-square) |
| ghcr.io/sagernet/sing-box | ![latest-testing](https://img.shields.io/badge/-latest--testing-8a919f?style=flat-square) |
| ghcr.io/shadowsocks/ssserver-rust | ![latest](https://img.shields.io/badge/-latest-4470c4?style=flat-square) |
| ghcr.io/tailscale/tailscale | ![stable](https://img.shields.io/badge/-stable-8a919f?style=flat-square) |
| ghcr.io/usememos/memos | ![0.29.1](https://img.shields.io/badge/-0.29.1-3da95e?style=flat-square) |
| joxit/docker-registry-ui | ![main](https://img.shields.io/badge/-main-8a919f?style=flat-square) |
| metacubex/mihomo | ![latest](https://img.shields.io/badge/-latest-4470c4?style=flat-square) |
| registry | ![3](https://img.shields.io/badge/-3-3da95e?style=flat-square) |

<!-- IMAGES_TABLE_END -->

## 一把梭

### 创建网络

```
docker network create homelab-net
```
