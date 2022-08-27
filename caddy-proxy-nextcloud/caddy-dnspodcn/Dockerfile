ARG CADDY_VERSION=2.5.0
FROM caddy:${CADDY_VERSION}-builder AS builder

RUN xcaddy build \
    --with clevergo.tech/caddy-dnspodcn

FROM caddy:${CADDY_VERSION}-alpine

COPY --from=builder /usr/bin/caddy /usr/bin/caddy