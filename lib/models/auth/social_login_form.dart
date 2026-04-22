

class SocialLoginForm {
  String token;
  String provider;
  String appPlatform;
  String appVersion;

  SocialLoginForm({
    this.token = "",
    this.provider = "google",
    this.appPlatform = "android",
    this.appVersion = "1",
  });

  // Factory constructor to create an instance from a JSON map
  factory SocialLoginForm.fromJson(Map<String, dynamic> json) {
    return SocialLoginForm(
      token: json['token'] ?? "",
      provider: json['provider'] ?? "google",
      appPlatform: json['app_platform'] ?? "android",
      appVersion: json['app_version'] ?? "1",
    );
  }

  // Method to convert an instance into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'provider': provider,
      'app_platform': appPlatform,
      'app_version': appVersion,
    };
  }

}
