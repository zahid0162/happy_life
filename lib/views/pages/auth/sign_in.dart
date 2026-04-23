import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_happy_work_place/constants/app_constants.dart';
import 'package:my_happy_work_place/constants/spacing.dart';
import 'package:my_happy_work_place/utils/extensions.dart';

import '../../../constants/app_icons.dart';
import '../../../constants/app_routes.dart';
import '../../../constants/color_constants.dart';
import '../../../utils/app_router.dart';
import '../../../utils/injectors.dart';
import '../../../utils/utils.dart';
import '../../../view_models/auth/auth_events.dart';
import '../../../view_models/auth/auth_state.dart';
import '../../../view_models/auth/auth_view_model.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_loader.dart';
import '../../widgets/custom_text.dart';
import '../../widgets/custom_textfield.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> signInEnabled = ValueNotifier(false);
  bool obscurePassword = true;
  bool validEmail = true;
  bool validPassword = true;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: Spacing.medium),
        child: _footerView(),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                vertical: Spacing.normal, horizontal: Spacing.standard),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _headerView(),
                _emailPasswordView(),
                _buttonsView(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _footerView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomText(
          text: AppConstants.doNotHaveAccount,
          textColor: ColorConstants.lightText,
          size: AppConstants.font14Px,
          weight: FontWeight.w400,
        ),
        GestureDetector(
          onTap: _moveToSignUp,
          child: CustomText(
            text: AppConstants.signup,
            textColor: ColorConstants.primary,
            size: AppConstants.font14Px,
            weight: FontWeight.w400,
          ),
        )
      ],
    );
  }

  Container _headerView() {
    return Container(
      margin: const EdgeInsets.only(top: Spacing.xxxxlarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: AppConstants.login,
            size: AppConstants.font25Px,
            weight: FontWeight.w600,
            align: TextAlign.start,
          ),
          const SizedBox(
            height: Spacing.normal,
          ),
          CustomText(
            text: AppConstants.loginToContinue,
            align: TextAlign.start,
            weight: FontWeight.w400,
            size: AppConstants.font14Px,
            textColor: ColorConstants.lightText,
          ),
        ],
      ),
    );
  }

  Container _emailPasswordView() {
    return Container(
      margin: const EdgeInsets.only(top: Spacing.xxxxlarge + Spacing.normal),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            StatefulBuilder(builder: (context, state) {
              return Container(
                  padding: EdgeInsets.only(
                      bottom: validEmail ? Spacing.zero : Spacing.regular),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                  ),
                  child: CustomTextField(
                    label: AppConstants.email,
                    inputType: TextInputType.emailAddress,
                    contentPadding: const EdgeInsets.all(Spacing.xxlarge),
                    errorHeight: 0.6,

                    onValidate: (String? text) {
                      if (text == null || text.isEmpty) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          validEmail = false;
                          state(() {});
                        });
                        return AppConstants.emailCannotBeEmpty;
                      } else if (!text.isValidEmail()) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          validEmail = false;
                          state(() {});
                        });
                        return AppConstants.pleaseEnterValidEmail;
                      }
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        validEmail = true;
                        state(() {});
                      });

                      return null;
                    },
                    borderSide:
                        BorderSide(color: ColorConstants.borderColor, width: 1),
                    hint: AppConstants.emailAddress,
                    hintWeight: FontWeight.w500,
                    textEditingController: _emailController,
                    filledColor: Colors.white,
                  ));
            }),
            const SizedBox(
              height: Spacing.xlarge,
            ),
            StatefulBuilder(builder: (context, state) {
              return Container(
                  padding: EdgeInsets.only(
                      bottom: validPassword ? Spacing.zero : Spacing.regular),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                  ),
                  child: CustomTextField(
                      label: AppConstants.password,
                      autovalidateMode: autovalidateMode,
                      contentPadding: const EdgeInsets.all(Spacing.xxlarge),
                      errorHeight: 0.6,
                      suffixIcon: GestureDetector(
                        onTap: () {
                          obscurePassword = !obscurePassword;
                          state(() {});
                        },
                        behavior: HitTestBehavior.translucent,
                        child: Padding(
                          padding: const EdgeInsets.all(Spacing.medium),
                          child: obscurePassword
                              ? SvgPicture.asset(AppIcons.eyeHidden)
                              : SvgPicture.asset(AppIcons.eyeVisible),
                        ),
                      ),
                      obscure: obscurePassword,

                      onValidate: (text) {
                        if (text == null || text.isEmpty) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            validPassword = false;
                            state(() {});
                          });
                          return AppConstants.passwordCannotBeEmpty;
                        }
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          validPassword = true;
                          state(() {});
                        });
                        return null;
                      },
                      borderSide: null,
                      hint: "Enter Password",
                      hintWeight: FontWeight.w500,
                      textEditingController: _passwordController,
                      filledColor: Colors.white));
            }),
          ],
        ),
      ),
    );
  }

  Container _buttonsView() {
    return Container(
      margin: const EdgeInsets.only(top: Spacing.xxlarge * 2),
      child: Column(
        children: [
          BlocBuilder<AuthViewModel, AuthState>(builder: (context, authState) {
            return CustomButton(
              title: AppConstants.login,
              loading: authState.loading,
              onTap:(){
                FocusManager.instance.primaryFocus?.unfocus();
                _onLogin();
              },
              textSize: AppConstants.font16Px,
              weight: FontWeight.w500,
              radius: AppConstants.defaultButtonRadius,
            );
          }),
          const SizedBox(
            height: Spacing.xxlarge,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CustomText(
                text: AppConstants.or,
                textColor: ColorConstants.lightText,
                weight: FontWeight.w400,
                size: AppConstants.font14Px,
              ),
            ],
          ),
          const SizedBox(
            height: Spacing.xxlarge,
          ),
          BlocBuilder<AuthViewModel, AuthState>(builder: (context, authState) {
            return GestureDetector(
              onTap: _onGoogleSignIn,
              behavior: HitTestBehavior.translucent,
              child: Container(
                height: 50.h,
                decoration: BoxDecoration(
                  color: ColorConstants.buttonSecondary,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: authState.googleLoading
                    ? const Center(
                        child: CustomLoader(
                          color: ColorConstants.darkText,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(AppIcons.google),
                          const SizedBox(
                            width: Spacing.large,
                          ),
                          const CustomText(
                            text: AppConstants.continueWithGoogle,
                            weight: FontWeight.w400,
                            size: AppConstants.font16Px,
                          )
                        ],
                      ),
              ),
            );
          }),
          const SizedBox(
            height: Spacing.xxlarge,
          ),
          if (Platform.isIOS)
            BlocBuilder<AuthViewModel, AuthState>(
                builder: (context, authState) {
              return GestureDetector(
                onTap: _onAppleSignIn,
                behavior: HitTestBehavior.translucent,
                child: Container(
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: ColorConstants.buttonSecondary,
                    shape: BoxShape.rectangle,
                    borderRadius:
                        BorderRadius.circular(AppConstants.textFieldRadius),
                  ),
                  child: authState.appleLoading
                      ? const Center(
                          child: CustomLoader(
                            color: ColorConstants.darkText,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(AppIcons.apple),
                            const SizedBox(
                              width: Spacing.standard,
                            ),
                            const CustomText(
                              text: AppConstants.continueWithApple,
                              weight: FontWeight.w400,
                              size: AppConstants.font16Px,
                            )
                          ],
                        ),
                ),
              );
            }),
        ],
      ),
    );
  }

  void _onGoogleSignIn() {
    getIt<AuthViewModel>()
        .add(GoogleSignIn(onSuccess: ({required bool isProfileCompleted}) {
      Utils.showSnackBar(
          message: AppConstants.loginSuccessfully, context: context);
      isProfileCompleted
          ? AppRouter.pushNamedRemoveUntil(
              context: context, route: AppRoutes.homeScreen)
          : AppRouter.pushNamedRemoveUntil(
              context: context, route: AppRoutes.profileInfo);
    }, onError: ({required String error}) {
      Utils.showSnackBar(message: error, context: context);
    }));
  }

  void _onAppleSignIn() {
    getIt<AuthViewModel>()
        .add(AppleSignIn(onSuccess: ({required bool isProfileCompleted}) {
      Utils.showSnackBar(
          message: AppConstants.loginSuccessfully, context: context);
      isProfileCompleted
          ? AppRouter.pushNamedRemoveUntil(
              context: context, route: AppRoutes.homeScreen)
          : AppRouter.pushNamedRemoveUntil(
              context: context, route: AppRoutes.profileInfo);
    }, onError: ({required String error}) {
      Utils.showSnackBar(message: error, context: context);
    }));
  }

  void _onLogin() {
    autovalidateMode = AutovalidateMode.onUserInteraction;
    if (_formKey.currentState!.validate()) {
      getIt<AuthViewModel>().add(LoginEvent(
        email: _emailController.text,
        password: _passwordController.text,
        onSuccess: ({required bool isProfileCompleted}) {
          Utils.showSnackBar(
              message: AppConstants.loginSuccessfully, context: context);
          isProfileCompleted ? AppRouter.pushNamedRemoveUntil(
              context: context, route: AppRoutes.homeScreen) : AppRouter.pushNamedRemoveUntil(
              context: context, route: AppRoutes.profileInfo);
        },
        onError: ({required String error}) {
          Utils.showSnackBar(message: error, context: context);
        },
      ));
    }
  }

  void _moveToSignUp() {
    AppRouter.pushNamedRemoveUntil(
      context: context,
      route: AppRoutes.signUp,
    );
  }
}
