# Build Stage
FROM rust:1.87.0-slim as builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
        pkg-config \
            libssl-dev \
                ca-certificates \
                 && rm -rf /var/lib/apt/lists/*

                 WORKDIR /app
                 COPY . .

                 WORKDIR /app/clients/cli
                 RUN cargo build --release --locked

                 # Runtime Stage - dengan GLIBC 2.36
                 FROM debian:bookworm-slim
                 RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*

                 WORKDIR /app
                 COPY --from=builder /app/clients/cli/target/release/nexus-network .

                 ENTRYPOINT ["./nexus-network"]