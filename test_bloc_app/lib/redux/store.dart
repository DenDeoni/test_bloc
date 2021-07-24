import 'package:easy_localization/easy_localization.dart';
import 'package:test_bloc_app/utils/consts.dart';
import 'package:intl/intl.dart';
import 'dart:ui';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_bloc_app/models/app_state.dart';
import 'package:test_bloc_app/redux/prefs_middleware.dart';
import 'package:test_bloc_app/redux/reducer.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';

Future<Store<AppState>> createReduxStore() async {
  final _prefs = await SharedPreferences.getInstance();
  final isUserAuthorized = _prefs.getBool(IS_USER_LOGGED) ?? false;
  // первичная установка языка приложения

  //print('STORE LOCALE: $_loc');
  print('STORE LOGIN: $isUserAuthorized');
  return Store<AppState>(
    appStateReducers,
    initialState: AppState(null, isUserAuthorized: isUserAuthorized),
    middleware: [
      PrefsMiddleware(_prefs),
    ],
  );
}
