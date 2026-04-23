import 'package:my_happy_work_place/managers/api_helpers.dart';
import 'package:my_happy_work_place/models/dashboard/action.dart';
import 'package:my_happy_work_place/models/error_response.dart';
import 'package:my_happy_work_place/models/goals/SingleCategoryGoalsResponse.dart';
import 'package:my_happy_work_place/models/goals/category_with_goals_response.dart';
import 'package:my_happy_work_place/models/goals/goal_detail.dart';
import 'package:my_happy_work_place/models/notification/notification_response.dart';

import '../constants/api_endpoints.dart';
import '../managers/api_manager.dart';
import '../models/dashboard/category.dart';
import '../utils/preference_helper.dart';

class GoalsRepository {
  final ApiManager apiManager;

  GoalsRepository({required this.apiManager});

  Future<ApiResponse<CategoryWithGoalsResponse, ErrorResponse>>
      getCategoriesWithGoals() async {
    final token = await SharedPreferencesHelper.getToken();
    final Map<String, String> headerMap = {};
    headerMap['Authorization'] = "Bearer $token";
    ApiResponse<CategoryWithGoalsResponse, ErrorResponse> apiResponse =
        await apiManager.callApi(
            url: ApiEndpoints.allCategoriesGoals,
            method: ApiMethod.GET,
            headers: headerMap,
            responseFromJson: (data) =>
                CategoryWithGoalsResponse.fromJson(data),
            errorFromJson: (data) => ErrorResponse.fromJson(data));
    return apiResponse;
  }

  Future<ApiResponse<SingleCategoryGoalsResponse, ErrorResponse>> getGoals(
      String id) async {
    final token = await SharedPreferencesHelper.getToken();
    final Map<String, String> headerMap = {};
    headerMap['Authorization'] = "Bearer $token";
    final Map<String, String> queryMap = {};
    queryMap['categoryId'] = id;
    ApiResponse<SingleCategoryGoalsResponse, ErrorResponse> apiResponse =
        await apiManager.callApi(
            url: ApiEndpoints.allCategoriesGoals,
            method: ApiMethod.GET,
            headers: headerMap,
            queryParameters: queryMap,
            responseFromJson: (data) =>
                SingleCategoryGoalsResponse.fromJson(data),
            errorFromJson: (data) => ErrorResponse.fromJson(data));
    return apiResponse;
  }

  Future<ApiResponse<GoalDetailResponse, ErrorResponse>> getGoalDetails(
      String id) async {
    final token = await SharedPreferencesHelper.getToken();
    final Map<String, String> headerMap = {};
    headerMap['Authorization'] = "Bearer $token";
    ApiResponse<GoalDetailResponse, ErrorResponse> apiResponse =
        await apiManager.callApi(
            url: ApiEndpoints.goalDetail + id,
            method: ApiMethod.GET,
            headers: headerMap,
            responseFromJson: (data) => GoalDetailResponse.fromJson(data),
            errorFromJson: (data) => ErrorResponse.fromJson(data));
    return apiResponse;
  }

  Future<ApiResponse<NotificationsResponse, ErrorResponse>> getNotifications() async {
    final token = await SharedPreferencesHelper.getToken();
    final Map<String, String> headerMap = {};
    headerMap['Authorization'] = "Bearer $token";
    ApiResponse<NotificationsResponse, ErrorResponse> apiResponse =
    await apiManager.callApi(
        url: ApiEndpoints.notifications,
        method: ApiMethod.GET,
        headers: headerMap,
        responseFromJson: (data) => NotificationsResponse.fromJson(data),
        errorFromJson: (data) => ErrorResponse.fromJson(data));
    return apiResponse;
  }

  Future<ApiResponse<SuccessResponse, ErrorResponse>> updateGoalStatus(
      String id, String status) async {
    final token = await SharedPreferencesHelper.getToken();
    final Map<String, String> headerMap = {};
    headerMap['Authorization'] = "Bearer $token";
    final Map<String, dynamic> bodyMap = {'status': status};
    ApiResponse<SuccessResponse, ErrorResponse> apiResponse =
        await apiManager.callApi(
            url: '${ApiEndpoints.updateGoalStatus}$id',
            method: ApiMethod.PUT,
            body: bodyMap,
            headers: headerMap,
            responseFromJson: (data) => SuccessResponse.fromJson(data),
            errorFromJson: (data) => ErrorResponse.fromJson(data));
    return apiResponse;
  }

  Future<ApiResponse<GoalDetailResponse, ErrorResponse>> createGoal(GoalDetail detail) async {
    final token = await SharedPreferencesHelper.getToken();
    final Map<String, String> headerMap = {};
    headerMap['Authorization'] = "Bearer $token";
    ApiResponse<GoalDetailResponse, ErrorResponse> apiResponse =
    await apiManager.callApi(
        url: ApiEndpoints.createGoal,
        method: ApiMethod.POST,
        headers: headerMap,
        body: detail.getCreateGoalBody(),
        responseFromJson: (data) => GoalDetailResponse.fromJson(data),
        errorFromJson: (data) => ErrorResponse.fromJson(data));
    return apiResponse;
  }

  Future<ApiResponse<GoalDetailResponse, ErrorResponse>> updateGoal(GoalDetail detail) async {
    final token = await SharedPreferencesHelper.getToken();
    final Map<String, String> headerMap = {};
    headerMap['Authorization'] = "Bearer $token";
    ApiResponse<GoalDetailResponse, ErrorResponse> apiResponse =
    await apiManager.callApi(
        url: ApiEndpoints.updateGoal + detail.id,
        method: ApiMethod.PUT,
        headers: headerMap,
        body: detail.getUpdateGoalBody(),
        responseFromJson: (data) => GoalDetailResponse.fromJson(data),
        errorFromJson: (data) => ErrorResponse.fromJson(data));
    return apiResponse;
  }

  Future<ApiResponse<CreateActionResponse, ErrorResponse>> updateActionInfo(GoalAction detail) async {
    final token = await SharedPreferencesHelper.getToken();
    final Map<String, String> headerMap = {};
    headerMap['Authorization'] = "Bearer $token";
    ApiResponse<CreateActionResponse, ErrorResponse> apiResponse =
    await apiManager.callApi(
        url: '${ApiEndpoints.updateActionInfo}${detail.id!}/update',
        method: ApiMethod.PUT,
        headers: headerMap,
        body: detail.toJson(),
        responseFromJson: (data) => CreateActionResponse.fromJson(data),
        errorFromJson: (data) => ErrorResponse.fromJson(data));
    return apiResponse;
  }


}
