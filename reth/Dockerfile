FROM rust:1.88-bookworm AS builder

RUN apt update && apt install -y libclang-dev pkg-config build-essential

RUN git clone https://github.com/paradigmxyz/reth.git /reth

WORKDIR /reth

ARG BASE_NODE_RETH_VERSION="INVALID"

RUN git checkout $BASE_NODE_RETH_VERSION

RUN make maxperf-op
# -------------------------------------------------------------------------
FROM ubuntu:noble

WORKDIR /app

COPY --from=builder /reth/target/maxperf/op-reth /usr/local/bin/
COPY genesis/execution/ /app/
COPY --chmod=755 reth/entrypoint.sh /app/

ENTRYPOINT ["/app/entrypoint.sh"]
