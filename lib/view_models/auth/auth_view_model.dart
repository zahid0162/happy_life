import 'dart:async';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:my_happy_work_place/models/dashboard/user_profile.dart';
import 'package:my_happy_work_place/utils/preference_helper.dart';
import '../../models/auth/forgot_password.dart';
import '../../models/auth/login_form.dart';
import '../../models/auth/reset_password.dart';
import '../../repositories/auth_repository.dart';
import 'auth_events.dart';
import 'auth_state.dart';

class AuthViewModel extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthViewModel({required this.authRepository}) : super(AuthState()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_register);
    on<ForgotPasswordEvent>(_onForgotPassword);
    on<CompleteProfileEvent>(uploadProfile);
    on<InitialProfileInfo>(initialProfile);
    on<ResetPasswordEvent>(_onResetPassword);
    on<GoogleSignIn>(_onGoogleSignIn);
    on<AppleSignIn>(_onAppleSignIn);
  }

  FutureOr<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(loading: true));
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    LoginForm loginForm = LoginForm(
        email: event.email,
        password: event.password,
        tz: currentTimeZone,
        appPlatform: Platform.isAndroid ? 'android' : 'ios',
        fcmToken: await SharedPreferencesHelper.getFcmToken());
    final authResponse = await authRepository.login(loginForm: loginForm);

    if (authResponse.data != null) {
      SharedPreferencesHelper.saveToken(
          authResponse.data!.data.authorizationToken);
      SharedPreferencesHelper.saveUser(authResponse.data!.data.user);
      if (authResponse.data?.data.user.imageKey?.isNotEmpty == true) {
        SharedPreferencesHelper.saveLoginStatus(true);
      }
      event.onSuccess(
          isProfileCompleted:
              authResponse.data!.data.user.imageKey?.isNotEmpty == true);
    } else {
      if (authResponse.error?.data != null) {
        event.onError(error: authResponse.error?.data?.error ?? "");
        emit(state.copyWith(
            loading: false, error: authResponse.error?.data?.error ?? ""));
      } else {
        event.onError(error: authResponse.error?.message ?? "");
        emit(
            state.copyWith(loading: false, error: authResponse.error?.message));
      }
    }
  }

  FutureOr<void> _register(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(loading: true));
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    LoginForm loginForm = LoginForm(
        email: event.email,
        password: event.password,
        tz: currentTimeZone,
        appPlatform: Platform.isAndroid ? 'android' : 'ios',
        fcmToken: await SharedPreferencesHelper.getFcmToken());
    final authResponse = await authRepository.register(loginForm: loginForm);

    if (authResponse.data != null) {
      SharedPreferencesHelper.saveToken(
          authResponse.data!.data.authorizationToken);
      SharedPreferencesHelper.saveUser(authResponse.data!.data.user);
      emit(state.copyWith(loading: true));
      if (authResponse.data?.data.user.imageKey?.isNotEmpty == true) {
        SharedPreferencesHelper.saveLoginStatus(true);
      }
      event.onSuccess(
          isProfileCompleted:
              authResponse.data?.data.user.imageKey?.isNotEmpty == true);
    } else {
      if (authResponse.error?.data != null) {
        event.onError(error: authResponse.error?.data?.error ?? "");
        emit(state.copyWith(
            loading: false, error: authResponse.error?.data?.error ?? ""));
      } else {
        event.onError(error: authResponse.error?.message ?? "");
        emit(
            state.copyWith(loading: false, error: authResponse.error?.message));
      }
    }
  }

  FutureOr<void> _onForgotPassword(
      ForgotPasswordEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(loading: true));
    ForgotPasswordForm forgotPasswordForm =
        ForgotPasswordForm(emailAddress: event.email);
    final forgotPasswordResponse = await authRepository.forgotPassword(
        forgotPasswordForm: forgotPasswordForm);

    if (forgotPasswordResponse.data != null) {
      emit(state.copyWith(loading: false));
      event.onSuccess();
    } else {
      if (forgotPasswordResponse.error?.data != null) {
        event.onError(error: forgotPasswordResponse.error?.data?.message ?? "");
        emit(state.copyWith(
            loading: false,
            error: forgotPasswordResponse.error?.data?.message ?? ""));
      } else {
        event.onError(error: forgotPasswordResponse.error?.message);
        emit(state.copyWith(
            loading: false, error: forgotPasswordResponse.error?.message));
      }
    }
  }

  Future<void> _onResetPassword(
      ResetPasswordEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(loading: true));
    ResetPasswordForm resetPasswordForm = ResetPasswordForm(
        password: event.password, passwordConfirmation: event.confirmPassword);

    final resetPasswordResponse = await authRepository.resetPassword(
        resetPasswordForm: resetPasswordForm, resetToken: event.token);

    if (resetPasswordResponse.data != null) {
      emit(state.copyWith(loading: false));
      event.onSuccess();
    } else {
      event.onError(error: resetPasswordResponse.error?.data?.message ?? "");
      emit(state.copyWith(loading: false));
    }
  }

  void initialProfile(InitialProfileInfo event, Emitter<AuthState> emit) {
    state.name = event.name;
    state.dob = event.dob;
    state.filePath = event.filePath;
    emit(state.copyWith(loading: false));
  }

  Future<void> uploadProfile(
      CompleteProfileEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(loading: true));
    CompleteProfileForm completeProfileForm = CompleteProfileForm(
        name: state.name!,
        number: event.number,
        country: event.country,
        city: event.city,
        gender: event.gender,
        dob: state.dob!,
        file: state.filePath != null ? File(state.filePath!) : null);
    final profileResponse =
        await authRepository.uploadProfile(loginForm: completeProfileForm);
    if (profileResponse.data != null) {
      emit(state.copyWith(loading: false));
      SharedPreferencesHelper.saveLoginStatus(true);
      SharedPreferencesHelper.saveUser(profileResponse.data!.data);
      event.onSuccess();
    } else {
      event.onError(error: profileResponse.error?.data?.error ?? "");
      emit(state.copyWith(loading: false));
    }
  }

  FutureOr<void> _onGoogleSignIn(
      GoogleSignIn event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(googleLoading: true));
      String? accessToken = await authRepository.googleAuth();
      if (accessToken == null) return;
      final authResponse = await authRepository.googleLogin(token: accessToken);
      if (authResponse.data != null) {
        if (authResponse.data?.data.user.imageKey != null) {
          SharedPreferencesHelper.saveLoginStatus(true);
        }
        SharedPreferencesHelper.saveUser(authResponse.data!.data.user);
        SharedPreferencesHelper.saveToken(
            authResponse.data!.data.authorizationToken);
        event.onSuccess(
            isProfileCompleted:
                authResponse.data?.data.user.imageKey?.isNotEmpty == true);
      } else {
        if (authResponse.error != null && authResponse.error!.data != null) {
          event.onError(error: authResponse.error!.data!.error);
        } else {
          event.onError(error: authResponse.error!.message);
        }
      }
      emit(state.copyWith(googleLoading: false));
    } catch (e, st) {
      emit(state.copyWith(googleLoading: false));
      event.onError(error: e.toString());
    } finally {
      emit(state.copyWith(googleLoading: false));
    }
  }

  FutureOr<void> _onAppleSignIn(
      AppleSignIn event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(appleLoading: true));
      String? accessToken = await authRepository.appleAuth();
      if (accessToken == null) return;
      final authResponse = await authRepository.appleLogin(token: accessToken);
      if (authResponse.data != null) {
        if (authResponse.data?.data.user.imageKey?.isNotEmpty == true) {
          SharedPreferencesHelper.saveLoginStatus(true);
        }
        SharedPreferencesHelper.saveUser(authResponse.data!.data.user);
        SharedPreferencesHelper.saveToken(
            authResponse.data!.data.authorizationToken);
        event.onSuccess(
            isProfileCompleted:
                authResponse.data?.data.user.imageKey?.isNotEmpty == true);
      } else {
        if (authResponse.error != null && authResponse.error!.data != null) {
          event.onError(error: authResponse.error!.data!.error);
        } else {
          event.onError(error: authResponse.error!.message);
        }
      }
      emit(state.copyWith(appleLoading: false));
    } catch (e, st) {
      emit(state.copyWith(appleLoading: false));
      event.onError(error: e.toString());
    } finally {
      emit(state.copyWith(appleLoading: false));
    }
  }
}
