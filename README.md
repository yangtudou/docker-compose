![Sync Status](https://img.shields.io/github/actions/workflow/status/yangtudou/docker-compose/registry-sync_demo.yml?style=flat-square&logo=github-actions&logoColor=white&label=Images%20Sync)
![Last Commit](https://img.shields.io/github/last-commit/yangtudou/docker-compose?style=flat-square&label=Last%20Update&color=green)

# 记录 docker 玩法

> [!TIP]
> 镜像通过 github action 同步到阿里云私有仓库

<!-- IMAGES_TABLE_START -->

| # | 🐳 镜像名称 (Container) | ✦ 标签 (Tag) |
| :-: | :--- | :-: |
| **01** | cloudflare/cloudflared | ![latest](https://img.shields.io/badge/tag-latest-blue?style=flat-square) |
| **02** | gdy666/lucky | ![v2](https://img.shields.io/badge/tag-v2-brightgreen?style=flat-square) |
| **03** | ghcr.io/dani-garcia/vaultwarden | ![latest](https://img.shields.io/badge/tag-latest-blue?style=flat-square) |
| **04** | ghcr.io/finb/bark-server | ![latest](https://img.shields.io/badge/tag-latest-blue?style=flat-square) |
| **05** | ghcr.io/hacdias/webdav | ![latest](https://img.shields.io/badge/tag-latest-blue?style=flat-square) |
| **06** | ghcr.io/sagernet/sing-box | ![latest](https://img.shields.io/badge/tag-latest-blue?style=flat-square) |
| **07** | ghcr.io/sagernet/sing-box | ![latest-testing](https://img.shields.io/badge/tag-latest--testing-orange?style=flat-square) |
| **08** | ghcr.io/shadowsocks/ssserver-rust | ![latest](https://img.shields.io/badge/tag-latest-blue?style=flat-square) |
| **09** | ghcr.io/tailscale/tailscale | ![stable](https://img.shields.io/badge/tag-stable-orange?style=flat-square) |
| **10** | ghcr.io/usememos/memos | ![0.29.1](https://img.shields.io/badge/tag-0.29.1-brightgreen?style=flat-square) |
| **11** | joxit/docker-registry-ui | ![main](https://img.shields.io/badge/tag-main-orange?style=flat-square) |
| **12** | metacubex/mihomo | ![latest](https://img.shields.io/badge/tag-latest-blue?style=flat-square) |
| **13** | registry | ![3](https://img.shields.io/badge/tag-3-brightgreen?style=flat-square) |

<!-- IMAGES_TABLE_END -->

## 一把梭

### 创建网络

```
docker network create homelab-net
```
