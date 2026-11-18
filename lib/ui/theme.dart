import 'package:flutter/material.dart';

const kAccent = Color(0xFF1F3A5F);
const kBackground = Color(0xFFF4F4F1);
const kBorder = Color(0xFFCFCFC8);
const kText = Color(0xFF1A1A1A);

OutlineInputBorder _border([Color color = kBorder]) => OutlineInputBorder(
  borderSide: BorderSide(color: color),
  borderRadius: BorderRadius.circular(6),
);

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme.light(
    primary: kAccent,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFDDE5F0),
    onPrimaryContainer: kAccent,
    secondary: kAccent,
    secondaryContainer: Color(0xFFDDE5F0),
    onSecondaryContainer: kAccent,
    surface: Colors.white,
    onSurface: kText,
    surfaceContainerHighest: Color(0xFFEDEDE8),
    surfaceContainerHigh: Color(0xFFF1F1EC),
    surfaceContainer: Color(0xFFF4F4F1),
    outline: Color(0xFF8A8A84),
    outlineVariant: kBorder,
    error: Color(0xFFB3261E),
  ),
  scaffoldBackgroundColor: kBackground,
  appBarTheme: const AppBarTheme(
    backgroundColor: kBackground,
    foregroundColor: kText,
    elevation: 0,
    scrolledUnderElevation: 0,
    surfaceTintColor: Colors.transparent,
    titleTextStyle: TextStyle(
      color: kText,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    errorMaxLines: 3,
    errorStyle: const TextStyle(fontSize: 13, color: Color(0xFFB3261E)),
    border: _border(),
    enabledBorder: _border(),
    focusedBorder: _border(kAccent),
    errorBorder: _border(const Color(0xFFB3261E)),
    focusedErrorBorder: _border(const Color(0xFFB3261E)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kAccent,
      foregroundColor: Colors.white,
      minimumSize: const Size.fromHeight(48),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: kAccent,
      side: const BorderSide(color: kAccent),
      minimumSize: const Size(0, 44),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: kAccent),
  ),
);
