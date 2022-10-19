import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rich_text_composer/richtext_controller.dart';
import 'package:rich_text_composer/views/commons/colors.dart';
import 'package:rich_text_composer/views/commons/image_paths.dart';
import 'package:rich_text_composer/views/commons/utils/responsive_utils.dart';
import 'package:rich_text_composer/views/widgets/color_picker_keyboard.dart';
import 'package:rich_text_composer/views/widgets/mobile/rich_text_option.dart';
import 'package:rich_text_composer/views/widgets/tablet/option_container_for_tablet.dart';

typedef OnTabCallback = void Function();

const String packageName = 'rich_text_composer';

class RichTextKeyboardToolBar extends StatelessWidget {
  final bool? isLandScapeMode;
  final VoidCallback? insertImage;
  final VoidCallback? insertAttachment;
  final String titleFormatBottomSheet;
  final String titleBack;
  final String titleQuickStyleBottomSheet;
  final String titleForegroundBottomSheet;
  final String titleBackgroundBottomSheet;
  final RichTextController richTextController;
  final Color backgroundKeyboardToolBarColor;
  final double? heightToolBar;
  final EdgeInsets? paddingToolbar;
  final EdgeInsets? paddingIcon;

  final ImagePaths _imagePaths = ImagePaths();
  final ResponsiveUtils _responsiveUtils = ResponsiveUtils();

  RichTextKeyboardToolBar({
    super.key,
    required this.richTextController,
    this.insertImage,
    this.insertAttachment,
    this.isLandScapeMode,
    this.backgroundKeyboardToolBarColor = CommonColor.colorBackgroundToolBar,
    this.heightToolBar = defaultKeyboardToolbarHeight,
    this.paddingToolbar,
    this.paddingIcon,
    this.titleFormatBottomSheet = 'Format',
    this.titleForegroundBottomSheet = 'Foreground',
    this.titleBackgroundBottomSheet = 'Background',
    this.titleQuickStyleBottomSheet = 'Quick styles',
    this.titleBack = 'Format',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ValueListenableBuilder(
            valueListenable: richTextController.applyRichTextOptionForTablet,
            builder: (context, _, __) {
              return Visibility(
                visible: richTextController.applyRichTextOptionForTablet.value,
                child: _buildRichTechOptionTabletView(),
              );
            }),
        Container(
            height: defaultKeyboardToolbarHeight,
            color: backgroundKeyboardToolBarColor,
            alignment: Alignment.centerLeft,
            padding: paddingToolbar,
            child: Row(
              mainAxisAlignment: isLandScapeMode == true
                  ? MainAxisAlignment.spaceEvenly
                  : MainAxisAlignment.start,
              children: [
                if (insertAttachment != null)
                  _buildIcon(
                    icon: SvgPicture.asset(
                      _imagePaths.icAttachmentsComposer,
                      color: Colors.black,
                      fit: BoxFit.fill,
                      package: packageName,
                    ),
                    padding: paddingIcon,
                    onTap: () => insertAttachment?.call(),
                  ),
                if (insertImage != null)
                  _buildIcon(
                    icon: SvgPicture.asset(
                      _imagePaths.icInsertImage,
                      fit: BoxFit.fill,
                      package: packageName,
                    ),
                    padding: paddingIcon,
                    onTap: () => insertImage?.call(),
                  ),
                _buildIcon(
                  icon: SvgPicture.asset(
                    _imagePaths.icRichText,
                    color: Colors.black,
                    package: packageName,
                    fit: BoxFit.fill,
                  ),
                  padding: paddingIcon,
                  onTap: () async {
                    if (_responsiveUtils.isMobileResponsive(context)) {
                      if (Platform.isAndroid) {
                        await richTextController.htmlEditorApi?.storeSelectionRange();
                      } else {
                        await richTextController.htmlEditorApi?.unfocus();
                      }

                      richTextController.showRichTextBottomSheet(
                        context: context,
                        titleFormatBottomSheet: titleFormatBottomSheet,
                        titleQuickStyleBottomSheet: titleQuickStyleBottomSheet,
                        titleForegroundBottomSheet: titleForegroundBottomSheet,
                        titleBackgroundBottomSheet: titleBackgroundBottomSheet,
                      );
                    } else {
                      final newStateRichTextOptionForTablet = !richTextController.applyRichTextOptionForTablet.value;
                      richTextController.applyRichTextOptionForTablet.value = newStateRichTextOptionForTablet;
                    }
                  },
                ),
              ],
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
                          title: titleFormatBottomSheet,
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
                                titleBack: titleBack,
                                title: titleForegroundBottomSheet,
                                child: ColorPickerKeyboard(
                                  currentColor: richTextController.selectedTextColor.value,
                                  onSelected: (color) {
                                    richTextController.selectTextColor(color, context);
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
                                titleBack: titleBack,
                                title: titleBackgroundBottomSheet,
                                child: ColorPickerKeyboard(
                                  currentColor: richTextController.selectedTextBackgroundColor.value,
                                  onSelected: (color) {
                                    richTextController.selectBackgroundColor(color, context);
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

  Widget _buildIcon({
    required Widget icon,
    OnTabCallback? onTap,
    EdgeInsets? padding,
  }) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(left: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          onTapDown: (details) {
            final double position = details.globalPosition.dx;
            richTextController.dxRichTextButtonPosition.value = position.floor();
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            child: icon,
          ),
        ),
      ),
    );
  }
}
