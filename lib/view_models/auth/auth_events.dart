import 'package:flutter/material.dart';

abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;
  final Function({required bool isProfileCompleted}) onSuccess;
  final Function({required String error}) onError;

  LoginEvent(
      {required this.email,
      required this.password,
      required this.onSuccess,
      required this.onError});
}

class InitialProfileInfo extends AuthEvent {
  final String name;
  final String dob;
  final String filePath;

  InitialProfileInfo({required this.name,required this.dob,required this.filePath});

}

class RegisterEvent extends AuthEvent {
  final String email;
  final String password;
  final Function({required bool isProfileCompleted}) onSuccess;
  final Function({required String error}) onError;

  RegisterEvent(
      {required this.email,
        required this.password,
        required this.onSuccess,
        required this.onError});
}

class CompleteProfileEvent extends AuthEvent {
  final String? name;
  final String number;
  final String country;
  final String city;
  final String gender;
  final String? dob;
  String? filePath;
  final Function onSuccess;
  final Function({required String error}) onError;

  CompleteProfileEvent(
      {this.name,
        required this.number,
        required this.country,
        required this.city,
        required this.gender,
        this.dob,
        this.filePath,
        required this.onSuccess,
        required this.onError});
}

class ForgotPasswordEvent extends AuthEvent {
  final String email;
  final Function onSuccess;
  final Function({String? error}) onError;

  ForgotPasswordEvent(
      {required this.email, required this.onSuccess, required this.onError});
}

class ResetPasswordEvent extends AuthEvent {
  final String password;
  final String confirmPassword;
  final String token;
  final Function onSuccess;
  final Function({required String error}) onError;

  ResetPasswordEvent({
    required this.password,
    required this.confirmPassword,
    required this.token,
    required this.onSuccess,
    required this.onError,
  });
}

class GoogleSignIn extends AuthEvent {
  final Function({required bool isProfileCompleted}) onSuccess;
  final Function({required String error}) onError;

  GoogleSignIn({
    required this.onSuccess,
    required this.onError,
  });
}

class AppleSignIn extends AuthEvent {
  final Function({required bool isProfileCompleted}) onSuccess;
  final Function({required String error}) onError;

  AppleSignIn({
    required this.onSuccess,
    required this.onError,
  });
}

class FacebookSignIn extends AuthEvent {
  final Function({required String token}) onSuccess;
  final Function({required String error}) onError;

  FacebookSignIn({
    required this.onSuccess,
    required this.onError,
  });
}
