import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rich_text_composer/models/types.dart';
import 'package:rich_text_composer/richtext_controller.dart';
import 'package:rich_text_composer/views/commons/colors.dart';
import 'package:rich_text_composer/views/commons/image_paths.dart';
import 'package:rich_text_composer/views/commons/utils/responsive_utils.dart';
import 'package:rich_text_composer/views/widgets/color_picker_keyboard.dart';
import 'package:rich_text_composer/views/widgets/dialog/dialog_utils.dart';
import 'package:rich_text_composer/views/widgets/list_header_style.dart';
import 'package:rich_text_composer/views/widgets/mobile/option_bottom_sheet.dart';
import 'package:rich_text_composer/views/widgets/responsive/responsive_widget.dart';
import 'package:rich_text_composer/views/widgets/rich_text_keyboard_toolbar.dart';

class RichTextOption extends StatelessWidget {
  RichTextOption({
    super.key,
    required this.richTextController,
    required this.titleQuickStyleBottomSheet,
    required this.titleForegroundBottomSheet,
    required this.titleBackgroundBottomSheet,
  });

  final String titleQuickStyleBottomSheet;
  final String titleForegroundBottomSheet;
  final String titleBackgroundBottomSheet;
  final RichTextController richTextController;

  final ImagePaths _imagePaths = ImagePaths();
  final ResponsiveUtils _responsiveUtils = ResponsiveUtils();

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      responsiveUtils: _responsiveUtils,
      mobile: _buildBodyForMobile(context),
      landscapeMobile: _buildBodyForLandscapeMobile(context),
      landscapeTablet: _buildBodyForMobile(context),
      tablet: _buildBodyForMobile(context),
    );
  }

  Widget _buildBodyForMobile(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
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
        builder: (context, _, __) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIconButton(
                richTextController.isTextStyleTypeSelected(SpecialStyleType.bold),
                () =>  richTextController.selectTextStyleType(SpecialStyleType.bold, context),
                _imagePaths.icBoldStyle
              ),
              _buildVerticalDivider(),
              _buildIconButton(
                richTextController.isTextStyleTypeSelected(SpecialStyleType.italic),
                () => richTextController.selectTextStyleType(SpecialStyleType.italic, context),
                _imagePaths.icItalicStyle
              ),
              _buildVerticalDivider(),
              _buildIconButton(
                richTextController.isTextStyleTypeSelected(SpecialStyleType.strikeThrough),
                () => richTextController.selectTextStyleType(SpecialStyleType.strikeThrough, context),
                _imagePaths.icStrikeThrough
              ),
              _buildVerticalDivider(),
              _buildIconButton(
                richTextController.isTextStyleTypeSelected(SpecialStyleType.underline),
                () => richTextController.selectTextStyleType(SpecialStyleType.underline, context),
                _imagePaths.icUnderLine
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
          if (_responsiveUtils.isMobileResponsive(context)) {
            DialogUtils.showDialogBottomSheet(context, OptionBottomSheet(
              title: titleQuickStyleBottomSheet,
              child: ListHeaderStyle(
                itemSelected: (style) {
                  richTextController.applyHeaderStyle(style);
                  Navigator.of(context).pop();
                },
              ),
            ));
          } else {
            DialogUtils.showDialogCenter(
              context,
              builder: (context) {
                return OptionBottomSheet(
                    title: titleQuickStyleBottomSheet,
                    child: ListHeaderStyle(
                      itemSelected: (style) {
                        richTextController.applyHeaderStyle(style);
                        Navigator.of(context).pop();
                      },
                    )
                );
              });
          }
        },
        customBorder: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
        child: Row(
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
      builder: (context, _, __) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIconButton(
              richTextController.paragraphTypeApply.value == ParagraphType.alignLeft,
              () => richTextController.selectParagraphType(ParagraphType.alignLeft, context),
              _imagePaths.icAlignLeft
            ),
            _buildVerticalDivider(),
            _buildIconButton(
              richTextController.paragraphTypeApply.value == ParagraphType.alignCenter,
              () => richTextController.selectParagraphType(ParagraphType.alignCenter, context),
              _imagePaths.icAlignCenter
            ),
            _buildVerticalDivider(),
            _buildIconButton(
              richTextController.paragraphTypeApply.value == ParagraphType.alignRight,
              () => richTextController.selectParagraphType(ParagraphType.alignRight, context),
              _imagePaths.icAlignRight
            ),
          ],
        );
      },
    ));
  }

  Widget _buildColorStyle(BuildContext context) {
    return _buildBorderContainer(
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ValueListenableBuilder(
              valueListenable: richTextController.selectedTextColor,
              builder: (context, _, __) {
                return _buildIconButton(
                  true,
                  () {
                    if (_responsiveUtils.isMobileResponsive(context)) {
                      DialogUtils.showDialogBottomSheet(context, ValueListenableBuilder(
                        valueListenable: richTextController.selectedTextColor,
                        builder: (context, _, __) {
                          return OptionBottomSheet(
                            title: titleForegroundBottomSheet,
                            child: ColorPickerKeyboard(
                              currentColor: richTextController.selectedTextColor.value,
                              onSelected: (color) {
                                richTextController.selectTextColor(color, context);
                                Navigator.of(context).pop();
                              },
                            ),
                          );
                        }
                      ));
                    } else {
                      richTextController.currentIndexStackOverlayRichTextForTablet.value = 1;
                    }
                  },
                  _imagePaths.icTextColor,
                  iconColor: richTextController.selectedTextColor.value,
                );
              }),
          _buildVerticalDivider(),
          ValueListenableBuilder(
              valueListenable: richTextController.selectedTextBackgroundColor,
              builder: (context, _, __) {
                return _buildIconButton(
                  true,
                  () {
                    if (_responsiveUtils.isMobileResponsive(context)) {
                      DialogUtils.showDialogBottomSheet(context, ValueListenableBuilder(
                        valueListenable: richTextController.selectedTextBackgroundColor,
                        builder: (context, _, __) {
                          return OptionBottomSheet(
                            title: titleBackgroundBottomSheet,
                            child: ColorPickerKeyboard(
                              currentColor: richTextController.selectedTextBackgroundColor.value,
                              onSelected: (color) {
                                richTextController.selectBackgroundColor(color, context);
                                Navigator.of(context).pop();
                              },
                            )
                          );
                        }
                      ));
                    } else {
                      richTextController.currentIndexStackOverlayRichTextForTablet.value = 2;
                    }
                  },
                  _imagePaths.icBackgroundColor,
                  iconColor: richTextController.selectedTextBackgroundColor.value,
                );
              })
        ],
      ),
    );
  }

  Widget _buildFormatStyle() {
    return _buildBorderContainer(ValueListenableBuilder(
      valueListenable: richTextController.dentTypeApply,
      builder: (context, _, __) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIconButton(
              richTextController.dentTypeApply.value == DentType.indent,
              () => richTextController.selectDentTypeType(DentType.indent, context),
              _imagePaths.icIndentFormat),
            _buildVerticalDivider(),
            _buildIconButton(
              richTextController.dentTypeApply.value == DentType.outdent,
              () => richTextController.selectDentTypeType(DentType.outdent, context),
              _imagePaths.icOutDentFormat
            ),
          ],
        );
      }
    ));
  }

  Widget _buildOrderListStyle() {
    return _buildBorderContainer(ValueListenableBuilder(
      valueListenable: richTextController.orderListTypeApply,
      builder: (context, _, __) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildIconButton(
              richTextController.orderListTypeApply.value == OrderListType.bulletedList,
              () => richTextController.selectOrderListType(OrderListType.bulletedList, context),
              _imagePaths.icBulletOrder
            ),
            _buildVerticalDivider(),
            _buildIconButton(
              richTextController.orderListTypeApply.value == OrderListType.numberedList,
              () => richTextController.selectOrderListType(OrderListType.numberedList, context),
              _imagePaths.icNumberOrder
            ),
          ],
        );
      }
    ));
  }

  Widget _buildVerticalDivider() {
    return Container(width: 1, color: CommonColor.colorBorderGray);
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
          color: isSelected ? CommonColor.colorBackgroundSelect : Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          height: double.infinity,
          child: LimitedBox(
            maxWidth: 28,
            maxHeight: 28,
            child: SvgPicture.asset(
              asset,
              colorFilter: ColorFilter.mode(
                !isSelected && iconColor != null
                  ? iconColor
                  : CommonColor.colorIconSelect,
                BlendMode.srcIn),
              package: packageName,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
