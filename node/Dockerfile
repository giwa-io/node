FROM rust:1.94-bookworm AS just-builder

WORKDIR /app

RUN cargo install just
RUN cp $(which just) .
# --------------------------------------------------------
FROM golang:1.26.4-bookworm AS builder

ARG OPNODE_VERSION

RUN apt-get update && apt-get install -y jq zip
RUN go install github.com/mikefarah/yq/v4@latest && \
    cp "$(go env GOPATH)/bin/yq" /usr/local/bin/yq

RUN git clone https://github.com/ethereum-optimism/optimism.git --branch op-node/$OPNODE_VERSION --single-branch /optimism

WORKDIR /optimism

COPY --from=just-builder /app/just /usr/local/bin/

RUN just build-superchain-go && just op-node
# -------------------------------------------------------------------------
FROM ubuntu:noble

RUN apt-get update && \
    apt-get install -y ca-certificates && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=builder /optimism/op-node/bin/op-node /usr/local/bin/
COPY genesis/consensus/ /app/
COPY --chmod=755 node/entrypoint.sh /app/

ENTRYPOINT ["/app/entrypoint.sh"]
