

class ErrorResponse {
  final String error;

  ErrorResponse({
    required this.error,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
      error: json["message"] ?? 'Unknown error occurred.',
    );
  }

  Map<String, dynamic> toJson() => {
    "message": error,
  };
}