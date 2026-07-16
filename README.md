![Sync Status](https://img.shields.io/github/actions/workflow/status/yangtudou/docker-compose/registry-sync_demo.yml?style=flat-square&logo=github-actions&logoColor=white&label=Images%20Sync)
![Last Commit](https://img.shields.io/github/last-commit/yangtudou/docker-compose?style=flat-square&label=Last%20Update&color=green)

# 记录 docker 玩法

> [!TIP]
> 镜像通过 github action 同步到阿里云私有仓库

<!-- IMAGES_TABLE_START -->

| # | 🐳 镜像名称 (Container) | ✦ 标签 (Tag) |
| :-: | :--- | :-: |
| **01** | `cloudflare/cloudflared` | `latest` |
| **02** | `gdy666/lucky` | `v2` |
| **03** | `ghcr.io/dani-garcia/vaultwarden` | `latest` |
| **04** | `ghcr.io/finb/bark-server` | `latest` |
| **05** | `ghcr.io/hacdias/webdav` | `latest` |
| **06** | `ghcr.io/sagernet/sing-box` | `latest` |
| **07** | `ghcr.io/sagernet/sing-box` | `latest-testing` |
| **08** | `ghcr.io/shadowsocks/ssserver-rust` | `latest` |
| **09** | `ghcr.io/tailscale/tailscale` | `stable` |
| **10** | `ghcr.io/usememos/memos` | `0.29.1` |
| **11** | `joxit/docker-registry-ui` | `main` |
| **12** | `metacubex/mihomo` | `latest` |
| **13** | `registry` | `3` |

<!-- IMAGES_TABLE_END -->

## 一把梭

### 创建网络

```
docker network create homelab-net
```
