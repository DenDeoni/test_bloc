import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'utils/colors.dart';

ThemeData _defaultTheme = ThemeData.light();

ThemeData newTheme = _defaultTheme.copyWith(
  appBarTheme: AppBarTheme(
    titleSpacing: 10,
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.black54),
    textTheme: TextTheme(
      headline6: TextStyle(
        fontSize: 20,
        color: Colors.black54,
      ),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(
        Color(0xFF4FA5F5),
      ), //button color
      foregroundColor: MaterialStateProperty.all<Color>(
        Color(0xffffffff),
      ), //text (and icon)
    ),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: Color(0xFF4FA5F5),
  ),
  buttonColor: Color(0xFF4FA5F5),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedLabelStyle: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
    ),
    unselectedLabelStyle: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w400,
    ),
  ),
  cardTheme: CardTheme(
    color: Colors.deepOrange[100],
    clipBehavior: Clip.antiAliasWithSaveLayer,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    elevation: 5,
    margin: EdgeInsets.all(10),
  ),
  textTheme: _textLight(_defaultTheme.textTheme),
  indicatorColor: Colors.black54,
  accentColor: Color(0xFF4FA5F5),
  chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      labelPadding: EdgeInsets.only(right: 10, left: 10),
      elevation: 5,
      pressElevation: 10,
      showCheckmark: true,
      checkmarkColor: Colors.white,
      backgroundColor: Colors.transparent,
      disabledColor: Colors.transparent,
      selectedColor: AppColors.appBlue,
      secondarySelectedColor: Colors.deepOrange[100]!,
      padding: EdgeInsets.all(0),
      labelStyle: TextStyle(),
      secondaryLabelStyle: TextStyle(),
      brightness: Brightness.light),
  dialogBackgroundColor: Color(0x55FFFFFF),
);

TextTheme _textLight(TextTheme base) {
  return base.copyWith(
      headline5: base.headline5!.copyWith(
        color: Colors.deepOrange[100],
      ),
      bodyText2: base.bodyText2!.copyWith(
        color: Colors.black,
      ),
      headline4: base.headline4!.copyWith(
        fontSize: 50,
        fontWeight: FontWeight.w600,
      ));
}
