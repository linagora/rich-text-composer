
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rich_text_composer/views/commons/colors.dart';

typedef OnLabelIconButtonButtonTapAction = Function();

class LabelIconButton extends StatelessWidget {

  final OnLabelIconButtonButtonTapAction? onTapAction;
  final String label;
  final String iconAsset;
  final String? packageName;

  const LabelIconButton({
    super.key,
    required this.label,
    required this.iconAsset,
    this.onTapAction,
    this.packageName,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTapAction,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: CommonColor.colorIconSelect,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            LimitedBox(
              maxWidth: 28,
              maxHeight: 28,
              child: SvgPicture.asset(
                iconAsset,
                package: packageName,
                fit: BoxFit.fill,
              ),
            ),
          ],
        ),
      ),
    );
  }
}