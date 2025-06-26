# ======================
# 🏗 Build Stage
# ======================
FROM rust:1.85-slim AS builder

RUN apt-get update && apt-get install -y --no-install-recommends     build-essential     pkg-config     libssl-dev     ca-certificates     && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY clients/cli/Cargo.toml Cargo.toml
COPY clients/cli/Cargo.lock Cargo.lock

RUN cargo fetch --locked

COPY . .

WORKDIR /app/clients/cli
RUN cargo build --release --locked

# ======================
# �� Runtime Stage
# ======================
FROM gcr.io/distroless/cc

WORKDIR /app

COPY --from=builder /app/clients/cli/target/release/nexus-network .

# ✅ Gunakan 2 threads agar stabil di Starter Plan
ENTRYPOINT ["./nexus-network"]
