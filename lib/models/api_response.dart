class ApiResponse<T> {
  final T? data;
  final PaginationMeta? meta;
  final ApiError? error;

  ApiResponse({
    this.data,
    this.meta,
    this.error,
  });

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};

    if (data != null) {
      if (data is List) {
        json['data'] = (data as List).map((item) {
          if (item is Map) return item;
          if (item.toString().startsWith('{')) {
            // Already JSON-like
            return item;
          }
          return item;
        }).toList();
      } else if (data is Map) {
        json['data'] = data;
      } else {
        json['data'] = data;
      }
    } else {
      json['data'] = null;
    }

    if (meta != null) {
      json['meta'] = meta!.toJson();
    }

    json['error'] = error?.toJson();

    return json;
  }

  factory ApiResponse.success(T data, {PaginationMeta? meta}) {
    return ApiResponse(data: data, meta: meta, error: null);
  }

  factory ApiResponse.error(ApiError error) {
    return ApiResponse(data: null, error: error);
  }
}

class PaginationMeta {
  final int page;
  final int limit;
  final int total;

  PaginationMeta({
    required this.page,
    required this.limit,
    required this.total,
  });

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'limit': limit,
      'total': total,
    };
  }
}

class ApiError {
  final String code;
  final String message;
  final dynamic details;

  ApiError({
    required this.code,
    required this.message,
    this.details,
  });

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'details': details,
    };
  }
}
