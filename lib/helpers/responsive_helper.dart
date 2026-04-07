import 'package:flutter/material.dart';
import '../constants/app_theme.dart';

class ResponsiveHelper {
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 1200;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1200;
  }

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static int getGridCrossAxisCount(BuildContext context) {
    final width = getScreenWidth(context);
    if (width >= 1200) return 4;
    if (width >= 600) return 3;
    return 2;
  }

  static double getChildAspectRatio(BuildContext context) {
    final width = getScreenWidth(context);
    if (width >= 1200) return 0.85;
    if (width >= 600) return 0.8;
    return 0.75;
  }

  static EdgeInsets getScreenPadding(BuildContext context) {
    final width = getScreenWidth(context);
    if (width >= 1200) {
      return const EdgeInsets.all(AppTheme.spacingXL);
    } else if (width >= 600) {
      return const EdgeInsets.all(AppTheme.spacingL);
    }
    return const EdgeInsets.all(AppTheme.spacingM);
  }

  static double getCarouselHeight(BuildContext context) {
    final width = getScreenWidth(context);
    if (width >= 600) return 250;
    return 180;
  }

  static double getMaxContainerWidth(BuildContext context) {
    final width = getScreenWidth(context);
    if (width >= 1200) return 1200;
    if (width >= 600) return width * 0.9;
    return width;
  }
}
