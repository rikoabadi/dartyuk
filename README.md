# Dartyuk - REST API CRUD with Dart Frog & SQLite

Production-ready REST API demonstrating CRUD operations using [Dart Frog](https://dartfrog.vgv.dev/) framework and SQLite database.

## Features

- ✅ Complete CRUD operations for Todo items
- ✅ Pagination, sorting, filtering, and search
- ✅ Soft delete functionality
- ✅ Input validation with fail-closed approach
- ✅ Structured error handling
- ✅ Comprehensive test coverage
- ✅ Docker support
- ✅ Production-ready structure

## Tech Stack

- **Framework**: Dart Frog 1.2.x
- **Database**: SQLite3
- **Language**: Dart 3.x
- **Testing**: dart test

## API Documentation

Base URL: `http://localhost:8080/api/v1`

### Endpoints

#### Health Check
```http
GET /api/v1/health
```

**Response:**
```json
{
  "data": {
    "status": "ok",
    "time": "2025-11-07T01:23:45.123Z"
  },
  "error": null
}
```

#### List Todos
```http
GET /api/v1/todos
```

**Query Parameters:**
- `page` (integer, default: 1) - Page number
- `limit` (integer, default: 20, max: 100) - Items per page
- `sort` (string: `created_at` | `title`, default: `created_at`) - Sort field
- `order` (string: `asc` | `desc`, default: `desc`) - Sort order
- `completed` (boolean) - Filter by completion status
- `q` (string) - Search in title and description
- `include_deleted` (boolean, default: false) - Include soft-deleted items

**Response:**
```json
{
  "data": [
    {
      "id": 1,
      "title": "Sample Todo",
      "description": "Sample description",
      "completed": false,
      "created_at": "2025-11-07T01:23:45.123Z",
      "updated_at": "2025-11-07T01:23:45.123Z",
      "deleted_at": null
    }
  ],
  "meta": {
    "page": 1,
    "limit": 20,
    "total": 1
  },
  "error": null
}
```

#### Create Todo
```http
POST /api/v1/todos
Content-Type: application/json
```

**Request Body:**
```json
{
  "title": "New Todo",
  "description": "Optional description",
  "completed": false
}
```

**Validation Rules:**
- `title`: required, 1-200 characters
- `description`: optional, max 2000 characters
- `completed`: optional, boolean

**Response:** (201 Created)
```json
{
  "data": {
    "id": 1,
    "title": "New Todo",
    "description": "Optional description",
    "completed": false,
    "created_at": "2025-11-07T01:23:45.123Z",
    "updated_at": "2025-11-07T01:23:45.123Z",
    "deleted_at": null
  },
  "error": null
}
```

#### Get Todo by ID
```http
GET /api/v1/todos/:id
```

**Response:**
```json
{
  "data": {
    "id": 1,
    "title": "Sample Todo",
    "description": "Sample description",
    "completed": false,
    "created_at": "2025-11-07T01:23:45.123Z",
    "updated_at": "2025-11-07T01:23:45.123Z",
    "deleted_at": null
  },
  "error": null
}
```

#### Update Todo
```http
PATCH /api/v1/todos/:id
Content-Type: application/json
```

**Request Body:** (partial update supported)
```json
{
  "title": "Updated Title",
  "completed": true
}
```

**Response:**
```json
{
  "data": {
    "id": 1,
    "title": "Updated Title",
    "description": "Sample description",
    "completed": true,
    "created_at": "2025-11-07T01:23:45.123Z",
    "updated_at": "2025-11-07T02:30:00.456Z",
    "deleted_at": null
  },
  "error": null
}
```

#### Delete Todo (Soft Delete)
```http
DELETE /api/v1/todos/:id
```

**Response:** 204 No Content

### Error Response Format

```json
{
  "data": null,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Validation failed",
    "details": [
      {
        "field": "title",
        "message": "Title is required"
      }
    ]
  }
}
```

**HTTP Status Codes:**
- `200` - OK
- `201` - Created
- `204` - No Content
- `400` - Bad Request
- `404` - Not Found
- `422` - Unprocessable Entity (validation error)
- `500` - Internal Server Error

## Getting Started

### Prerequisites

- Dart SDK 3.0 or higher
- Docker (optional, for containerized deployment)

### Local Development

1. **Install Dart SDK**

   Follow instructions at [dart.dev](https://dart.dev/get-dart)

2. **Install Dart Frog CLI**

   ```bash
   dart pub global activate dart_frog_cli
   ```

3. **Clone the repository**

   ```bash
   git clone https://github.com/rikoabadi/dartyuk.git
   cd dartyuk
   ```

4. **Install dependencies**

   ```bash
   dart pub get
   ```

5. **Run the development server**

   ```bash
   dart_frog dev
   ```

   The API will be available at `http://localhost:8080`

6. **Run tests**

   ```bash
   dart test
   ```

7. **Run linter**

   ```bash
   dart analyze
   ```

### Production Build

```bash
dart_frog build
./build/bin/server
```

### Docker Deployment

#### Build and run with Docker Compose

```bash
docker-compose up --build
```

#### Build and run with Docker

```bash
docker build -t dartyuk .
docker run -p 8080:8080 dartyuk
```

The API will be available at `http://localhost:8080`

## Project Structure

```
dartyuk/
├── lib/
│   ├── database/          # Database connection and migrations
│   ├── models/            # Data models and DTOs
│   ├── repositories/      # Data access layer
│   ├── utils/             # Utilities and helpers
│   └── middleware/        # Middleware functions
├── routes/
│   ├── _middleware.dart   # Global middleware
│   └── api/v1/            # API endpoints
│       ├── health.dart
│       └── todos/
│           ├── index.dart
│           └── [id].dart
├── test/                  # Tests
├── Dockerfile             # Docker configuration
├── docker-compose.yml     # Docker Compose configuration
└── pubspec.yaml           # Dart dependencies
```

## Database Schema

### Todos Table

```sql
CREATE TABLE IF NOT EXISTS todos (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  description TEXT,
  completed INTEGER NOT NULL DEFAULT 0,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  deleted_at TEXT
);

CREATE INDEX IF NOT EXISTS idx_todos_created_at ON todos(created_at);
CREATE INDEX IF NOT EXISTS idx_todos_completed ON todos(completed);
CREATE INDEX IF NOT EXISTS idx_todos_deleted_at ON todos(deleted_at);
```

## Testing

Run all tests:
```bash
dart test
```

Run tests with coverage:
```bash
dart test --coverage=coverage
dart pub global activate coverage
format_coverage --lcov --in=coverage --out=coverage/lcov.info --report-on=lib
```

## License

MIT

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.