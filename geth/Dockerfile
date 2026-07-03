# DEPRECATED: op-geth will be removed after the Karst hardfork and cannot follow
#             GIWA Sepolia once Karst activates. Use reth (CLIENT=reth) instead.
#             See: https://docs.giwa.io/notices/giwa-chain/op-geth-sunset
FROM golang:1.24.0-bookworm AS builder

ARG OPGETH_VERSION

RUN git clone https://github.com/ethereum-optimism/op-geth.git --branch $OPGETH_VERSION --single-branch /op-geth

WORKDIR /op-geth

RUN make geth
# -------------------------------------------------------------------------
FROM ubuntu:noble

RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=builder /op-geth/build/bin/geth /usr/local/bin/
COPY genesis/execution/ /app/
COPY --chmod=755 geth/entrypoint.sh /app/

ENTRYPOINT ["/app/entrypoint.sh"]
