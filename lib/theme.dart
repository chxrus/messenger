import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const seedColor = Colors.indigo;
const primaryColor = Colors.indigo;

final textTheme = TextTheme(
  titleMedium: GoogleFonts.raleway(
    fontSize: 24,
  ),
  titleSmall: GoogleFonts.raleway(
    fontSize: 20,
  ),
  labelMedium: GoogleFonts.roboto(
    fontSize: 18,
    fontWeight: FontWeight.w400,
  ),
  labelSmall: GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  ),
);

final darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: Brightness.dark,
  ),
  primaryColor: primaryColor,
  textTheme: textTheme,
  appBarTheme: AppBarTheme(
    elevation: 0,
    scrolledUnderElevation: 0,
    foregroundColor: Colors.black,
    backgroundColor: Colors.transparent,
    centerTitle: true,
    titleTextStyle: textTheme.titleSmall?.copyWith(
      color: Colors.white70,
    ),
    actionsIconTheme: const IconThemeData(
      color: Colors.white70,
    ),
    iconTheme: const IconThemeData(
      color: Colors.white70,
    ),
  ),
);

final lightTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: seedColor,
    brightness: Brightness.light,
  ),
  primaryColor: primaryColor,
  textTheme: textTheme,
  appBarTheme: AppBarTheme(
    elevation: 0,
    scrolledUnderElevation: 0,
    foregroundColor: Colors.white,
    backgroundColor: Colors.transparent,
    centerTitle: true,
    titleTextStyle: textTheme.titleSmall?.copyWith(
      color: Colors.black87,
    ),
    actionsIconTheme: const IconThemeData(
      color: Colors.black87,
    ),
    iconTheme: const IconThemeData(
      color: Colors.black87,
    ),
  ),
);
