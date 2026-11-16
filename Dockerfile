FROM alpine:3.24

RUN apk update && apk upgrade && apk add --no-cache curl ca-certificates git

ARG OPENGREP_VERSION=v2.0.0

# Since 2.0.0, Opengrep ships a single static binary per architecture
# (opengrep_linux_x86 / opengrep_linux_aarch64) instead of the old
# opengrep-core_*.tar.gz archives.
ARG TARGETARCH
RUN case "${TARGETARCH}" in \
      amd64) arch=x86;     elf=3e00 ;; \
      arm64) arch=aarch64; elf=b700 ;; \
      *) echo "error: unsupported TARGETARCH '${TARGETARCH}' (expected amd64 or arm64; use buildx/buildkit)" >&2; exit 1 ;; \
    esac && \
    base="https://github.com/opengrep/opengrep/releases/download/${OPENGREP_VERSION}" && \
    curl -fsSL -o /tmp/opengrep      "${base}/opengrep_linux_${arch}" && \
    curl -fsSL -o /tmp/opengrep.cert "${base}/opengrep_linux_${arch}.cert" && \
    curl -fsSL -o /tmp/opengrep.sig  "${base}/opengrep_linux_${arch}.sig" && \
    [ "$(od -An -t x1 -j 18 -N 2 /tmp/opengrep | tr -d ' \n')" = "${elf}" ] || { \
      echo "error: downloaded opengrep_linux_${arch} is not a ${TARGETARCH} binary" >&2; exit 1; } && \
    apk add --no-cache cosign && \
    cosign verify-blob \
      --certificate /tmp/opengrep.cert \
      --signature /tmp/opengrep.sig \
      --certificate-identity-regexp "https://github.com/opengrep/opengrep/.+" \
      --certificate-oidc-issuer "https://token.actions.githubusercontent.com" \
      /tmp/opengrep && \
    apk del cosign && \
    mv /tmp/opengrep /bin/opengrep && \
    chmod +x /bin/opengrep && \
    rm -f /tmp/opengrep.cert /tmp/opengrep.sig

COPY entrypoint.sh /bin/

RUN chmod +x /bin/entrypoint.sh

WORKDIR /woodpecker

ENTRYPOINT ["/bin/entrypoint.sh"]
