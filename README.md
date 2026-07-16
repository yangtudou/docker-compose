![Sync Status](https://img.shields.io/github/actions/workflow/status/yangtudou/docker-compose/registry-sync_demo.yml?style=flat-square&logo=github-actions&logoColor=white&label=Images%20Sync)
![Last Commit](https://img.shields.io/github/last-commit/yangtudou/docker-compose?style=flat-square&label=Last%20Update&color=green)

# 记录 docker 玩法

> [!TIP]
> 镜像通过 github action 同步到阿里云私有仓库

<!-- IMAGES_TABLE_START -->

- `cloudflare/cloudflared:latest`
- `gdy666/lucky:v2`
- `metacubex/mihomo:latest`
- `joxit/docker-registry-ui:main`
- `registry:3`
- `ghcr.io/tailscale/tailscale:stable`
- `ghcr.io/sagernet/sing-box:latest`
- `ghcr.io/sagernet/sing-box:latest-testing`
- `ghcr.io/hacdias/webdav:latest`
- `ghcr.io/shadowsocks/ssserver-rust:latest`
- `ghcr.io/dani-garcia/vaultwarden:latest`
- `ghcr.io/finb/bark-server:latest`
- `ghcr.io/usememos/memos:0.29.1`
- `# ghcr.io/caddy-dns/cloudflare:latest`
- `# ghcr.io/jellyfin/jellyfin:latest`
- `# ghcr.io/userdocs/iperf3-static:latest`

<!-- IMAGES_TABLE_END -->

## 一把梭

### 创建网络

```
docker network create homelab-net
```
