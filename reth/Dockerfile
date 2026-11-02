FROM rust:1.95-bookworm AS builder

RUN apt update && apt install -y libclang-dev pkg-config build-essential
RUN cargo install just --root /usr/local

ARG RETH_VERSION="INVALID"

RUN git clone https://github.com/ethereum-optimism/optimism.git --branch op-reth/$RETH_VERSION --single-branch /optimism

WORKDIR /optimism

# op-reth v2.6.1 dropped the `maxperf` just recipe. GIT_* / BUILD_PROFILE feed `op-reth --version`.
RUN cd rust/op-reth && just update-superchain-registry-submodule && \
    GIT_VERSION="$RETH_VERSION" GIT_COMMIT="$(git rev-parse HEAD)" GIT_DATE="$(git log -1 --format=%ct)" BUILD_PROFILE=maxperf \
    cargo build --profile maxperf --features jemalloc,asm-keccak --bin op-reth
# -------------------------------------------------------------------------
FROM ubuntu:noble

RUN apt-get update && \
    apt-get install -y ca-certificates && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=builder /optimism/rust/target/maxperf/op-reth /usr/local/bin/
COPY genesis/execution/ /app/
COPY --chmod=755 reth/entrypoint.sh /app/

ENTRYPOINT ["/app/entrypoint.sh"]
