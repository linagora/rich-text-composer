
import 'package:flutter/material.dart';
import 'package:rich_text_composer/models/types.dart';
import 'package:rich_text_composer/rich_text_composer.dart';
import 'package:rich_text_composer/views/commons/constants.dart';
import 'package:rich_text_composer/views/commons/image_paths.dart';
import 'package:rich_text_composer/views/widgets/button/border_container.dart';
import 'package:rich_text_composer/views/widgets/button/format_style_button.dart';
import 'package:rich_text_composer/views/widgets/divider/custom_vertical_divider.dart';

class ListParagraphAlign extends StatelessWidget {

  final RichTextController richTextController;

  const ListParagraphAlign({
    super.key,
    required this.richTextController
  });

  @override
  Widget build(BuildContext context) {
    return BorderContainer(
      child: ValueListenableBuilder(
        valueListenable: richTextController.paragraphTypeApply,
        builder: (context, _, __) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: FormatStyleButton(
                  key: const Key('paragraph_align_left_button'),
                  iconAsset: ImagePaths().icAlignLeft,
                  isSelected: richTextController.paragraphTypeApply.value == ParagraphType.alignLeft,
                  onTapAction: () => richTextController.selectParagraphType(ParagraphType.alignLeft),
                  packageName: packageName,
                ),
              ),
              const CustomVerticalDivider(),
              Expanded(
                child: FormatStyleButton(
                  key: const Key('paragraph_align_center_button'),
                  iconAsset: ImagePaths().icAlignCenter,
                  isSelected: richTextController.paragraphTypeApply.value == ParagraphType.alignCenter,
                  onTapAction: () => richTextController.selectParagraphType(ParagraphType.alignCenter),
                  packageName: packageName,
                ),
              ),
              const CustomVerticalDivider(),
              Expanded(
                child: FormatStyleButton(
                  key: const Key('paragraph_align_right_button'),
                  iconAsset: ImagePaths().icAlignRight,
                  isSelected: richTextController.paragraphTypeApply.value == ParagraphType.alignRight,
                  onTapAction: () => richTextController.selectParagraphType(ParagraphType.alignRight),
                  packageName: packageName,
                ),
              ),
            ],
          );
        },
      )
    );
  }
}