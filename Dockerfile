# Stage 1: Build binary
FROM rust:1.87-slim as builder

RUN apt-get update && apt-get install -y \
    build-essential pkg-config libssl-dev curl ca-certificates git

    WORKDIR /app

    COPY . .

    RUN cargo build --release --locked

    # Stage 2: Runtime
    FROM debian:bookworm-slim

    RUN apt-get update && apt-get install -y \
        ca-certificates curl iputils-ping && \
            rm -rf /var/lib/apt/lists/*

            WORKDIR /app

            COPY --from=builder /app/target/release/nexus-network .

            CMD ["sh", "-c", "./nexus-network start --node-id=${NODE_ID}"]