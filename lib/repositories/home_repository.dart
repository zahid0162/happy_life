import 'package:google_sign_in/google_sign_in.dart';
import 'package:location/location.dart';
import 'package:my_happy_work_place/constants/api_endpoints.dart';
import 'package:my_happy_work_place/managers/api_helpers.dart';
import 'package:my_happy_work_place/models/dashboard/category.dart';
import 'package:my_happy_work_place/models/dashboard/home_response.dart';
import 'package:my_happy_work_place/models/dashboard/user_profile.dart';
import 'package:my_happy_work_place/models/error_response.dart';
import 'package:my_happy_work_place/models/support/support_response.dart';

import '../managers/api_manager.dart';
import '../models/auth/login_response.dart';
import '../utils/preference_helper.dart';

class HomeRepository {
  final ApiManager apiManager;

  HomeRepository({required this.apiManager});

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<ApiResponse<HomeResponseData, ErrorResponse>> getUserHomeData() async {
    final token = await SharedPreferencesHelper.getToken();
    final Map<String, String> headerMap = {};
    headerMap['Authorization'] = "Bearer $token";
    ApiResponse<HomeResponseData, ErrorResponse> apiResponse =
        await apiManager.callApi(
            url: ApiEndpoints.userHome,
            method: ApiMethod.GET,
            headers: headerMap,
            responseFromJson: (data) => HomeResponseData.fromJson(data),
            errorFromJson: (data) => ErrorResponse.fromJson(data));
    return apiResponse;
  }

  Future<ApiResponse<UserProfileResponse, ErrorResponse>>
      getUserProfile() async {
    final token = await SharedPreferencesHelper.getToken();
    final Map<String, String> headerMap = {};
    headerMap['Authorization'] = "Bearer $token";
    ApiResponse<UserProfileResponse, ErrorResponse> apiResponse =
        await apiManager.callApi(
            url: ApiEndpoints.userProfile,
            method: ApiMethod.GET,
            headers: headerMap,
            responseFromJson: (data) => UserProfileResponse.fromJson(data),
            errorFromJson: (data) => ErrorResponse.fromJson(data));
    return apiResponse;
  }

  Future<ApiResponse<PlacesResponse, ErrorResponse>> getSupportPlaces(
      LocationData locationDate, String categoryId) async {
    final token = await SharedPreferencesHelper.getToken();
    final Map<String, String> headerMap = {};
    headerMap['Authorization'] = "Bearer $token";
    final Map<String, String?> queryMap = {};
    queryMap['latitude'] = locationDate.latitude.toString();
    queryMap['longitude'] = locationDate.longitude.toString();
    queryMap['categoryId'] = categoryId;
    ApiResponse<PlacesResponse, ErrorResponse> apiResponse =
        await apiManager.callApi(
            url: ApiEndpoints.support,
            method: ApiMethod.GET,
            headers: headerMap,
            queryParameters: queryMap,
            responseFromJson: (data) => PlacesResponse.fromJson(data),
            errorFromJson: (data) => ErrorResponse.fromJson(data));
    return apiResponse;
  }

  Future<ApiResponse<UpdateCategoryResponse, ErrorResponse>>
      updateCategoryStatus(String id, String emotion) async {
    final token = await SharedPreferencesHelper.getToken();
    final Map<String, String> headerMap = {};
    headerMap['Authorization'] = "Bearer $token";
    final Map<String, dynamic> bodyMap = {'id': id, 'emotion': emotion};
    ApiResponse<UpdateCategoryResponse, ErrorResponse> apiResponse =
        await apiManager.callApi(
            url: ApiEndpoints.updateCategory,
            method: ApiMethod.POST,
            body: bodyMap,
            headers: headerMap,
            responseFromJson: (data) => UpdateCategoryResponse.fromJson(data),
            errorFromJson: (data) => ErrorResponse.fromJson(data));
    return apiResponse;
  }

  Future<ApiResponse<CompleteProfileResponse, ErrorResponse>> uploadProfile(
      {required CompleteProfileForm loginForm}) async {
    final token = await SharedPreferencesHelper.getToken();
    final Map<String, String> map = {};
    map['Authorization'] = "Bearer $token";
    ApiResponse<CompleteProfileResponse, ErrorResponse> apiResponse =
        await apiManager
            .callApiMultipart<CompleteProfileResponse, ErrorResponse>(
                url: ApiEndpoints.updateProfile,
                body: loginForm.toJson(),
                file: loginForm.file,
                headers: map,
                responseFromJson: (data) =>
                    CompleteProfileResponse.fromJson(data),
                errorFromJson: (data) => ErrorResponse.fromJson(data));
    return apiResponse;
  }

  Future<ApiResponse<SuccessResponse, ErrorResponse>> updateEventStatus(
      String id, String status) async {
    final token = await SharedPreferencesHelper.getToken();
    final Map<String, String> headerMap = {};
    headerMap['Authorization'] = "Bearer $token";
    final Map<String, dynamic> bodyMap = {'status': status};
    ApiResponse<SuccessResponse, ErrorResponse> apiResponse =
        await apiManager.callApi(
            url: '${ApiEndpoints.updateGoalAction}$id',
            method: ApiMethod.PUT,
            body: bodyMap,
            headers: headerMap,
            responseFromJson: (data) => SuccessResponse.fromJson(data),
            errorFromJson: (data) => ErrorResponse.fromJson(data));
    return apiResponse;
  }

  Future<ApiResponse<SuccessResponse, ErrorResponse>> deleteAccount() async {
    final token = await SharedPreferencesHelper.getToken();
    final Map<String, String> headerMap = {};
    headerMap['Authorization'] = "Bearer $token";
    ApiResponse<SuccessResponse, ErrorResponse> apiResponse =
        await apiManager.callApi(
            url: ApiEndpoints.deleteAccount,
            method: ApiMethod.DELETE,
            headers: headerMap,
            responseFromJson: (data) => SuccessResponse.fromJson(data),
            errorFromJson: (data) => ErrorResponse.fromJson(data));
    return apiResponse;
  }

  Future<ApiResponse<SuccessResponse, ErrorResponse>> logout() async {
    final token = await SharedPreferencesHelper.getToken();
    final Map<String, String> headerMap = {};
    headerMap['Authorization'] = "Bearer $token";
    ApiResponse<SuccessResponse, ErrorResponse> apiResponse =
        await apiManager.callApi(
            url: ApiEndpoints.logoutAccount,
            method: ApiMethod.POST,
            headers: headerMap,
            responseFromJson: (data) => SuccessResponse.fromJson(data),
            errorFromJson: (data) => ErrorResponse.fromJson(data));
    return apiResponse;
  }

  Future<void> removeGoogleAccount() async {
    await _googleSignIn.signOut();
  }
}
