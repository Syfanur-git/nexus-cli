# Stage 1: Build
FROM rust:1.87-slim AS builder

# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    pkg-config \
    libssl-dev \
    git \
    curl \
    ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy CLI project
COPY clients/cli ./clients/cli
COPY Cargo.toml Cargo.lock ./

# Build release binary
WORKDIR /app/clients/cli
RUN cargo build --release --locked

# Stage 2: Runtime
FROM debian:bookworm

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    libssl3 \
    curl \
    ca-certificates && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy built binary from builder stage
COPY --from=builder /app/clients/cli/target/release/nexus-network .

# Default command (you can override this in Railway if needed)
ENTRYPOINT ["./nexus-network"]
