import 'package:flutter/widgets.dart';

class ResponsiveUtils {

  static const double defaultSizeLeftMenuMobile = 375;
  static const double defaultSizeDrawer = 320;

  final int heightShortest = 600;

  final int minDesktopWidth = 1200;
  final int minTabletWidth = 600;
  final int minTabletLargeWidth = 900;

  final double defaultSizeMenu = 256;

  final double tabletHorizontalMargin = 120.0;
  final double tabletVerticalMargin = 200.0;

  bool isScreenWithShortestSide(BuildContext context) => MediaQuery.of(context).size.shortestSide < minTabletWidth;

  double getDeviceWidth(BuildContext context) => MediaQuery.of(context).size.width;

  bool isMobile(BuildContext context) => getDeviceWidth(context) < minTabletWidth;

  bool isTablet(BuildContext context) =>
      getDeviceWidth(context) >= minTabletWidth && getDeviceWidth(context) < minTabletLargeWidth;

  bool isTabletLarge(BuildContext context) =>
      getDeviceWidth(context) >= minTabletLargeWidth && getDeviceWidth(context) < minDesktopWidth;

  bool isLandscape(BuildContext context) => MediaQuery.of(context).orientation == Orientation.landscape;

  bool isLandscapeMobile(BuildContext context) => isScreenWithShortestSide(context) && isLandscape(context);

  bool isLandscapeTablet(BuildContext context) {
    return MediaQuery.of(context).size.shortestSide >= minTabletWidth &&
        MediaQuery.of(context).size.shortestSide < minDesktopWidth &&
        isLandscape(context);
  }
}