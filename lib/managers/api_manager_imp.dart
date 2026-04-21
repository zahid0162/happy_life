import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import '../constants/api_endpoints.dart';
import 'api_helpers.dart';
import 'api_manager.dart';

class ApiManagerImpl extends ApiManager {
  @override
  Future<ApiResponse<T, E>> callApi<T, E>({
    required String url,
    required ApiMethod method,
    bool encodeUri = false,
    Map<String, String>? headers,
    Map<dynamic, dynamic>? body,
    Map<String, dynamic>? queryParameters, // Added query parameters
    required T Function(Map<String, dynamic>) responseFromJson,
    required E Function(Map<String, dynamic>) errorFromJson,
  }) async {
    try {
      // Build the full URL with query parameters

      String finalUrl;

      if (encodeUri) {
        finalUrl = Uri.encodeFull(ApiEndpoints.baseUrl + url);
      } else {
        finalUrl = ApiEndpoints.baseUrl + url;
      }

      Uri uri = Uri.parse(finalUrl);

      if (queryParameters != null && queryParameters.isNotEmpty) {
        uri = uri.replace(
            queryParameters: queryParameters.map(
          (key, value) => MapEntry(key, value.toString()),
        ));
      }

      http.Response response;

      switch (method) {
        case ApiMethod.GET:
          response = await http.get(uri, headers: headers);
          break;
        case ApiMethod.POST:
          if (kDebugMode) {
            print("body ${body}");
          }
          response = await http.post(uri, headers: headers, body: jsonEncode(body));
          break;
        case ApiMethod.PUT:
          response = await http.put(uri, headers: headers, body: jsonEncode(body));
          break;
        case ApiMethod.DELETE:
          response = await http.delete(uri, headers: headers);
          break;
        case ApiMethod.PATCH:
          response = await http.patch(uri, headers: headers, body: jsonEncode(body));
          break;
        default:
          throw UnsupportedError("Unsupported HTTP method");
      }

      // Handle response parsing
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse<T, E>(
            data: responseFromJson(json.decode(response.body)));
      } else {
        return ApiResponse<T, E>(
          error: ApiError<E>(
              type: ApiErrorType.responseError,
              message: "${jsonDecode(response.body)['message'] ?? "unknown error, please try again"}",
              statusCode: response.statusCode,
              data: errorFromJson(jsonDecode(response.body))),
        );
      }
    } on Exception catch (e) {
      return ApiResponse<T, E>(error: ErrorHandler.handleError(e));
    }
  }

  @override
  Future<ApiResponse<T, E>> callApiMultipart<T, E>(
      {required String url,
      bool encodeUri = false,
      Map<String, String>? headers,
      Map<String, String>? body,
      File? file,
      required T Function(Map<String, dynamic> p1) responseFromJson,
      required E Function(Map<String, dynamic> p1) errorFromJson}) async {
    try {
      // Build the full URL with query parameters

      String finalUrl;
      if (encodeUri) {
        finalUrl = Uri.encodeFull(ApiEndpoints.baseUrl + url);
      } else {
        finalUrl = ApiEndpoints.baseUrl + url;
      }

      Uri uri = Uri.parse(finalUrl);

      final request = http.MultipartRequest('PUT', uri);
      if (body != null) {
        request.fields.addAll(body);
      }
      if(headers!=null){
        request.headers.addAll(headers);
      }


      if (file != null) {
        final fileStream = http.MultipartFile(
          'image', // Key for the file in the API
          file!.readAsBytes().asStream(),
          file!.lengthSync(),
          filename: basename(file!.path),
        );
        request.files.add(fileStream);
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      // Handle response parsing
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse<T, E>(
            data: responseFromJson(json.decode(responseBody)));
      } else {
        return ApiResponse<T, E>(
          error: ApiError<E>(
              type: ApiErrorType.responseError,
              message: "Error: ${response.statusCode}",
              statusCode: response.statusCode,
              data: errorFromJson(jsonDecode(responseBody))),
        );
      }
    } on Exception catch (e) {
      return ApiResponse<T, E>(error: ErrorHandler.handleError(e));
    }
  }
}
