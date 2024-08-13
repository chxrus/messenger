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
    fontWeight: FontWeight.w600,
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
  dividerColor: Colors.grey[900]!,
  appBarTheme: AppBarTheme(
    elevation: 0,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.grey[900],
    centerTitle: true,
    titleTextStyle: textTheme.titleSmall?.copyWith(
      color: Colors.white,
    ),
    actionsIconTheme: const IconThemeData(
      color: Colors.white,
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
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
  dividerColor: Colors.indigo[100]!,
  appBarTheme: AppBarTheme(
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: true,
    titleTextStyle: textTheme.titleSmall?.copyWith(
      color: Colors.black,
    ),
    actionsIconTheme: const IconThemeData(
      color: Colors.black,
    ),
    iconTheme: const IconThemeData(
      color: Colors.black,
    ),
  ),
);
