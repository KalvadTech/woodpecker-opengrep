FROM alpine:3.23

RUN apk update && apk upgrade && apk add --no-cache curl ca-certificates git

ARG OPENGREP_VERSION=v2.0.0

# Since 2.0.0, Opengrep ships a single static binary per architecture
# (opengrep_linux_x86 / opengrep_linux_aarch64) instead of the old
# opengrep-core_*.tar.gz archives.
ARG TARGETARCH=amd64
RUN case "${TARGETARCH}" in \
      amd64) arch=x86 ;; \
      arm64) arch=aarch64 ;; \
      *) echo "unsupported architecture: ${TARGETARCH}" >&2; exit 1 ;; \
    esac && \
    curl -fsSL -o /bin/opengrep \
      "https://github.com/opengrep/opengrep/releases/download/${OPENGREP_VERSION}/opengrep_linux_${arch}" && \
    chmod +x /bin/opengrep

COPY entrypoint.sh /bin/

RUN chmod +x /bin/entrypoint.sh

WORKDIR /woodpecker

ENTRYPOINT ["/bin/entrypoint.sh"]
