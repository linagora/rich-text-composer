import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rich_text_composer/richtext_controller.dart';
import 'package:rich_text_composer/views/commons/colors.dart';
import 'package:rich_text_composer/views/commons/image_paths.dart';
import 'package:rich_text_composer/views/widgets/list_header_style.dart';
import 'package:rich_text_composer/views/widgets/option_bottom_sheet.dart';
import 'package:rich_text_composer/views/widgets/responsive/responsive_widget.dart';
import 'package:rich_text_composer/views/widgets/rich_text_keyboard_toolbar.dart';
import 'package:enough_html_editor/enough_html_editor.dart' as html_editor;

import '../../models/types.dart';
import 'list_color.dart';

class RichTextOptionBottomSheet extends StatelessWidget {
  RichTextOptionBottomSheet({
    super.key,
    required this.title,
    this.htmlEditorApi,
    required this.richTextController,
    required this.titleQuickStyleBottomSheet,
    required this.titleForegroundBottomSheet,
    required this.titleBackgroundBottomSheet,
  });

  final String title;
  final String titleQuickStyleBottomSheet;
  final String titleForegroundBottomSheet;
  final String titleBackgroundBottomSheet;
  final ImagePaths _imagePaths = ImagePaths();
  final html_editor.HtmlEditorApi? htmlEditorApi;
  final RichTextController richTextController;

  @override
  Widget build(BuildContext context) {
    return OptionBottomSheet(
      title: title,
      child: ResponsiveWidget(
        responsiveUtils: richTextController.responsiveUtils,
        mobile: _buildBodyForMobile(context),
        landscapeMobile: _buildBodyForLandscapeMobile(context),
      ),
    );
  }

  Widget _buildBodyForMobile(BuildContext context) {
    return Column(
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
            Expanded(child: _buildColorStyle(context)),
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
    );
  }

