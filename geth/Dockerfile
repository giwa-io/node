FROM golang:1.23.0-bullseye AS builder

RUN git clone https://github.com/ethereum-optimism/op-geth.git /op-geth

WORKDIR /op-geth

ARG OPGETH_VERSION

RUN git checkout $OPGETH_VERSION

RUN make geth
# -------------------------------------------------------------------------
FROM ubuntu:jammy

RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=builder /op-geth/build/bin/geth /usr/local/bin/
COPY genesis/execution/ /app/
COPY --chmod=755 geth/entrypoint.sh /app/

ENTRYPOINT ["/app/entrypoint.sh"]
