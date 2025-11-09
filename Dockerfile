# Stage 1: Build with Dart SDK
FROM dart:stable AS build
WORKDIR /app

# Copy pubspec first for caching
COPY pubspec.* ./
RUN dart pub get

# Copy source
COPY . .

# Ensure dart_frog cli is available and build the dart_frog app
RUN dart pub global activate dart_frog_cli && \
    export PATH="$PATH:$HOME/.pub-cache/bin" && \
    dart_frog build

# Include repo-level static dirs (public/ or static/) into build/public if present
RUN mkdir -p build/public && \
    if [ -d public ]; then cp -r public/* build/public/ || true; fi && \
    if [ -d static ]; then cp -r static/* build/public/ || true; fi

# Compile the built server script to a native executable
RUN if [ -f build/bin/server.dart ]; then \
      dart compile exe build/bin/server.dart -o /app/server; \
    else \
      echo "ERROR: expected build/bin/server.dart not found"; \
      ls -la build || true; \
      exit 1; \
    fi

# Stage 2: Minimal runtime image
FROM debian:bookworm-slim AS runtime

# Install runtime deps incl. sqlite runtime library
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates \
      libsqlite3-0 \
    && rm -rf /var/lib/apt/lists/*

# Add fallback symlink if .so name differs
RUN if [ -f /usr/lib/x86_64-linux-gnu/libsqlite3.so.0 ] && [ ! -f /usr/lib/x86_64-linux-gnu/libsqlite3.so ]; then \
      ln -s /usr/lib/x86_64-linux-gnu/libsqlite3.so.0 /usr/lib/x86_64-linux-gnu/libsqlite3.so || true; \
    fi

# Create non-root user for running the app
RUN useradd --create-home --shell /bin/bash appuser

WORKDIR /app

# Copy compiled binary and built assets (including build/public) from build stage
COPY --from=build /app/server /usr/local/bin/server
COPY --from=build /app/build /app/build

# Ensure a /app/public exists and populate it from build/public if present
RUN if [ -d /app/build/public ] && [ "$(ls -A /app/build/public 2>/dev/null)" != "" ]; then \
      cp -r /app/build/public /app/public; \
    else \
      mkdir -p /app/public; \
    fi

# Ensure permissions
RUN chown -R appuser:appuser /app && chmod +x /usr/local/bin/server

USER appuser

ENV PORT=8080
EXPOSE 8080

ENTRYPOINT ["/usr/local/bin/server"]