# Multi-stage Dockerfile for a tiny Go runtime image
# Build stage: use a small alpine image, compile a static binary and drop debug symbols
FROM golang:1.21-alpine AS builder

WORKDIR /src

# install build-time dependencies (git needed for some modules; ca-certificates for certs)
RUN apk add --no-cache git ca-certificates

ENV CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

# Download modules first (cached layer)
COPY go.mod go.sum ./
RUN go mod download

# Copy source and build
COPY . .

# Create an unprivileged user with a fixed UID so we can run as non-root in final image
RUN adduser -D -u 1000 appuser

# Build a small, static binary and strip symbols
RUN go build -ldflags='-s -w' -o server .

# Ensure the binary is owned by the non-root user
RUN chown 1000:1000 server

## Final stage: scratch for the smallest possible image
FROM scratch

# (Optional) copy CA certs so TLS clients work if needed
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

# Copy the statically-built server binary
COPY --from=builder /src/server /server

# Run as the non-root numeric UID from builder
USER 1000

EXPOSE 8080

ENTRYPOINT ["/server"]
