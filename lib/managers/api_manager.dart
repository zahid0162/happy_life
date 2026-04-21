


import 'dart:io';

import 'api_helpers.dart';

abstract class ApiManager {
  Future<ApiResponse<T,E >> callApi<T,E>({
    required String url,
    required ApiMethod method,
    bool encodeUri = false ,
    Map<String, String>? headers,
    Map<dynamic, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    required T Function(Map<String, dynamic>) responseFromJson,
    required E Function(Map<String, dynamic>) errorFromJson,
  });

  Future<ApiResponse<T,E >> callApiMultipart<T,E>({
    required String url,
    bool encodeUri = false ,
    Map<String, String>? headers,
    Map<String, String>? body,
    File? file,
    required T Function(Map<String, dynamic>) responseFromJson,
    required E Function(Map<String, dynamic>) errorFromJson,
  });
}

