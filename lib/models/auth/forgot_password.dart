

class ForgotPasswordForm {
  final String emailAddress;

  ForgotPasswordForm({
    this.emailAddress = '',
  });

  // Convert JSON to model
  factory ForgotPasswordForm.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordForm(
      emailAddress: json['email_address'] ?? '',
    );
  }

  // Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'email_address': emailAddress,
    };
  }
}
