import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rich_text_composer/richtext_controller.dart';
import 'package:rich_text_composer/views/commons/colors.dart';
import 'package:rich_text_composer/views/commons/image_paths.dart';
import 'package:rich_text_composer/views/widgets/list_header_style.dart';
import 'package:rich_text_composer/views/widgets/mobile/option_bottom_sheet.dart';
import 'package:rich_text_composer/views/widgets/responsive/responsive_widget.dart';
import 'package:rich_text_composer/views/widgets/rich_text_keyboard_toolbar.dart';
import 'package:enough_html_editor/enough_html_editor.dart' as html_editor;

import '../../../models/types.dart';
import '../list_color.dart';

class RichTextOption extends StatelessWidget {
  RichTextOption({
    super.key,
    this.htmlEditorApi,
    required this.richTextController,
    required this.titleQuickStyleBottomSheet,
    required this.titleForegroundBottomSheet,
    required this.titleBackgroundBottomSheet,
  });

  final String titleQuickStyleBottomSheet;
  final String titleForegroundBottomSheet;
  final String titleBackgroundBottomSheet;
  final ImagePaths _imagePaths = ImagePaths();
  final html_editor.HtmlEditorApi? htmlEditorApi;
  final RichTextController richTextController;

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      responsiveUtils: richTextController.responsiveUtils,
      mobile: _buildBodyForMobile(context),
      landscapeMobile: _buildBodyForLandscapeMobile(context),
      landscapeTablet: _buildBodyForMobile(context),
      tablet: _buildBodyForMobile(context),
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
                  richTextController.selectTextStyleType(
                      SpecialStyleType.bold, context);
                },
                _imagePaths.icBoldStyle,
              ),
              _buildVerticalDivider(),
              _buildIconButton(
                richTextController
                    .isTextStyleTypeSelected(SpecialStyleType.italic),
                () {
                  richTextController.selectTextStyleType(
                      SpecialStyleType.italic, context);
                },
                _imagePaths.icItalicStyle,
              ),
              _buildVerticalDivider(),
              _buildIconButton(
                richTextController
                    .isTextStyleTypeSelected(SpecialStyleType.strikeThrough),
                () {
                  richTextController.selectTextStyleType(
                      SpecialStyleType.strikeThrough, context);
                },
                _imagePaths.icStrikeThrough,
              ),
              _buildVerticalDivider(),
              _buildIconButton(
                richTextController
                    .isTextStyleTypeSelected(SpecialStyleType.underline),
                () {
                  richTextController.selectTextStyleType(
                      SpecialStyleType.underline, context);
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
          if (richTextController.responsiveUtils.isMobile(context)) {
            showModalBottomSheet(
              isScrollControlled:
                  richTextController.responsiveUtils.isLandscapeMobile(context),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: Colors.white,
              context: context,
              builder: (_) {
                return OptionBottomSheet(
                  title: titleQuickStyleBottomSheet,
                  child: ListHeaderStyle(
                    itemSelected: (item) {
                      Navigator.of(context).pop();
                      richTextController.headerStyleTypeApply.value = item;
                    },
                  ),
                );
              },
            );
          } else {
            richTextController.showDialogSelectHeaderStyle(
              context,
              titleQuickStyleBottomSheet,
            );
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ValueListenableBuilder(
                valueListenable: richTextController.headerStyleTypeApply,
                builder: (context, value, _) {
                  return Text(
                    richTextController.headerStyleTypeApply.value ==
                            HeaderStyleType.normal
                        ? titleQuickStyleBottomSheet
                        : richTextController
                            .headerStyleTypeApply.value.styleName,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: CommonColor.colorIconSelect,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }),
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
              richTextController.selectParagraphType(
                  ParagraphType.alignLeft, context);
            }, _imagePaths.icAlignLeft),
            _buildVerticalDivider(),
            _buildIconButton(
                richTextController.paragraphTypeApply.value ==
                    ParagraphType.alignCenter, () {
              richTextController.selectParagraphType(
                  ParagraphType.alignCenter, context);
            }, _imagePaths.icAlignCenter),
            _buildVerticalDivider(),
            _buildIconButton(
                richTextController.paragraphTypeApply.value ==
                    ParagraphType.alignRight, () {
              richTextController.selectParagraphType(
                  ParagraphType.alignRight, context);
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
                          return OptionBottomSheet(
                            title: titleForegroundBottomSheet,
                            padding: const EdgeInsets.all(0),
                            child: ColorPickerKeyboard(
                              onSelected: (color) {
                                richTextController.selectTextColor(color);
                                Navigator.of(context).pop();
                              },
                            ),
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
                          return OptionBottomSheet(
                            padding: const EdgeInsets.all(0),
                            title: titleBackgroundBottomSheet,
                            child: ColorPickerKeyboard(
                              onSelected: (color) {
                                richTextController.selectBackgroundColor(color);
                                Navigator.of(context).pop();
                              },
                            ),
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
                richTextController.selectDentTypeType(DentType.indent, context);
              }, _imagePaths.icIndentFormat),
              _buildVerticalDivider(),
              _buildIconButton(
                  richTextController.dentTypeApply.value == DentType.outdent,
                  () {
                richTextController.selectDentTypeType(
                    DentType.outdent, context);
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
                richTextController.selectOrderListType(
                    OrderListType.bulletedList, context);
              }, _imagePaths.icBulletOrder),
              _buildVerticalDivider(),
              _buildIconButton(
                  richTextController.orderListTypeApply.value ==
                      OrderListType.numberedList, () {
                richTextController.selectOrderListType(
                    OrderListType.numberedList, context);
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
