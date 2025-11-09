# Quick Start Guide

Get the API running in less than 5 minutes!

## Prerequisites

- Dart SDK 3.0+ ([Install Dart](https://dart.dev/get-dart))

## Installation & Running

### Option 1: Quick Start (Development)

```bash
# 1. Install dart_frog CLI
dart pub global activate dart_frog_cli

# 2. Clone and navigate to the project
git clone https://github.com/rikoabadi/dartyuk.git
cd dartyuk

# 3. Install dependencies
dart pub get

# 4. Start the development server
dart_frog dev
```

The API will be available at `http://localhost:8080`

### Option 2: Production Build

```bash
# Build for production
dart_frog build

# Run the production server
dart build/bin/server.dart
```

### Option 3: Docker

```bash
# Using Docker Compose (recommended)
docker-compose up --build

# Or using Docker directly
docker build -t dartyuk .
docker run -p 8080:8080 dartyuk
```

## Test the API

```bash
# Check health
curl http://localhost:8080/api/v1/health

# Create a todo
curl -X POST http://localhost:8080/api/v1/todos \
  -H "Content-Type: application/json" \
  -d '{"title":"My First Todo","description":"Testing the API","completed":false}'

# List todos
curl http://localhost:8080/api/v1/todos

# Get a specific todo
curl http://localhost:8080/api/v1/todos/1

# Update a todo
curl -X PATCH http://localhost:8080/api/v1/todos/1 \
  -H "Content-Type: application/json" \
  -d '{"completed":true}'

# Delete a todo
curl -X DELETE http://localhost:8080/api/v1/todos/1
```

## Next Steps

- Read the full [API Documentation](README.md#api-documentation)
- Run tests: `dart test`
- Run linter: `dart analyze`

## Common Issues

### Port already in use

If port 8080 is already in use, you can change it:

For dev:
```bash
PORT=3000 dart_frog dev
```

For production:
```bash
PORT=3000 dart build/bin/server.dart
```

### Database file permissions

The SQLite database file (`dartyuk.db`) is created automatically in the project root. If you encounter permission issues, ensure the directory is writable.

## Support

For issues or questions, please visit the [GitHub repository](https://github.com/rikoabadi/dartyuk).
