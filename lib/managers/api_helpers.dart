


import 'dart:async';
import 'dart:io';

import '../constants/app_constants.dart';

class ErrorHandler {
  static ApiError<E> handleError<E>(Exception error, {E? errorData}) {
    if (error is TimeoutException) {
      return ApiError<E>(
        type: ApiErrorType.timeoutError,
        message: AppConstants.requestTimeout,
        data: errorData, 
      );
    } else if (error is SocketException) {
      return ApiError<E>(
        type: ApiErrorType.networkError,
        message: AppConstants.noInternetConnection,
        data: errorData, 
      );
    } else if (error is HttpException) {
      return ApiError<E>(
        type: ApiErrorType.responseError,
        message: AppConstants.errorInResponse,
        data: errorData, 
      );
    } else {
      return ApiError<E>(
        type: ApiErrorType.unknownError,
        message: AppConstants.unknownErrorOccurred,
        data: errorData,
      );
    }
  }
}



enum ApiMethod {
  GET,
  POST,
  PUT,
  DELETE,
  PATCH,
}

enum ApiErrorType {
  networkError,
  timeoutError,
  responseError,
  unknownError,
}


class ApiResponse<T,E> {
  final T? data;
  final ApiError<E>? error;

  ApiResponse({this.data, this.error});
}

class ApiError<E> {
  final E? data;
  final ApiErrorType type;
  final String message;
  final int? statusCode;

  ApiError({required this.type,required this.message,this.statusCode,this.data});
}