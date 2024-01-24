
import 'package:flutter/material.dart';
import 'package:rich_text_composer/models/types.dart';
import 'package:rich_text_composer/rich_text_composer.dart';
import 'package:rich_text_composer/views/commons/constants.dart';
import 'package:rich_text_composer/views/commons/image_paths.dart';
import 'package:rich_text_composer/views/widgets/button/border_container.dart';
import 'package:rich_text_composer/views/widgets/button/format_style_button.dart';
import 'package:rich_text_composer/views/widgets/divider/custom_vertical_divider.dart';

class ListFormatDentStyle extends StatelessWidget {

  final RichTextController richTextController;

  const ListFormatDentStyle({
    super.key,
    required this.richTextController
  });

  @override
  Widget build(BuildContext context) {
    return BorderContainer(
      child: ValueListenableBuilder(
        valueListenable: richTextController.dentTypeApply,
        builder: (context, _, __) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: FormatStyleButton(
                  key: const Key('format_indent_button'),
                  iconAsset: ImagePaths().icIndentFormat,
                  isSelected: richTextController.dentTypeApply.value == DentType.indent,
                  onTapAction: () => richTextController.selectDentTypeType(DentType.indent),
                  packageName: packageName,
                ),
              ),
              const CustomVerticalDivider(),
              Expanded(
                child: FormatStyleButton(
                  key: const Key('format_outdent_button'),
                  iconAsset: ImagePaths().icOutDentFormat,
                  isSelected: richTextController.dentTypeApply.value == DentType.outdent,
                  onTapAction: () => richTextController.selectDentTypeType(DentType.outdent),
                  packageName: packageName,
                ),
              ),
            ],
          );
        }
      )
    );
  }
}