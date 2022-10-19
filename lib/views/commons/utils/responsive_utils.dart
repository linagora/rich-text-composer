import 'package:flutter/widgets.dart';

class ResponsiveUtils {

  final int minDesktopWidth = 1200;
  final int minTabletWidth = 600;
  final int minTabletLargeWidth = 900;

  bool isScreenWithShortestSide(BuildContext context) => MediaQuery.of(context).size.shortestSide < minTabletWidth;

  double getDeviceWidth(BuildContext context) => MediaQuery.of(context).size.width;

  bool isMobile(BuildContext context) => getDeviceWidth(context) < minTabletWidth;

  bool isTablet(BuildContext context) =>
      getDeviceWidth(context) >= minTabletWidth && getDeviceWidth(context) < minTabletLargeWidth;

  bool isTabletLarge(BuildContext context) =>
      getDeviceWidth(context) >= minTabletLargeWidth && getDeviceWidth(context) < minDesktopWidth;

  bool isLandscape(BuildContext context) => MediaQuery.of(context).orientation == Orientation.landscape;

  bool isPortrait(BuildContext context) => MediaQuery.of(context).orientation == Orientation.portrait;

  bool isLandscapeMobile(BuildContext context) => isScreenWithShortestSide(context) && isLandscape(context);

  bool isPortraitMobile(BuildContext context) => isScreenWithShortestSide(context) && isPortrait(context);

  bool isMobileResponsive(BuildContext context) => isPortraitMobile(context) || isLandscapeMobile(context);

  bool isLandscapeTablet(BuildContext context) {
    return MediaQuery.of(context).size.shortestSide >= minTabletWidth &&
        MediaQuery.of(context).size.shortestSide < minDesktopWidth &&
        isLandscape(context);
  }
}