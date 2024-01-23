import 'package:flutter/widgets.dart';

class ResponsiveUtils {
  static ResponsiveUtils? _instance;

  ResponsiveUtils._();

  factory ResponsiveUtils() => _instance ??= ResponsiveUtils._();

  static const int minTabletWidth = 600;

  bool isMobile(BuildContext context) => MediaQuery.of(context).size.shortestSide < minTabletWidth;

  bool _isLandscape(BuildContext context) => MediaQuery.of(context).orientation == Orientation.landscape;

  bool _isPortrait(BuildContext context) => MediaQuery.of(context).orientation == Orientation.portrait;

  bool isLandscapeMobile(BuildContext context) => isMobile(context) && _isLandscape(context);

  bool isPortraitMobile(BuildContext context) => isMobile(context) && _isPortrait(context);

  bool isTablet(BuildContext context) => MediaQuery.of(context).size.shortestSide >= minTabletWidth;
}