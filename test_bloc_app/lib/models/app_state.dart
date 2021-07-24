import 'dart:ui';

import 'package:equatable/equatable.dart';

class AppState extends Equatable {
  final bool isUserAuthorized;
  Locale? locale;

  AppState(this.locale, {required this.isUserAuthorized});

  @override
  List<Object> get props => [isUserAuthorized, locale!];
}
