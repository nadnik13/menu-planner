import 'package:flutter/material.dart';

/// Утилиты для адаптивного дизайна
class ScreenUtils {
  ScreenUtils._();

  /// Определяет размер экрана на основе ширины
  static ScreenSize getScreenSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    if (width < 380) {
      return ScreenSize.small; // iPhone 12 mini, SE
    } else if (width < 415) {
      return ScreenSize.medium; // iPhone 12/13/14
    } else {
      return ScreenSize.large; // iPhone Pro Max, iPad
    }
  }

  /// Проверка на маленький экран (iPhone 12 mini и меньше)
  static bool isSmallScreen(BuildContext context) {
    return getScreenSize(context) == ScreenSize.small;
  }

  /// Адаптивный размер шрифта
  static double adaptiveFontSize(BuildContext context, {
    required double small,
    required double medium,
    double? large,
  }) {
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.small:
        return small;
      case ScreenSize.medium:
        return medium;
      case ScreenSize.large:
        return large ?? medium;
    }
  }

  /// Адаптивные отступы
  static EdgeInsets adaptivePadding(BuildContext context, {
    required EdgeInsets small,
    required EdgeInsets medium,
    EdgeInsets? large,
  }) {
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.small:
        return small;
      case ScreenSize.medium:
        return medium;
      case ScreenSize.large:
        return large ?? medium;
    }
  }

  /// Адаптивное значение
  static T adaptiveValue<T>(BuildContext context, {
    required T small,
    required T medium,
    T? large,
  }) {
    final screenSize = getScreenSize(context);
    switch (screenSize) {
      case ScreenSize.small:
        return small;
      case ScreenSize.medium:
        return medium;
      case ScreenSize.large:
        return large ?? medium;
    }
  }
}

enum ScreenSize {
  small,  // < 380 (iPhone 12 mini, SE)
  medium, // 380-414 (iPhone 12/13/14)
  large,  // > 414 (Pro Max, iPad)
} 