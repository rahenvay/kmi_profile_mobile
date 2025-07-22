/// API Response wrapper class to handle the standard response format
class ApiResponse<T> {
  final String title;
  final int statusCode;
  final String result;
  final String message;
  final bool isError;
  final T? content;

  ApiResponse({
    required this.title,
    required this.statusCode,
    required this.result,
    required this.message,
    required this.isError,
    this.content,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    return ApiResponse(
      title: json['title'] ?? '',
      statusCode: json['statusCode'] ?? 0,
      result: json['result'] ?? '',
      message: json['message'] ?? '',
      isError: json['isError'] ?? false,
      content: json['content'] != null ? fromJsonT(json['content']) : null,
    );
  }

  bool get isSuccess => !isError && statusCode >= 200 && statusCode < 300;
}

/// API Response for list data
class ApiListResponse<T> {
  final String title;
  final int statusCode;
  final String result;
  final String message;
  final bool isError;
  final List<T>? content;

  ApiListResponse({
    required this.title,
    required this.statusCode,
    required this.result,
    required this.message,
    required this.isError,
    this.content,
  });

  factory ApiListResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    List<T>? contentList;
    if (json['content'] != null && json['content'] is List) {
      contentList = (json['content'] as List)
          .map((item) => fromJsonT(item as Map<String, dynamic>))
          .toList();
    }

    return ApiListResponse(
      title: json['title'] ?? '',
      statusCode: json['statusCode'] ?? 0,
      result: json['result'] ?? '',
      message: json['message'] ?? '',
      isError: json['isError'] ?? false,
      content: contentList,
    );
  }

  bool get isSuccess => !isError && statusCode >= 200 && statusCode < 300;
}
