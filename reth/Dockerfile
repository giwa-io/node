FROM rust:1.88-bookworm AS builder

RUN apt update && apt install -y libclang-dev pkg-config build-essential

RUN git clone https://github.com/ethereum-optimism/optimism.git

WORKDIR /optimism

ARG RETH_VERSION="INVALID"

RUN git checkout $RETH_VERSION && \
    git gc

RUN cd rust/op-reth && make maxperf
# -------------------------------------------------------------------------
FROM ubuntu:noble

WORKDIR /app

COPY --from=builder /optimism/rust/target/maxperf/op-reth /usr/local/bin/
COPY genesis/execution/ /app/
COPY --chmod=755 reth/entrypoint.sh /app/

ENTRYPOINT ["/app/entrypoint.sh"]
