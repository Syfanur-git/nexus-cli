# Build stage
FROM rust:1.87 as builder

WORKDIR /app
COPY clients/cli ./clients/cli

WORKDIR /app/clients/cli
RUN cargo build --release --locked

# Runtime stage
FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y libssl3 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --from=builder /app/clients/cli/target/release/nexus-network .

ENTRYPOINT ["./nexus-network"]
