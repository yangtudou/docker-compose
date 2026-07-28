[![镜像同步](https://github.com/yangtudou/docker-compose/actions/workflows/registry-sync.yml/badge.svg?event=workflow_dispatch)](https://github.com/yangtudou/docker-compose/actions/workflows/registry-sync.yml)

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


```mermaid
flowchart LR

    subgraph EXT["🌍 外部镜像源"]
        DH["🐳 Docker Hub<br/>docker.io"]
        GH["📦 GitHub Container Registry<br/>ghcr.io"]
    end

    subgraph SYNC["⚙️ registry-sync"]
        RS["registry-sync<br/><br/>计划生成<br/>并发执行<br/>缓存检测<br/>镜像复制"]
    end

    subgraph CACHE1["🟦 一级缓存"]
        ARC["☁️ AliCR<br/>阿里云容器镜像服务<br/><br/>公网镜像缓存"]
    end

    subgraph CACHE2["🟩 二级缓存"]
        LOCAL["🏠 Local Registry<br/>registry.local<br/><br/>内网运行缓存"]
    end


    DH -->|拉取镜像| RS
    GH -->|拉取镜像| RS

    RS -->|推送镜像<br/>Digest 校验| ARC

    ARC -->|内部镜像同步| LOCAL


    style EXT fill:#f8f9fa,stroke:#666,stroke-width:1px
    style SYNC fill:#fff3cd,stroke:#d39e00,stroke-width:2px
    style CACHE1 fill:#e8f4ff,stroke:#3399ff,stroke-width:2px
    style CACHE2 fill:#e8ffe8,stroke:#33aa33,stroke-width:2px

    style DH fill:#ffffff,stroke:#2496ed
    style GH fill:#ffffff,stroke:#333
    style RS fill:#ffffff,stroke:#d39e00
    style ARC fill:#ffffff,stroke:#3399ff
    style LOCAL fill:#ffffff,stroke:#33aa33
```
