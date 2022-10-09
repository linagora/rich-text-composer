import 'package:flutter/material.dart';
import 'package:rich_text_composer/views/commons/utils/responsive_utils.dart';

class ResponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget? landscapeMobile;
  final Widget? tablet;
  final Widget? landscapeTablet;
  final Widget? tabletLarge;

  final ResponsiveUtils responsiveUtils;

  const ResponsiveWidget({
    Key? key,
    required this.responsiveUtils,
    required this.mobile,
    this.landscapeMobile,
    this.tablet,
    this.landscapeTablet,
    this.tabletLarge,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

      if (responsiveUtils.isLandscapeMobile(context)) {
        return landscapeMobile ?? mobile;
      }

      if (responsiveUtils.isLandscapeTablet(context)) {
        return landscapeTablet ?? tablet ?? mobile;
      }

      if (responsiveUtils.isMobile(context)) {
        return mobile;
      }

      if (responsiveUtils.isTablet(context)) {
        return tablet ?? mobile;
      }

      if (responsiveUtils.isTabletLarge(context)) {
        return tabletLarge ?? tablet ?? mobile;
      }

      return mobile;
  }
}