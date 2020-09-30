import 'package:artsideout_app/constants/ColorConstants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData appTheme = buildTheme();

ThemeData buildTheme() {
  final ThemeData base = ThemeData.light();

  return base.copyWith(
      textTheme: _buildDefaultTextTheme(base.textTheme),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      primaryColor: ColorConstants.PRIMARY,
      scaffoldBackgroundColor: Colors.transparent);
}

TextTheme _buildDefaultTextTheme(TextTheme base) {
  return GoogleFonts.latoTextTheme(base).copyWith(
    headline2: GoogleFonts.lato(
        textStyle: base.headline2,
        fontWeight: FontWeight.w900,
        color: ColorConstants.PRIMARY),
    headline3: GoogleFonts.lato(
        textStyle: base.headline3,
        fontWeight: FontWeight.w900,
        color: ColorConstants.PRIMARY),
    headline4: GoogleFonts.lato(
        textStyle: base.headline4, fontWeight: FontWeight.w700),
    headline5: GoogleFonts.lato(
        textStyle: base.headline5,
        fontWeight: FontWeight.w700,
        color: ColorConstants.PRIMARY),
    headline6: GoogleFonts.lato(
      textStyle: base.headline6,
      color: Colors.white,
      fontWeight: FontWeight.w700,
      fontSize: 25.0,
    ),
    caption: GoogleFonts.lato(
      textStyle: base.caption,
      color: Colors.black,
      fontWeight: FontWeight.w700,
      fontSize: 18.0,
    ),
    bodyText1: GoogleFonts.lato(
      textStyle: base.bodyText1,
      fontWeight: FontWeight.w500,
      fontSize: 16.0,
    ),
  );
}
