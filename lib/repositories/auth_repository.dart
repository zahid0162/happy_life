
import 'dart:io';

import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_happy_work_place/models/dashboard/user_profile.dart';
import 'package:my_happy_work_place/utils/preference_helper.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../constants/api_endpoints.dart';
import '../managers/api_helpers.dart';
import '../managers/api_manager.dart';
import '../models/auth/forgot_password.dart';
import '../models/auth/forgot_password_response.dart';
import '../models/auth/login_form.dart';
import '../models/auth/login_response.dart';
import '../models/auth/reset_password.dart';
import '../models/error_response.dart';

class AuthRepository {
  final ApiManager apiManager;

  AuthRepository({required this.apiManager});

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<ApiResponse<LoginResponse, ErrorResponse>> login(
      {required LoginForm loginForm}) async {
    ApiResponse<LoginResponse, ErrorResponse> apiResponse =
        await apiManager.callApi<LoginResponse, ErrorResponse>(
            url: ApiEndpoints.login,
            body: loginForm.toJson(),
            method: ApiMethod.POST,
            headers: {
              "Content-Type": "application/json",
            },
            responseFromJson: (data) => LoginResponse.fromJson(data),
            errorFromJson: (data) => ErrorResponse.fromJson(data));
    return apiResponse;
  }

  Future<ApiResponse<LoginResponse, ErrorResponse>> register(
      {required LoginForm loginForm}) async {
    ApiResponse<LoginResponse, ErrorResponse> apiResponse =
        await apiManager.callApi<LoginResponse, ErrorResponse>(
            url: ApiEndpoints.register,
            body: loginForm.toJson(),
            method: ApiMethod.POST,
            responseFromJson: (data) => LoginResponse.fromJson(data),
            errorFromJson: (data) => ErrorResponse.fromJson(data));
    return apiResponse;
  }

  Future<ApiResponse<CompleteProfileResponse, ErrorResponse>> uploadProfile(
      {required CompleteProfileForm loginForm}) async {
    final token = await SharedPreferencesHelper.getToken();
    final Map<String, String> map = {};
    map['Authorization'] = "Bearer $token";
    ApiResponse<CompleteProfileResponse, ErrorResponse> apiResponse =
        await apiManager.callApiMultipart<CompleteProfileResponse, ErrorResponse>(
            url: ApiEndpoints.updateProfile,
            body: loginForm.toJson(),
            file: loginForm.file,
            headers: map,
            responseFromJson: (data) => CompleteProfileResponse.fromJson(data),
            errorFromJson: (data) => ErrorResponse.fromJson(data));
    return apiResponse;
  }

  Future<ApiResponse<ForgotPasswordResponse, ForgotPasswordResponse>>
      forgotPassword({required ForgotPasswordForm forgotPasswordForm}) async {
    ApiResponse<ForgotPasswordResponse, ForgotPasswordResponse> apiResponse =
        await apiManager
            .callApi<ForgotPasswordResponse, ForgotPasswordResponse>(
                url: ApiEndpoints.passwords,
                body: forgotPasswordForm.toJson(),
                method: ApiMethod.POST,
                responseFromJson: (data) =>
                    ForgotPasswordResponse.fromJson(data),
                errorFromJson: (data) => ForgotPasswordResponse.fromJson(data));
    return apiResponse;
  }

  Future<ApiResponse<ResetPasswordResponse, ResetPasswordResponse>>
      resetPassword(
          {required ResetPasswordForm resetPasswordForm,
          required String resetToken}) async {
    String url = "${ApiEndpoints.passwords}/$resetToken";
    ApiResponse<ResetPasswordResponse, ResetPasswordResponse> apiResponse =
        await apiManager.callApi<ResetPasswordResponse, ResetPasswordResponse>(
            url: url,
            encodeUri: true,
            queryParameters: resetPasswordForm.toMap(),
            method: ApiMethod.PUT,
            responseFromJson: (data) => ResetPasswordResponse.fromJson(data),
            errorFromJson: (data) => ResetPasswordResponse.fromJson(data));
    return apiResponse;
  }

  Future<String?> googleAuth() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return null;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      return googleAuth.accessToken;
    } catch (error) {
      rethrow;
    }
  }

  Future<String?> appleAuth() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      return credential.identityToken;
    } catch (error) {
      rethrow;
    }
  }

  Future<ApiResponse<LoginResponse, ErrorResponse>> googleLogin(
      {required String token}) async {
    final Map<String, String> map = {};
    map['identityToken'] = token;
    map['platform'] = Platform.isAndroid ? 'android' : 'ios';
    map['deviceToken'] = await SharedPreferencesHelper.getFcmToken();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    map['tz'] = currentTimeZone;
    ApiResponse<LoginResponse, ErrorResponse> apiResponse =
        await apiManager.callApi<LoginResponse, ErrorResponse>(
            url: ApiEndpoints.googleLogin,
            body: map,
            method: ApiMethod.POST,
            responseFromJson: (data) => LoginResponse.fromJson(data),
            errorFromJson: (data) => ErrorResponse.fromJson(data));
    return apiResponse;
  }

  Future<ApiResponse<LoginResponse, ErrorResponse>> appleLogin(
      {required String token}) async {
    final Map<String, String> map = {};
    map['identityToken'] = token;
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    map['tz'] = currentTimeZone;
    map['deviceToken'] = await SharedPreferencesHelper.getFcmToken();
    ApiResponse<LoginResponse, ErrorResponse> apiResponse =
        await apiManager.callApi<LoginResponse, ErrorResponse>(
            url: ApiEndpoints.appleLogin,
            body: map,
            method: ApiMethod.POST,
            responseFromJson: (data) => LoginResponse.fromJson(data),
            errorFromJson: (data) => ErrorResponse.fromJson(data));
    return apiResponse;
  }
}
