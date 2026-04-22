class ResetPasswordForm {
  String password;
  String passwordConfirmation;

  ResetPasswordForm({
    required this.password,
    required this.passwordConfirmation,
  });

  Map<String, dynamic> toMap() {
    return {
      'password': this.password,
      'password_confirmation': this.passwordConfirmation,
    };
  }
}

class ResetPasswordResponse {
  final String message;

  ResetPasswordResponse({
    this.message = '',
  });

  // Convert JSON to model
  factory ResetPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ResetPasswordResponse(
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
