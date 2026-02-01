import 'package:flutter/material.dart';
import 'theme_provider.dart';

class AppThemeItem {
  final String name;
  final String description;
  final AppTheme appTheme;

  AppThemeItem({
    required this.name,
    required this.description,
    required this.appTheme,
  });
}

final List<AppThemeItem> appThemes = [
  AppThemeItem(
    name: 'Light',
    description: 'Bright theme for normal vision',
    appTheme: AppTheme.light,
  ),
  AppThemeItem(
    name: 'Dark',
    description: 'Low light comfortable theme',
    appTheme: AppTheme.dark,
  ),
  AppThemeItem(
    name: 'High Contrast Dark',
    description: 'White text on dark blue background',
    appTheme: AppTheme.highContrastDark,
  ),
  AppThemeItem(
    name: 'Yellow on Dark Blue',
    description: 'Best for low vision users',
    appTheme: AppTheme.yellowOnDarkBlue,
  ),
];
