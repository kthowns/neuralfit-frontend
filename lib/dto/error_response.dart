class ErrorResponse {
  final int status;
  final String message;
  final Map<String, String> errors;

  ErrorResponse({
    required this.status,
    required this.message,
    required this.errors,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      status: json['status'],
      message: json['message'],
      errors: Map<String, String>.from(json['errors']),
    );
  }
}
