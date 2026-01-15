# 1. Build Stage
FROM rust:latest AS builder

WORKDIR /app
COPY . .

# This will now find main.rs because of the Cargo.toml [[bin]] section
RUN cargo build --release

# 2. Runtime Stage
FROM debian:bookworm-slim

# Install CA Certificates for secure RPC connections
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy the finished binary from the builder stage
COPY --from=builder /app/target/release/apex_omega /app/apex_omega

# Run the binary
CMD ["./apex_omega"]
