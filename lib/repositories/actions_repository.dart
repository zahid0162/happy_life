import 'package:msal_auth/msal_auth.dart';
import 'package:my_happy_work_place/models/dashboard/action.dart';
import 'package:my_happy_work_place/models/goals/action_progress.dart';
import 'package:my_happy_work_place/models/goals/goal_detail.dart';

import '../constants/api_endpoints.dart';
import '../managers/api_helpers.dart';
import '../managers/api_manager.dart';
import '../models/dashboard/category.dart';
import '../models/error_response.dart';
import '../models/goals/category_with_goals_response.dart';
import '../utils/preference_helper.dart';

class ActionsRepository {
  final ApiManager apiManager;

  ActionsRepository({required this.apiManager});

  Future<ApiResponse<CreateActionResponse, ErrorResponse>> createNewAction(
      GoalAction action) async {
    final token = await SharedPreferencesHelper.getToken();
    final Map<String, String> headerMap = {};
    headerMap['Authorization'] = "Bearer $token";
    ApiResponse<CreateActionResponse, ErrorResponse> apiResponse =
        await apiManager.callApi(
            url: "${ApiEndpoints.createAction}${action.goalId}/action/create",
            method: ApiMethod.POST,
            headers: headerMap,
            body: action.toJson(),
            responseFromJson: (data) => CreateActionResponse.fromJson(data),
            errorFromJson: (data) => ErrorResponse.fromJson(data));
    return apiResponse;
  }

  Future<ApiResponse<MainActionResponse, ErrorResponse>> getActionProgresses(
      String date) async {
    final token = await SharedPreferencesHelper.getToken();
    final Map<String, String> headerMap = {};
    headerMap['Authorization'] = "Bearer $token";
    final Map<String, String> queryMap = {};
    queryMap['date'] = date;
    ApiResponse<MainActionResponse, ErrorResponse> apiResponse =
        await apiManager.callApi(
            url: ApiEndpoints.getActions,
            method: ApiMethod.GET,
            headers: headerMap,
            queryParameters: queryMap,
            responseFromJson: (data) => MainActionResponse.fromJson(data),
            errorFromJson: (data) => ErrorResponse.fromJson(data));
    return apiResponse;
  }

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

}
