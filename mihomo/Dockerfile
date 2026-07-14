FROM alpine:latest AS builder

RUN apk add --no-cache curl jq gzip

RUN mkdir /mihomo && \
    curl -s https://api.github.com/repos/MetaCubeX/mihomo/releases/latest \
    | jq -r '.assets[] | select(.name | contains("linux-amd64") and endswith(".gz")) | .browser_download_url' \
    | xargs curl -L \
    | gzip -d > /mihomo/mihomo && \
    chmod +x /mihomo/mihomo


FROM alpine:latest

LABEL org.opencontainers.image.source="https://github.com/MetaCubeX/mihomo"

RUN apk add --no-cache ca-certificates tzdata iptables

VOLUME ["/root/.config/mihomo/"]

COPY --from=builder /mihomo/mihomo /mihomo

ENTRYPOINT ["/mihomo"]
