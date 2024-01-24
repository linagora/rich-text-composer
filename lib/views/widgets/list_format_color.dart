
import 'package:flutter/material.dart';
import 'package:rich_text_composer/rich_text_composer.dart';
import 'package:rich_text_composer/views/commons/colors.dart';
import 'package:rich_text_composer/views/commons/constants.dart';
import 'package:rich_text_composer/views/commons/image_paths.dart';
import 'package:rich_text_composer/views/commons/responsive_utils.dart';
import 'package:rich_text_composer/views/widgets/button/border_container.dart';
import 'package:rich_text_composer/views/widgets/button/format_style_button.dart';
import 'package:rich_text_composer/views/widgets/color_picker_keyboard.dart';
import 'package:rich_text_composer/views/widgets/dialog/dialog_utils.dart';
import 'package:rich_text_composer/views/widgets/divider/custom_vertical_divider.dart';
import 'package:rich_text_composer/views/widgets/mobile/option_bottom_sheet.dart';

class ListFormatColor extends StatelessWidget {

  final RichTextController richTextController;
  final String? foregroundColorLabel;
  final String? backgroundColorLabel;

  const ListFormatColor({
    super.key,
    required this.richTextController,
    this.foregroundColorLabel,
    this.backgroundColorLabel,
  });

  @override
  Widget build(BuildContext context) {
    return BorderContainer(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ValueListenableBuilder(
              valueListenable: richTextController.selectedTextColor,
              builder: (context, _, __) {
                return Expanded(
                  child: FormatStyleButton(
                    key: const Key('foreground_color_button'),
                    iconAsset: ImagePaths().icTextColor,
                    iconColor: richTextController.selectedTextColor.value,
                    onTapAction: () => _handleSelectForegroundColorAction(context),
                    packageName: packageName,
                  ),
                );
              }),
          const CustomVerticalDivider(),
          ValueListenableBuilder(
              valueListenable: richTextController.selectedTextBackgroundColor,
              builder: (context, _, __) {
                return Expanded(
                  child: FormatStyleButton(
                    key: const Key('background_color_button'),
                    iconAsset: ImagePaths().icBackgroundColor,
                    iconColor: richTextController.selectedTextBackgroundColor.value == Colors.white
                      ? CommonColor.colorIconSelect
                      : richTextController.selectedTextBackgroundColor.value,
                    onTapAction: () => _handleSelectBackgroundColorAction(context),
                    packageName: packageName,
                  ),
                );
              })
        ],
      ),
    );
  }

  void _handleSelectForegroundColorAction(BuildContext context) {
    if (ResponsiveUtils().isMobile(context)) {
      DialogUtils().showDialogBottomSheet(
        context,
        ValueListenableBuilder(
          valueListenable: richTextController.selectedTextColor,
          builder: (context, _, __) {
            return OptionBottomSheet(
              title: foregroundColorLabel ?? 'Foreground',
              child: ColorPickerKeyboard(
                currentColor: richTextController.selectedTextColor.value,
                onSelected: (color) {
                  richTextController.selectTextColor(color);
                  Navigator.of(context).pop();
                },
              ),
            );
          }
        ));
    } else {
      richTextController.currentIndexStackOverlayRichTextForTablet.value = 1;
    }
  }

  void _handleSelectBackgroundColorAction(BuildContext context) {
    if (ResponsiveUtils().isMobile(context)) {
      DialogUtils().showDialogBottomSheet(
        context,
        ValueListenableBuilder(
          valueListenable: richTextController.selectedTextBackgroundColor,
          builder: (context, _, __) {
            return OptionBottomSheet(
              title: backgroundColorLabel ?? 'Background',
              child: ColorPickerKeyboard(
                currentColor: richTextController.selectedTextBackgroundColor.value,
                onSelected: (color) {
                  richTextController.selectBackgroundColor(color);
                  Navigator.of(context).pop();
                },
              )
            );
          }
        ));
    } else {
      richTextController.currentIndexStackOverlayRichTextForTablet.value = 2;
    }
  }
}