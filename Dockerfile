FROM debian:stable-slim

RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates && rm -rf /var/lib/apt/lists/*

ARG OPENGREP_VERSION=v1.16.4

RUN curl -fsSL -o /bin/opengrep https://github.com/opengrep/opengrep/releases/download/${OPENGREP_VERSION}/opengrep_manylinux_x86 && \
    chmod +x /bin/opengrep

COPY entrypoint.sh /bin/

RUN chmod +x /bin/entrypoint.sh

WORKDIR /woodpecker

ENTRYPOINT ["/bin/entrypoint.sh"]
