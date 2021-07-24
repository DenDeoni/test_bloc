import 'dart:async';
import 'dart:ui';
import 'package:test_bloc_app/models/app_state.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_bloc_app/utils/consts.dart';
import 'actions.dart';

class PrefsMiddleware extends MiddlewareClass<AppState> {
  final SharedPreferences preferences;

  PrefsMiddleware(this.preferences);

  @override
  Future<void> call(Store<AppState> store, action, NextDispatcher next) async {
    next(action); // this first!

    if (action is UserLoginAction) {
      await _saveStateToPrefs(store.state);
    }

    if (action is FetchUserStatus) {
      _loadUserStateFromPrefs(store);
    }
    if (action is UserLogout) {
      await _saveStateToPrefs(store.state);
    }
    if (action is FetchLocale) {
      _loadLocaleFromPrefs(store);
    }
    if (action is LocaleChanged) {
      await _saveLocaleToPrefs(store.state);
    }
  }

  Future<void> _saveStateToPrefs(AppState state) async {
    bool isUserAuthorized = state.isUserAuthorized;
    print('isUserAuthorized to prefs" $isUserAuthorized');
    await preferences.setBool(IS_USER_LOGGED, isUserAuthorized);
  }

  void _loadUserStateFromPrefs(Store<AppState> store) {
    bool isUserAuthorized = preferences.getBool(IS_USER_LOGGED) ?? false;
    print('IS_USER_LOGGED from prefs: $isUserAuthorized');
    store.dispatch(isUserAuthorized); // ????????
  }

  Future<void> _saveLocaleToPrefs(AppState state) async {
    String locale = state.locale.toString();
    state.locale = Locale(locale);
    print('Locale to Prefs" $locale');
    await preferences.setString(LANGUAGE_CODE, locale);
  }

  void _loadLocaleFromPrefs(Store<AppState> store) {
    Locale locale = Locale(preferences.getString(LANGUAGE_CODE)!);
    print('Locale from Prefs" $locale');
    store.dispatch(AppState(locale, isUserAuthorized: false));
  }
}
