import 'dart:io';

import 'package:flutter/foundation.dart';

import '../auth/login_response.dart';

class CompleteProfileForm {
  String name;
  String number;
  String country;
  String city;
  String dob;
  File? file;
  String gender;

  CompleteProfileForm({
    required this.name,
    required this.number,
    required this.country,
    required this.city,
    required this.gender,
    required this.dob,
    this.file
  });

  Map<String, String> toJson() {
    return {
      'name': name,
      'phone_number': number,
      'country': country,
      'city': city,
      'dob': dob,
      'gender': gender,
    };
  }

  // Create a CompleteProfileForm object from a JSON map
  factory CompleteProfileForm.fromJson(Map<String, dynamic> json) {
    return CompleteProfileForm(
      name: json['name'] ?? '',
      number: json['phone_number'] ?? '',
      country: json['country'] ?? '',
      city: json['city'] ?? '',
      dob: json['dob'] ?? '',
      file: json['image_key'],
      gender: json['gender'] ?? '',
    );
  }


}

class UserProfileResponse{
  String message;
  String status;
  User user;

  UserProfileResponse({required this.status,required this.message, required this.user});

  factory UserProfileResponse.fromJson(Map<String, dynamic> json){
    return UserProfileResponse(
      message: json['message'] as String,
      status: json['status'] as String,
      user: User.fromJson(json['data']['user'])
    );
  }
}

