# Build Stage
FROM rust:1.87-slim AS builder

RUN apt-get update && apt-get install -y \
    build-essential \
    pkg-config \
    libssl-dev \
    ca-certificates \
    git \
    curl

WORKDIR /app

COPY clients/cli ./clients/cli
COPY Cargo.toml Cargo.lock ./

WORKDIR /app/clients/cli
RUN cargo build --release --locked

# Runtime Stage
FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    libssl3 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=builder /app/clients/cli/target/release/nexus-network .

ENTRYPOINT ["./nexus-network"]
