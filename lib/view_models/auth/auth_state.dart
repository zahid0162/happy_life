import 'package:equatable/equatable.dart';

import '../../models/auth/login_response.dart';

class AuthState extends Equatable {
  bool loading;
  bool googleLoading;
  bool appleLoading;
  String? name;
  String? dob;
  String? filePath;
  String? error;

  @override
  List<Object?> get props =>
      [loading, error, googleLoading, appleLoading, name,dob, filePath,error];

  AuthState copyWith({bool? loading,
    bool? googleLoading,
    bool? appleLoading,
    String? name,
    String? dob,
    String? filePath,
    String? error}) {
    return AuthState(
      loading: loading ?? this.loading,
      googleLoading: googleLoading ?? this.googleLoading,
      appleLoading: appleLoading ?? this.appleLoading,
      name: name ?? this.name,
      dob: dob ?? this.dob,
      filePath: filePath ?? this.filePath,
      error: error ?? this.error,
    );
  }

  AuthState({this.loading = false,
    this.googleLoading = false,
    this.appleLoading = false,
    this.name,
    this.dob,
    this.filePath,
    this.error});
}
