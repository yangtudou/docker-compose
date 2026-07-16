![Sync Status](https://img.shields.io/github/actions/workflow/status/yangtudou/docker-compose/registry-sync_demo.yml?style=flat-square&logo=github-actions&logoColor=white&label=Images%20Sync)
![Last Commit](https://img.shields.io/github/last-commit/yangtudou/docker-compose?style=flat-square&label=Last%20Update&color=green)

# 记录 docker 玩法

> [!TIP]
> 镜像通过 github action 同步到阿里云私有仓库

<!-- IMAGES_TABLE_START -->

<table>
  <thead>
    <tr>
      <th width="10%" align="center">#</th>
      <th width="65%" align="left">Container Image</th>
      <th width="25%" align="center">Tag</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td align="center"><code>01</code></td>
      <td><sub>cloudflare</sub> / <strong>cloudflared</strong></td>
      <td align="center"><code>latest</code></td>
    </tr>
    <tr>
      <td align="center"><code>02</code></td>
      <td><sub>gdy666</sub> / <strong>lucky</strong></td>
      <td align="center"><code>v2</code></td>
    </tr>
    <tr>
      <td align="center"><code>03</code></td>
      <td><sub>ghcr.io</sub> / <strong>dani-garcia/vaultwarden</strong></td>
      <td align="center"><code>latest</code></td>
    </tr>
    <tr>
      <td align="center"><code>04</code></td>
      <td><sub>ghcr.io</sub> / <strong>finb/bark-server</strong></td>
      <td align="center"><code>latest</code></td>
    </tr>
    <tr>
      <td align="center"><code>05</code></td>
      <td><sub>ghcr.io</sub> / <strong>hacdias/webdav</strong></td>
      <td align="center"><code>latest</code></td>
    </tr>
    <tr>
      <td align="center"><code>06</code></td>
      <td><sub>ghcr.io</sub> / <strong>sagernet/sing-box</strong></td>
      <td align="center"><code>latest</code></td>
    </tr>
    <tr>
      <td align="center"><code>07</code></td>
      <td><sub>ghcr.io</sub> / <strong>sagernet/sing-box</strong></td>
      <td align="center"><code>latest-testing</code></td>
    </tr>
    <tr>
      <td align="center"><code>08</code></td>
      <td><sub>ghcr.io</sub> / <strong>shadowsocks/ssserver-rust</strong></td>
      <td align="center"><code>latest</code></td>
    </tr>
    <tr>
      <td align="center"><code>09</code></td>
      <td><sub>ghcr.io</sub> / <strong>tailscale/tailscale</strong></td>
      <td align="center"><code>stable</code></td>
    </tr>
    <tr>
      <td align="center"><code>10</code></td>
      <td><sub>ghcr.io</sub> / <strong>usememos/memos</strong></td>
      <td align="center"><code>0.29.1</code></td>
    </tr>
    <tr>
      <td align="center"><code>11</code></td>
      <td><sub>joxit</sub> / <strong>docker-registry-ui</strong></td>
      <td align="center"><code>main</code></td>
    </tr>
    <tr>
      <td align="center"><code>12</code></td>
      <td><sub>metacubex</sub> / <strong>mihomo</strong></td>
      <td align="center"><code>latest</code></td>
    </tr>
    <tr>
      <td align="center"><code>13</code></td>
      <td><strong>registry</strong></td>
      <td align="center"><code>3</code></td>
    </tr>
  </tbody>
</table>

<!-- IMAGES_TABLE_END -->

## 一把梭

### 创建网络

```
docker network create homelab-net
```
