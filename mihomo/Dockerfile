FROM alpine:latest AS builder

RUN apk add --no-cache curl jq gzip

RUN mkdir /mihomo && \
    RELEASE=$(curl -s https://api.github.com/repos/MetaCubeX/mihomo/releases/latest) && \
    TAG=$(echo "$RELEASE" | jq -r '.tag_name') && \
    URL=$(echo "$RELEASE" | jq -r --arg tag "$TAG" \
        '.assets[] | select(.name == ("mihomo-linux-amd64-v1-" + $tag + ".gz")) | .browser_download_url') && \
    echo "Download: $URL" && \
    curl -L "$URL" | gzip -d > /mihomo/mihomo && \
    chmod +x /mihomo/mihomo


FROM alpine:latest

LABEL org.opencontainers.image.source="https://github.com/MetaCubeX/mihomo"

RUN apk add --no-cache ca-certificates tzdata iptables

VOLUME ["/root/.config/mihomo/"]

COPY --from=builder /mihomo/mihomo /mihomo

ENTRYPOINT ["/mihomo"]
