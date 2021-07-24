import 'dart:ui';

import 'package:test_bloc_app/models/app_state.dart';
import 'package:test_bloc_app/redux/actions.dart';
import 'package:intl/intl.dart';

AppState appStateReducers(AppState state, dynamic action) {
  return isUserAuthorized(state.isUserAuthorized, UserLoginAction(state.isUserAuthorized));
}

AppState isUserAuthorized(bool isUserAuthorized, UserLoginAction action) {
  // print('REDUCER isUserAuthorized 1: $isUserAuthorized');
  return AppState(null, isUserAuthorized: true);
}

AppState isUserLogout(bool isUserAuthorized, UserLogout action) {
  // print('REDUCER isUserAuthorized 2: $isUserAuthorized');
  return AppState(null, isUserAuthorized: false);
}

AppState fetchUserStatus(bool isUserAuthorized, FetchUserStatus action) {
  // print('REDUCER isUserAuthorized 3: $isUserAuthorized');
  return AppState(
    null,
    isUserAuthorized: isUserAuthorized,
  );
}

AppState changeLocale(bool isUserAuthorized, Locale locale, LocaleChanged action) {
  // print('REDUCER locale $locale');
  return AppState(
    locale,
    isUserAuthorized: isUserAuthorized,
  );
}
