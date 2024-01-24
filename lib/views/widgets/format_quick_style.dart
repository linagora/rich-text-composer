
import 'package:flutter/material.dart';
import 'package:rich_text_composer/rich_text_composer.dart';
import 'package:rich_text_composer/views/commons/constants.dart';
import 'package:rich_text_composer/views/commons/image_paths.dart';
import 'package:rich_text_composer/views/commons/responsive_utils.dart';
import 'package:rich_text_composer/views/widgets/button/border_container.dart';
import 'package:rich_text_composer/views/widgets/button/label_icon_button.dart';
import 'package:rich_text_composer/views/widgets/dialog/dialog_utils.dart';
import 'package:rich_text_composer/views/widgets/list_header_style.dart';
import 'package:rich_text_composer/views/widgets/mobile/option_bottom_sheet.dart';

class FormatQuickStyle extends StatelessWidget {

  final RichTextController richTextController;
  final String? label;

  const FormatQuickStyle({
    super.key,
    required this.richTextController,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return BorderContainer(
      child: LabelIconButton(
        key: const Key('format_quick_style_button'),
        label: label ?? 'Quick styles',
        iconAsset: ImagePaths().icArrowRight,
        packageName: packageName,
        onTapAction: () => _handleSelectQuickStyleAction(context),
      )
    );
  }

  void _handleSelectQuickStyleAction(BuildContext context) {
    if (ResponsiveUtils().isMobile(context)) {
      DialogUtils().showDialogBottomSheet(
        context,
        OptionBottomSheet(
          title: label ?? 'Quick styles',
          child: ListHeaderStyle(
            itemSelected: (style) {
              richTextController.applyHeaderStyle(style);
              Navigator.of(context).pop();
            },
          ),
        ));
    } else {
      DialogUtils().showDialogCenter(
        context,
        builder: (context) {
          return OptionBottomSheet(
            title: label ?? 'Quick styles',
            child: ListHeaderStyle(
              itemSelected: (style) {
                richTextController.applyHeaderStyle(style);
                Navigator.of(context).pop();
              },
            )
          );
        });
    }
  }
}