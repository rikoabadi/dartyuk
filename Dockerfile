# Stage 1: Build
FROM dart:stable AS build

WORKDIR /app

# Copy pubspec files and install dependencies
COPY pubspec.yaml ./
RUN dart pub get --offline || dart pub get

# Copy the rest of the application
COPY . .

# Build the application
RUN dart pub global activate dart_frog_cli && \
    export PATH="$PATH":"$HOME/.pub-cache/bin" && \
    dart_frog build

# Stage 2: Runtime
FROM debian:bookworm-slim AS runtime

# Install required runtime dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy the built application from the build stage
COPY --from=build /app/build /app/build

# Expose the port the app runs on
EXPOSE 8080

# Set environment variables
ENV PORT=8080

# Run the application
CMD ["/app/build/bin/server"]
