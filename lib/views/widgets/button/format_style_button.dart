
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rich_text_composer/views/commons/colors.dart';

typedef OnFormatStyleButtonTapAction = Function();

class FormatStyleButton extends StatelessWidget {

  final OnFormatStyleButtonTapAction? onTapAction;
  final String iconAsset;
  final bool isSelected;
  final Color? iconColor;
  final String? packageName;

  const FormatStyleButton({
    super.key,
    required this.iconAsset,
    this.onTapAction,
    this.isSelected = false,
    this.iconColor,
    this.packageName,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTapAction,
        child: Container(
          color: isSelected
            ? CommonColor.colorBackgroundSelect
            : Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          height: double.infinity,
          child: LimitedBox(
            maxWidth: 28,
            maxHeight: 28,
            child: SvgPicture.asset(
              iconAsset,
              colorFilter: ColorFilter.mode(
                isSelected
                  ? CommonColor.colorIconSelect
                  : iconColor ?? CommonColor.colorIconSelect,
                BlendMode.srcIn
              ),
              package: packageName,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}