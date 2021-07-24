import 'dart:ui';

import 'package:equatable/equatable.dart';

class UserLoginAction extends Equatable {
  final bool isUserAuthorized;
  UserLoginAction(this.isUserAuthorized);

  @override
  List<Object> get props => [isUserAuthorized];
}

class FetchUserStatus extends Equatable {
  @override
  List<Object> get props => [];
}

class UserLogout extends Equatable {
  final bool isUserAuthorized;
  UserLogout(this.isUserAuthorized);

  @override
  List<Object?> get props => [isUserAuthorized];
}

class LocaleChanged extends Equatable {
  final Locale locale;
  LocaleChanged(this.locale);
  @override
  List<Object?> get props => [locale];
}
class FetchLocale extends Equatable {
  @override
  List<Object> get props => [];
}

