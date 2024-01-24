import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rich_text_composer/rich_text_controller.dart';
import 'package:rich_text_composer/views/commons/colors.dart';
import 'package:rich_text_composer/views/commons/constants.dart';
import 'package:rich_text_composer/views/commons/image_paths.dart';
import 'package:rich_text_composer/views/commons/logger.dart';
import 'package:rich_text_composer/views/commons/responsive_utils.dart';
import 'package:rich_text_composer/views/widgets/button/keyboard_button.dart';
import 'package:rich_text_composer/views/widgets/color_picker_keyboard.dart';
import 'package:rich_text_composer/views/widgets/mobile/rich_text_option.dart';
import 'package:rich_text_composer/views/widgets/tablet/option_container_for_tablet.dart';

class RichTextKeyboardToolBar extends StatelessWidget {
  final BuildContext rootContext;
  final VoidCallback? insertImage;
  final VoidCallback? insertAttachment;
  final String? titleFormatBottomSheet;
  final String? titleBack;
  final String? titleQuickStyleBottomSheet;
  final String? titleForegroundBottomSheet;
  final String? titleBackgroundBottomSheet;
  final RichTextController richTextController;
  final Color backgroundKeyboardToolBarColor;
  final double? heightToolBar;
  final EdgeInsets? paddingToolbar;
  final EdgeInsetsGeometry? iconPadding;
  final EdgeInsetsGeometry? iconMargin;

