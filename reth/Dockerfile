FROM rust:1.88-bookworm AS builder

RUN apt update && apt install -y libclang-dev pkg-config build-essential

RUN git clone https://github.com/base/node-reth.git /node-reth

WORKDIR /node-reth

ARG BASE_NODE_RETH_VERSION="INVALID"

RUN git checkout $BASE_NODE_RETH_VERSION

RUN cargo build --profile maxperf --features jemalloc --bin base-reth-node
# -------------------------------------------------------------------------
FROM ubuntu:noble

WORKDIR /app

COPY --from=builder /node-reth/target/maxperf/base-reth-node /usr/local/bin/
COPY genesis/execution/ /app/
COPY --chmod=755 reth/entrypoint.sh /app/

ENTRYPOINT ["/app/entrypoint.sh"]
