
import 'package:flutter/material.dart';
import 'package:rich_text_composer/models/types.dart';
import 'package:rich_text_composer/rich_text_composer.dart';
import 'package:rich_text_composer/views/commons/constants.dart';
import 'package:rich_text_composer/views/commons/image_paths.dart';
import 'package:rich_text_composer/views/widgets/button/border_container.dart';
import 'package:rich_text_composer/views/widgets/button/format_style_button.dart';
import 'package:rich_text_composer/views/widgets/divider/custom_vertical_divider.dart';

class ListFormatSpecialStyle extends StatelessWidget {

  final RichTextController richTextController;

  const ListFormatSpecialStyle({
    super.key,
    required this.richTextController
  });

  @override
  Widget build(BuildContext context) {
    return BorderContainer(
      child: ValueListenableBuilder(
        valueListenable: richTextController.listSpecialTextStyleApply,
        builder: (context, _, __) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: FormatStyleButton(
                  key: const Key('format_bold_style_button'),
                  iconAsset: ImagePaths().icBoldStyle,
                  isSelected: richTextController.isTextStyleTypeSelected(SpecialStyleType.bold),
                  onTapAction: () => richTextController.selectTextStyleType(SpecialStyleType.bold),
                  packageName: packageName,
                ),
              ),
              const CustomVerticalDivider(),
              Expanded(
                child: FormatStyleButton(
                  key: const Key('format_italic_style_button'),
                  iconAsset: ImagePaths().icItalicStyle,
                  isSelected: richTextController.isTextStyleTypeSelected(SpecialStyleType.italic),
                  onTapAction: () => richTextController.selectTextStyleType(SpecialStyleType.italic),
                  packageName: packageName,
                ),
              ),
              const CustomVerticalDivider(),
              Expanded(
                child: FormatStyleButton(
                  key: const Key('format_strike_through_style_button'),
                  iconAsset: ImagePaths().icStrikeThrough,
                  isSelected: richTextController.isTextStyleTypeSelected(SpecialStyleType.strikeThrough),
                  onTapAction: () => richTextController.selectTextStyleType(SpecialStyleType.strikeThrough),
                  packageName: packageName,
                ),
              ),
              const CustomVerticalDivider(),
              Expanded(
                child: FormatStyleButton(
                  key: const Key('format_underline_style_button'),
                  iconAsset: ImagePaths().icUnderLine,
                  isSelected: richTextController.isTextStyleTypeSelected(SpecialStyleType.underline),
                  onTapAction: () => richTextController.selectTextStyleType(SpecialStyleType.underline),
                  packageName: packageName,
                ),
              )
            ],
          );
        },
      ),
    );
  }
}