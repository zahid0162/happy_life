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

class CalendarRepository {
  final ApiManager apiManager;

  CalendarRepository({required this.apiManager});

  Future<ApiResponse<SuccessResponse, ErrorResponse>> saveCalendarToken(
      String token) async {
    final userToken = await SharedPreferencesHelper.getToken();
    final Map<String, String> headerMap = {};
    headerMap['Authorization'] = "Bearer $userToken";
    final Map<String, dynamic> bodyMap = {'calendarToken': token};
    ApiResponse<SuccessResponse, ErrorResponse> apiResponse =
    await apiManager.callApi(
        url: ApiEndpoints.saveCalendarToken,
        method: ApiMethod.POST,
        body: bodyMap,
        headers: headerMap,
        responseFromJson: (data) => SuccessResponse.fromJson(data),
        errorFromJson: (data) => ErrorResponse.fromJson(data));
    return apiResponse;
  }

  Future<String?> connectOutlookCalendar() async {
    final msalAuth = await SingleAccountPca.create(
      clientId: '8478d979-a2c6-488e-bae1-46c6717e0f56',
      androidConfig: AndroidConfig(
        configFilePath: 'assets/msal_config.json',
        redirectUri: 'msauth://com.my.Happy/hyOO%2FXSiCQvGcPDoA8%2F2xATQZi8%3D',
      ),
      appleConfig: AppleConfig(
        authorityType: AuthorityType.aad,
        broker: Broker.msAuthenticator,
      ),
    );
    final authResult = await msalAuth.acquireToken(
      scopes: <String>[
        'https://graph.microsoft.com/user.read',
        'https://graph.microsoft.com/calendars.read',
        'https://graph.microsoft.com/calendars.readwrite',
      ],
      prompt: Prompt.consent,
    );
    await SharedPreferencesHelper.saveOutlookStatus(
        authResult.accessToken.isNotEmpty);
    return authResult.accessToken;
  }

  Future<String?> refreshCalendarToken() async {
    final msalAuth = await SingleAccountPca.create(
      clientId: '8478d979-a2c6-488e-bae1-46c6717e0f56',
      androidConfig: AndroidConfig(
        configFilePath: 'assets/msal_config.json',
        redirectUri: 'msauth://com.my.Happy/hyOO%2FXSiCQvGcPDoA8%2F2xATQZi8%3D',
      ),
      appleConfig: AppleConfig(
        authorityType: AuthorityType.aad,
        broker: Broker.msAuthenticator,
      ),
    );
    try{
      final authResult = await msalAuth.acquireTokenSilent(
        scopes: <String>[
          'https://graph.microsoft.com/user.read',
          'https://graph.microsoft.com/calendars.read',
          'https://graph.microsoft.com/calendars.readwrite',
        ],
      );
      await SharedPreferencesHelper.saveOutlookStatus(
          authResult.accessToken.isNotEmpty);
      return authResult.accessToken;

    } on MsalException catch (e){
      return await connectOutlookCalendar();
    }
  }

  Future<bool> signOut() async {
    final msalAuth = await SingleAccountPca.create(
      clientId: '8478d979-a2c6-488e-bae1-46c6717e0f56',
      androidConfig: AndroidConfig(
        configFilePath: 'assets/msal_config.json',
        redirectUri: 'msauth://com.my.Happy/hyOO%2FXSiCQvGcPDoA8%2F2xATQZi8%3D',
      ),
      appleConfig: AppleConfig(
        authorityType: AuthorityType.aad,
        broker: Broker.msAuthenticator,
      ),
    );
    return await msalAuth.signOut();
  }

  Future<Account> getConnectedEmail()async{
    final msalAuth = await SingleAccountPca.create(
      clientId: '8478d979-a2c6-488e-bae1-46c6717e0f56',
      androidConfig: AndroidConfig(
        configFilePath: 'assets/msal_config.json',
        redirectUri: 'msauth://com.my.Happy/hyOO%2FXSiCQvGcPDoA8%2F2xATQZi8%3D',
      ),
      appleConfig: AppleConfig(
        authorityType: AuthorityType.aad,
        broker: Broker.msAuthenticator,
      ),
    );
    return await msalAuth.currentAccount;
  }
}
