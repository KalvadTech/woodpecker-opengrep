FROM alpine:3.23

RUN apk update && apk upgrade && apk add --no-cache curl ca-certificates git

ARG OPENGREP_VERSION=v1.16.4

RUN curl -fsSL -o /opengrep.tar.gz \
    https://github.com/opengrep/opengrep/releases/download/${OPENGREP_VERSION}/opengrep-core_linux_x86.tar.gz && \
    tar -xzf /opengrep.tar.gz -C /bin opengrep-core && \
    mv /bin/opengrep-core /bin/opengrep && \
    chmod +x /bin/opengrep && \
    rm /opengrep.tar.gz

COPY entrypoint.sh /bin/

RUN chmod +x /bin/entrypoint.sh

WORKDIR /woodpecker

ENTRYPOINT ["/bin/entrypoint.sh"]
