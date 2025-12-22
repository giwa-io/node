FROM rust:1.92-bookworm AS just-builder

WORKDIR /app

RUN cargo install just
RUN cp $(which just) .
# --------------------------------------------------------
FROM golang:1.24.10-bookworm AS builder

RUN git clone https://github.com/ethereum-optimism/optimism.git /optimism

WORKDIR /optimism

ARG OPNODE_VERSION

RUN git checkout op-node/$OPNODE_VERSION

COPY --from=just-builder /app/just /usr/local/bin/

RUN make op-node
# -------------------------------------------------------------------------
FROM ubuntu:noble

WORKDIR /app

COPY --from=builder /optimism/op-node/bin/op-node /usr/local/bin/
COPY genesis/consensus/ /app/
COPY --chmod=755 node/entrypoint.sh /app/

ENTRYPOINT ["/app/entrypoint.sh"]
