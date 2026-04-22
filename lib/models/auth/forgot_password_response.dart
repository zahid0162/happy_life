

class ForgotPasswordResponse {
  final String message;

  ForgotPasswordResponse({
    this.message = '',
  });

  // Convert JSON to model
  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponse(
      message: json['message'] ?? '',
    );
  }

  // Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}
