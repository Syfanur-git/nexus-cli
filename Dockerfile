# Stage 1: Build
FROM rust:1.87 as builder

WORKDIR /app

# Copy Cargo files and fetch dependencies
COPY clients/cli/Cargo.toml clients/cli/Cargo.lock ./clients/cli/
WORKDIR /app/clients/cli
RUN cargo fetch

# Copy source code
COPY clients/cli ./clients/cli
WORKDIR /app/clients/cli
RUN cargo build --release --locked

# Stage 2: Runtime
FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y libssl3 && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --from=builder /app/clients/cli/target/release/nexus-network .

ENTRYPOINT ["./nexus-network"]
