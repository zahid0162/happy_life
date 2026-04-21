import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/cupertino.dart';

import '../constants/app_routes.dart';
import '../main.dart';
import '../utils/app_router.dart';

class AppLinksDeepLink {
  AppLinksDeepLink._privateConstructor();

  static final AppLinksDeepLink _instance =
      AppLinksDeepLink._privateConstructor();

  static AppLinksDeepLink get instance => _instance;

  StreamSubscription<Uri>? _linkSubscription;

  final AppLinks appLinks = AppLinks();

  Future<Uri?> getInitialLink() async {
    final link = await appLinks.getInitialLink();
    return link;
  }

  Future<void> initDeepLinks() async {
    _linkSubscription = appLinks.uriLinkStream.listen(
      (uriValue) {
        String? token = uriValue.queryParameters["token"];
        if (token != null && navigatorKey.currentContext != null) {
          AppRouter.pushReplaceNamed(
              context: navigatorKey.currentContext!,
              route: AppRoutes.resetPassword,
              arguments: token);
        }
      },
      onError: (err) {
        debugPrint('====>>> error : $err');
      },
      onDone: () {
        _linkSubscription?.cancel();
      },
    );
  }
}