  Widget _buildBodyForLandscapeMobile(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: _buildSpecialStyle()),
            const SizedBox(width: 8),
            Expanded(child: _buildQuickStyle(context)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _buildAlignStyle()),
            const SizedBox(width: 8),
            Expanded(child: _buildColorStyle(context)),
            const SizedBox(width: 8),
            Expanded(child: _buildFormatStyle()),
            const SizedBox(width: 8),
            Expanded(child: _buildOrderListStyle()),
          ],
        ),
      ],
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
      ValueListenableBuilder(
        valueListenable: richTextController.listSpecialTextStyleApply,
        builder: (context, value, _) {
          return Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIconButton(
                richTextController
                    .isTextStyleTypeSelected(SpecialStyleType.bold),
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
                  richTextController
                      .selectTextStyleType(SpecialStyleType.italic);
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
          );
        },
      ),
    );
  }

  Widget _buildQuickStyle(BuildContext context) {
    return _buildBorderContainer(
      InkWell(
        onTap: () {
          showModalBottomSheet(
            isScrollControlled:
                richTextController.responsiveUtils.isLandscapeMobile(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: Colors.white,
            context: context,
            builder: (_) {
              return ListHeaderStyle(
                title: titleQuickStyleBottomSheet,
                itemSelected: (item) {
                  Navigator.of(context).pop();
                  richTextController.headerStyleTypeApply.value = item;
                },
              );
            },
          );
        },
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              titleQuickStyleBottomSheet,
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
    return _buildBorderContainer(ValueListenableBuilder(
      valueListenable: richTextController.paragraphTypeApply,
      builder: (context, value, _) {
        return Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIconButton(
                richTextController.paragraphTypeApply.value ==
                    ParagraphType.alignLeft, () {
              richTextController.paragraphTypeApply.value =
                  ParagraphType.alignLeft;
            }, _imagePaths.icAlignLeft),
            _buildVerticalDivider(),
            _buildIconButton(
                richTextController.paragraphTypeApply.value ==
                    ParagraphType.alignCenter, () {
              richTextController.paragraphTypeApply.value =
                  ParagraphType.alignCenter;
            }, _imagePaths.icAlignCenter),
            _buildVerticalDivider(),
            _buildIconButton(
                richTextController.paragraphTypeApply.value ==
                    ParagraphType.alignRight, () {
              richTextController.paragraphTypeApply.value =
                  ParagraphType.alignRight;
            }, _imagePaths.icAlignRight),
          ],
        );
      },
    ));
  }

  Widget _buildColorStyle(BuildContext context) {
    return _buildBorderContainer(
      Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ValueListenableBuilder(
              valueListenable: richTextController.selectedTextColor,
              builder: (context, value, _) {
                return _buildIconButton(
                  true,
                  () {
                    showModalBottomSheet(
                        isScrollControlled: richTextController.responsiveUtils
                            .isLandscapeMobile(context),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        constraints: const BoxConstraints(
                          maxHeight: 300,
                          maxWidth: 700,
                        ),
                        backgroundColor: Colors.white,
                        context: context,
                        builder: (_) {
                          return ColorPickerKeyboard(
                            title: titleForegroundBottomSheet,
                            onSelected: (color) {
                              richTextController.selectTextColor(color);
                              Navigator.of(context).pop();
                            },
                          );
                        });
                  },
                  _imagePaths.icTextColor,
                  iconColor: richTextController.selectedTextColor.value,
                );
              }),
          _buildVerticalDivider(),
          ValueListenableBuilder(
              valueListenable: richTextController.selectedTextBackgroundColor,
              builder: (context, value, _) {
                return _buildIconButton(
                  true,
                  () {
                    showModalBottomSheet(
                        isScrollControlled: richTextController.responsiveUtils
                            .isLandscapeMobile(context),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        constraints: const BoxConstraints(
                          maxHeight: 300,
                          maxWidth: 700,
                        ),
                        backgroundColor: Colors.white,
                        context: context,
                        builder: (_) {
                          return ColorPickerKeyboard(
                            title: titleBackgroundBottomSheet,
                            onSelected: (color) {
                              richTextController.selectBackgroundColor(color);
                              Navigator.of(context).pop();
                            },
                          );
                        });
                  },
                  _imagePaths.icBackgroundColor,
                  iconColor:
                      richTextController.selectedTextBackgroundColor.value,
                );
              })
        ],
      ),
    );
  }

  Widget _buildFormatStyle() {
    return _buildBorderContainer(ValueListenableBuilder(
        valueListenable: richTextController.dentTypeApply,
        builder: (context, value, _) {
          return Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIconButton(
                  richTextController.dentTypeApply.value == DentType.indent,
                  () {
                richTextController.dentTypeApply.value = DentType.indent;
              }, _imagePaths.icIndentFormat),
              _buildVerticalDivider(),
              _buildIconButton(
                  richTextController.dentTypeApply.value == DentType.outdent,
                  () {
                richTextController.dentTypeApply.value = DentType.outdent;
              }, _imagePaths.icOutDentFormat),
            ],
          );
        }));
  }

  Widget _buildOrderListStyle() {
    return _buildBorderContainer(ValueListenableBuilder(
        valueListenable: richTextController.orderListTypeApply,
        builder: (context, value, _) {
          return Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIconButton(
                  richTextController.orderListTypeApply.value ==
                      OrderListType.bulletedList, () {
                richTextController
                    .selectOrderListType(OrderListType.bulletedList);
              }, _imagePaths.icBulletOrder),
              _buildVerticalDivider(),
              _buildIconButton(
                  richTextController.orderListTypeApply.value ==
                      OrderListType.numberedList, () {
                richTextController
                    .selectOrderListType(OrderListType.numberedList);
              }, _imagePaths.icNumberOrder),
            ],
          );
        }));
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      color: CommonColor.colorBorderGray,
    );
  }

  Widget _buildIconButton(
    bool isSelected,
    VoidCallback onTap,
    String asset, {
    Color? iconColor,
  }) {
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
              color: isSelected && iconColor == null
                  ? CommonColor.colorIconSelect
                  : iconColor,
              package: packageName,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}