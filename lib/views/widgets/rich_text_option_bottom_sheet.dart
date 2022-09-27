import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:rich_text_composer/richtext_controller.dart';
import 'package:rich_text_composer/views/commons/colors.dart';
import 'package:rich_text_composer/views/commons/image_paths.dart';
import 'package:rich_text_composer/views/widgets/list_header_style.dart';
import 'package:rich_text_composer/views/widgets/option_bottom_sheet.dart';
import 'package:rich_text_composer/views/widgets/rich_text_keyboard_toolbar.dart';
import 'package:enough_html_editor/enough_html_editor.dart' as html_editor;

class RichTextOptionBottomSheet extends StatelessWidget {
  RichTextOptionBottomSheet({
    super.key,
    required this.title,
    this.htmlEditorApi,
    required this.richTextController,
  });

  final String title;
  final ImagePaths _imagePaths = ImagePaths();
  final html_editor.HtmlEditorApi? htmlEditorApi;
  final RichTextController richTextController;

  @override
  Widget build(BuildContext context) {
    return OptionBottomSheet(
      title: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSpecialStyle(),
          const SizedBox(height: 8),
          _buildQuickStyle(context),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildAlignStyle()),
              const SizedBox(width: 8),
              Expanded(child: _buildColorStyle()),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildFormatStyle()),
              const SizedBox(width: 8),
              Expanded(child: _buildOrderListStyle()),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBorderContainer(Widget child) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(8),
          ),
          border: Border.all(color: CommonColor.colorBorderGray)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: child,
      ),
    );
  }

  Widget _buildSpecialStyle() {
    return _buildBorderContainer(
      Obx(
        () => Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIconButton(
              richTextController.isTextStyleTypeSelected(SpecialStyleType.bold),
              () {
                richTextController.selectTextStyleType(SpecialStyleType.bold);
              },
              _imagePaths.icBoldStyle,
            ),
            _buildVerticalDivider(),
            _buildIconButton(
              richTextController
                  .isTextStyleTypeSelected(SpecialStyleType.italic),
              () {
                richTextController.selectTextStyleType(SpecialStyleType.italic);
              },
              _imagePaths.icItalicStyle,
            ),
            _buildVerticalDivider(),
            _buildIconButton(
              richTextController
                  .isTextStyleTypeSelected(SpecialStyleType.strikeThrough),
              () {
                richTextController
                    .selectTextStyleType(SpecialStyleType.strikeThrough);
              },
              _imagePaths.icStrikeThrough,
            ),
            _buildVerticalDivider(),
            _buildIconButton(
              richTextController
                  .isTextStyleTypeSelected(SpecialStyleType.underline),
              () {
                richTextController
                    .selectTextStyleType(SpecialStyleType.underline);
              },
              _imagePaths.icUnderLine,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStyle(BuildContext context) {
    return _buildBorderContainer(
      InkWell(
        onTap: () {
          showModalBottomSheet(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: Colors.white,
              context: context,
              builder: (_) => ListHeaderStyle(
                    itemSelected: (item) {
                      Navigator.of(context).pop();
                      richTextController.headerStyleTypeApply.value = item;
                    },
                  ));
        },
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Quick styles',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: CommonColor.colorIconSelect,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            LimitedBox(
              maxWidth: 28,
              maxHeight: 28,
              child: SvgPicture.asset(
                _imagePaths.icArrowRight,
                package: packageName,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlignStyle() {
    return _buildBorderContainer(
      Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildIconButton(false, () {}, _imagePaths.icAlignLeft),
          _buildVerticalDivider(),
          _buildIconButton(false, () {}, _imagePaths.icAlignCenter),
          _buildVerticalDivider(),
          _buildIconButton(false, () {}, _imagePaths.icAlignRight),
        ],
      ),
    );
  }

  Widget _buildColorStyle() {
    return _buildBorderContainer(
      Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildIconButton(false, () {}, _imagePaths.icTextColor),
          _buildVerticalDivider(),
          _buildIconButton(false, () {}, _imagePaths.icBackgroundColor),
        ],
      ),
    );
  }

  Widget _buildFormatStyle() {
    return _buildBorderContainer(
      Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildIconButton(false, () {}, _imagePaths.icIndentFormat),
          _buildVerticalDivider(),
          _buildIconButton(false, () {}, _imagePaths.icOutDentFormat),
        ],
      ),
    );
  }

  Widget _buildOrderListStyle() {
    return _buildBorderContainer(
      Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildIconButton(false, () {}, _imagePaths.icBulletOrder),
          _buildVerticalDivider(),
          _buildIconButton(false, () {}, _imagePaths.icNumberOrder),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() => Container(
        width: 1,
        color: CommonColor.colorBorderGray,
      );

  Widget _buildIconButton(
    bool isSelected,
    VoidCallback onTap,
    String asset,
  ) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          color: isSelected ? CommonColor.colorBackgroundSelect : Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          height: double.infinity,
          child: LimitedBox(
            maxWidth: 28,
            maxHeight: 28,
            child: SvgPicture.asset(
              asset,
              color: isSelected ? CommonColor.colorIconSelect : null,
              package: packageName,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}