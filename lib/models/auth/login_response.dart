import '../dashboard/category.dart';

class LoginData{
  final String authorizationToken;
  final User user;

  LoginData({
    required this.authorizationToken,
    required this.user,
  });

  factory LoginData.fromJson(Map<String,dynamic> json){
    return LoginData(authorizationToken: json["token"], user: User.fromJson(json["user"] ?? {}));
  }

  Map<String, dynamic> toJson() =>
      {
        "token": authorizationToken,
        "user": user.toJson(),
      };
}

class SignUpData{
  final String authorizationToken;
  final User user;

  SignUpData({
    required this.authorizationToken,
    required this.user,
  });

  factory SignUpData.fromJson(Map<String,dynamic> json){
    return SignUpData(authorizationToken: json["token"], user: User.fromJson(json["user"] ?? {}));
  }

  Map<String, dynamic> toJson() =>
      {
        "token": authorizationToken,
        "user": user.toJson(),
      };
}

class LoginResponse {
  final String status;
  final String message;
  final LoginData data;


  LoginResponse({
    required this.status,
    required this.message,
    required this.data
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      message: json["message"] ?? '',
      status: json["status"] ?? '',
      data: LoginData.fromJson(json["data"] ?? {}));

  }

  Map<String, dynamic> toJson() =>
      {
        "status": status,
        "message": message,
        "data" : data.toJson()
      };
}

class CompleteProfileResponse {
  final String status;
  final String message;
  final User data;


  CompleteProfileResponse({
    required this.status,
    required this.message,
    required this.data
  });

  factory CompleteProfileResponse.fromJson(Map<String, dynamic> json) {
    return CompleteProfileResponse(
        message: json["message"] ?? '',
        status: json["status"] ?? '',
        data: User.fromJson(json["data"]['user'] ?? {}));

  }

  Map<String, dynamic> toJson() =>
      {
        "status": status,
        "message": message,
        "data" : data.toJson()
      };
}

class User {
  final String? id;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? password;
  final String? country;
  final String? city;
  final double? latitude;
  final double? longitude;
  final String? gender;
  final String? dob;
  final String? imageKey;
  final bool? isAdmin;
  final bool? isActive;
  final DateTime? deletedAt;

  // Constructor
  User({
    this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.password,
    this.country,
    this.city,
    this.latitude,
    this.longitude,
    this.gender,
    this.dob,
    this.imageKey,
    this.isAdmin,
    this.isActive,
    this.deletedAt,
  });

  // Factory constructor to create a User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phone_number'] as String?,
      password: json['password'] as String?,
      country: json['country'] as String?,
      city: json['city'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      gender: json['gender'] as String?,
      dob: json['dob'] as String?,
      imageKey: json['image_url'] as String?,
      isAdmin: json['is_admin'] as bool?,
      isActive: json['is_active'] as bool?,
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'] as String)
          : null,
    );
  }

  // Method to convert User object to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'password': password,
      'country': country,
      'city': city,
      'latitude': latitude,
      'longitude': longitude,
      'gender': gender,
      'dob': dob,
      'image_url': imageKey,
      'is_admin': isAdmin,
      'is_active': isActive,
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  // CopyWith method to create a new instance with updated values
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? password,
    String? country,
    String? city,
    double? latitude,
    double? longitude,
    String? gender,
    String? dob,
    String? imageKey,
    bool? isAdmin,
    bool? isActive,
    DateTime? deletedAt,
    List<Category>? categories,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      country: country ?? this.country,
      city: city ?? this.city,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      imageKey: imageKey ?? this.imageKey,
      isAdmin: isAdmin ?? this.isAdmin,
      isActive: isActive ?? this.isActive,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}

