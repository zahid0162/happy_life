


class LoginForm {
  final String email;
  final String password;
  final String appPlatform;
  final String appVersion;
  final String tz;
  final String fcmToken;

  LoginForm({
    required this.fcmToken,
    required this.tz ,
    required this.email,
    required this.password,
    this.appPlatform = 'android',
    this.appVersion = '1',
  });

  // Optional: Factory constructor to create an instance from JSON
  factory LoginForm.fromJson(Map<String, dynamic> json) {
    return LoginForm(
      tz: json['tz'],
      fcmToken: '',
      email: json['email'],
      password: json['password'],
      appPlatform: json['app_platform'] ?? 'android',
      appVersion: json['app_version'] ?? '1',
    );
  }

  // Optional: Method to convert the instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'deviceToken' : fcmToken,
      'tz': tz,
      'email': email,
      'password': password,
      'app_platform': appPlatform,
      'app_version': appVersion,
    };
  }
}