  const RichTextKeyboardToolBar({
    super.key,
    required this.rootContext,
    required this.richTextController,
    this.insertImage,
    this.insertAttachment,
    this.backgroundKeyboardToolBarColor = CommonColor.colorBackgroundToolBar,
    this.heightToolBar = defaultKeyboardToolbarHeight,
    this.paddingToolbar,
    this.iconPadding,
    this.iconMargin,
    this.titleFormatBottomSheet,
    this.titleForegroundBottomSheet,
    this.titleBackgroundBottomSheet,
    this.titleQuickStyleBottomSheet,
    this.titleBack
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!ResponsiveUtils().isMobile(context))
          ValueListenableBuilder(
            valueListenable: richTextController.applyRichTextOptionForTablet,
            builder: (_, __, ___) {
              return Visibility(
                visible: richTextController.applyRichTextOptionForTablet.value,
                child: _buildRichTechOptionTabletView(),
              );
            }),
        Container(
            height: defaultKeyboardToolbarHeight,
            color: backgroundKeyboardToolBarColor,
            alignment: ResponsiveUtils().isLandscapeMobile(context)
              ? AlignmentDirectional.center
              : AlignmentDirectional.centerStart,
            padding: paddingToolbar,
            child: SafeArea(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (insertAttachment != null)
                    KeyboardButton(
                      key: const Key('insert_attachment_button'),
                      onTapAction: insertAttachment,
                      margin: iconMargin ?? const EdgeInsetsDirectional.only(start: 4),
                      padding: iconPadding ?? const EdgeInsets.all(12),
                      child: SvgPicture.asset(
                        ImagePaths().icAttachmentsComposer,
                        colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                        fit: BoxFit.fill,
                        package: packageName,
                      ),
                    ),
                  if (insertImage != null)
                    KeyboardButton(
                      key: const Key('insert_image_button'),
                      onTapAction: insertImage,
                      margin: iconMargin ?? const EdgeInsetsDirectional.only(start: 4),
                      padding: iconPadding ?? const EdgeInsets.all(12),
                      child: SvgPicture.asset(
                        ImagePaths().icInsertImage,
                        colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                        fit: BoxFit.fill,
                        package: packageName,
                      ),
                    ),
                  KeyboardButton(
                    key: const Key('open_format_option_button'),
                    onTapAction: ResponsiveUtils().isMobile(context)
                      ? () => _showMobileFormatOption(rootContext)
                      : null,
                    onTapDownAction: !ResponsiveUtils().isMobile(context)
                      ? _showTabletFormatOption
                      : null,
                    margin: iconMargin ?? const EdgeInsetsDirectional.only(start: 4),
                    padding: iconPadding ?? const EdgeInsets.all(12),
                    child: SvgPicture.asset(
                      ImagePaths().icRichText,
                      colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
                      fit: BoxFit.fill,
                      package: packageName,
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildRichTechOptionTabletView() {
    return ValueListenableBuilder(
      valueListenable: richTextController.dxRichTextButtonPosition,
      builder: (context, _, __) {
        return Container(
          transform: Matrix4.translationValues(
              richTextController.dxRichTextButtonPosition.value.toDouble() - 35.0,
              0.0,
              0.0),
          child: ValueListenableBuilder(
              valueListenable: richTextController.currentIndexStackOverlayRichTextForTablet,
              builder: (context, value, _) {
                return LayoutBuilder(builder: (context, constraint) {
                  return Stack(
                    children: [
                      if (value == 0)
                        OptionContainerForTablet(
                          richTextController: richTextController,
                          title: titleFormatBottomSheet ?? 'Format',
                          child: RichTextOption(
                            richTextController: richTextController,
                            titleQuickStyleBottomSheet: titleQuickStyleBottomSheet,
                            titleForegroundBottomSheet: titleForegroundBottomSheet,
                            titleBackgroundBottomSheet: titleBackgroundBottomSheet,
                          ),
                        ),
                      if (value == 1)
                        ValueListenableBuilder(
                            valueListenable: richTextController.selectedTextColor,
                            builder: (context, _, __) {
                              return OptionContainerForTablet(
                                richTextController: richTextController,
                                titleBack: titleBack ?? 'Format',
                                title: titleForegroundBottomSheet ?? 'Foreground',
                                child: ColorPickerKeyboard(
                                  currentColor: richTextController.selectedTextColor.value,
                                  onSelected: (color) {
                                    richTextController.selectTextColor(color);
                                  },
                                ),
                              );
                            }),
                      if (value == 2)
                        ValueListenableBuilder(
                            valueListenable: richTextController.selectedTextBackgroundColor,
                            builder: (context, _, __) {
                              return OptionContainerForTablet(
                                richTextController: richTextController,
                                titleBack: titleBack ?? 'Format',
                                title: titleBackgroundBottomSheet ?? 'Background',
                                child: ColorPickerKeyboard(
                                  currentColor: richTextController.selectedTextBackgroundColor.value,
                                  onSelected: (color) {
                                    richTextController.selectBackgroundColor(color);
                                  },
                                ),
                              );
                            })
                    ],
                  );
                });
              }),
        );
      },
    );
  }

  void _showMobileFormatOption(BuildContext context) async {
    log('RichTextKeyboardToolBar::_showMobileFormatOption:');
    if (Platform.isIOS) {
      await richTextController.htmlEditorApi?.unfocus();
    } else if (Platform.isAndroid) {
      await richTextController.htmlEditorApi?.hideKeyboard();
    }
    if (context.mounted) {
      await richTextController.showFormatOptionBottomSheet(
        context: context,
        titleFormatBottomSheet: titleFormatBottomSheet,
        titleQuickStyleBottomSheet: titleQuickStyleBottomSheet,
        titleForegroundBottomSheet: titleForegroundBottomSheet,
        titleBackgroundBottomSheet: titleBackgroundBottomSheet,
      );
    } else {
      logError('RichTextKeyboardToolBar::_showMobileFormatOption: CONTEXT UNMOUNTED');
    }
  }

  void _showTabletFormatOption(TapDownDetails details) {
    final dxPosition = details.globalPosition.dx;
    log('RichTextKeyboardToolBar::_showTabletFormatOption:dxPosition: $dxPosition');
    richTextController.dxRichTextButtonPosition.value = dxPosition.floor();

    final newStateRichTextOptionForTablet = !richTextController.applyRichTextOptionForTablet.value;
    richTextController.applyRichTextOptionForTablet.value = newStateRichTextOptionForTablet;
  }
}
