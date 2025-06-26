# Stage 1: Build
FROM rust:1.87 as builder

WORKDIR /app

COPY clients/cli/Cargo.toml clients/cli/Cargo.lock ./clients/cli/
WORKDIR /app/clients/cli
RUN cargo fetch

COPY clients/cli ./clients/cli
WORKDIR /app/clients/cli

# Tambahkan debug build output agar tahu kenapa gagal
RUN cargo build --release --locked || true
RUN echo "====== BUILD LOG OUTPUT ======" && find /app/clients/cli/target/release/build -type f -exec cat {} \; || true
