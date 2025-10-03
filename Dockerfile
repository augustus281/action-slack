# Use modern Go 1.24 with Alpine
FROM golang:1.24-alpine3.20@sha256:d70ebc7c3a7b8c67e5877f8b3a9a6f50b5f3e06a9e7b63d33b83c8e9b0bfe3a7 AS builder

LABEL "com.github.actions.icon"="bell"
LABEL "com.github.actions.color"="green"
LABEL "com.github.actions.name"="Slack Notify"
LABEL "com.github.actions.description"="This action will send notification to Slack"

WORKDIR /go/src/github.com/drilonrecica/action-slack-notify
COPY main.go .

ENV CGO_ENABLED=0
ENV GOOS=linux

RUN go mod init github.com/drilonrecica/action-slack-notify || true
RUN go mod tidy
RUN go build -a -installsuffix cgo -ldflags '-w -extldflags "-static"' -o /go/bin/slack-notify .

# Alpine runtime stage
FROM alpine:3.20

COPY --from=builder /go/bin/slack-notify /usr/bin/slack-notify

ENV VAULT_VERSION=1.0.2

RUN apk update \
  && apk upgrade \
  && apk add --no-cache \
     bash \
     jq \
     ca-certificates \
     python3 \
     py3-pip \
     unzip \
     wget \
  && pip3 install shyaml \
  && rm -rf /var/cache/apk/*

# Setup Vault
RUN wget https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip && \
    unzip vault_${VAULT_VERSION}_linux_amd64.zip && \
    rm vault_${VAULT_VERSION}_linux_amd64.zip && \
    mv vault /usr/local/bin/vault

# fix missing dependency (only needed if musl/glibc issue occurs)
RUN mkdir -p /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2 || true

COPY *.sh /

RUN chmod +x /*.sh

ENTRYPOINT ["/entrypoint.sh"]