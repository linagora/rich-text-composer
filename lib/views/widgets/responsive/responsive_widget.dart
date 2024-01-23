import 'package:flutter/material.dart';
import 'package:rich_text_composer/views/commons/responsive_utils.dart';

class ResponsiveWidget extends StatelessWidget {
  final Widget defaultDevice;
  final Widget? mobile;
  final Widget? tablet;
  final Widget? landscapeMobile;

  const ResponsiveWidget({
    Key? key,
    required this.defaultDevice,
    this.mobile,
    this.tablet,
    this.landscapeMobile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (landscapeMobile != null && ResponsiveUtils().isLandscapeMobile(context)) {
      return landscapeMobile!;
    }

    if (tablet != null && ResponsiveUtils().isTablet(context)) {
      return tablet!;
    }

    if (mobile != null && ResponsiveUtils().isMobile(context)) {
      return mobile!;
    }

    return defaultDevice;
  }
}