
import 'package:flutter/material.dart';
import 'package:rich_text_composer/models/types.dart';
import 'package:rich_text_composer/rich_text_composer.dart';
import 'package:rich_text_composer/views/commons/constants.dart';
import 'package:rich_text_composer/views/commons/image_paths.dart';
import 'package:rich_text_composer/views/widgets/button/border_container.dart';
import 'package:rich_text_composer/views/widgets/button/format_style_button.dart';
import 'package:rich_text_composer/views/widgets/divider/custom_vertical_divider.dart';

class ListFormatOrder extends StatelessWidget {

  final RichTextController richTextController;

  const ListFormatOrder({
    super.key,
    required this.richTextController
  });

  @override
  Widget build(BuildContext context) {
    return BorderContainer(
      child: ValueListenableBuilder(
        valueListenable: richTextController.orderListTypeApply,
        builder: (context, _, __) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: FormatStyleButton(
                  key: const Key('order_bullet_button'),
                  iconAsset: ImagePaths().icBulletOrder,
                  isSelected: richTextController.orderListTypeApply.value == OrderListType.bulletedList,
                  onTapAction: () => richTextController.selectOrderListType(OrderListType.bulletedList),
                  packageName: packageName,
                ),
              ),
              const CustomVerticalDivider(),
              Expanded(
                child: FormatStyleButton(
                  key: const Key('order_number_button'),
                  iconAsset: ImagePaths().icNumberOrder,
                  isSelected: richTextController.orderListTypeApply.value == OrderListType.numberedList,
                  onTapAction: () => richTextController.selectOrderListType(OrderListType.numberedList),
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