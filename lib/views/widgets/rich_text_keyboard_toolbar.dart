import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rich_text_composer/richtext_controller.dart';
import 'package:rich_text_composer/views/commons/image_paths.dart';
import 'package:rich_text_composer/views/widgets/list_color.dart';
import 'package:rich_text_composer/views/widgets/mobile/rich_text_option.dart';
import 'package:rich_text_composer/views/widgets/tablet/option_container_for_tablet.dart';

typedef OnTabCallback = void Function();

const String packageName = 'rich_text_composer';

class RichTextKeyboardToolBar extends StatelessWidget {
  final bool? isLandScapeMode;
  final VoidCallback? insertImage;
  final VoidCallback? insertAttachment;
  final ImagePaths _imagePaths = ImagePaths();
  final String titleFormatBottomSheet;
  final String titleBack;
  final String titleQuickStyleBottomSheet;
  final String titleForegroundBottomSheet;
  final String titleBackgroundBottomSheet;
  final RichTextController richTextController;
  final Color backgroundKeyboardToolBarColor;
  final double? heightToolBar;

  RichTextKeyboardToolBar({
    super.key,
    this.insertImage,
    this.insertAttachment,
    this.isLandScapeMode,
    required this.backgroundKeyboardToolBarColor,
    this.heightToolBar = defaultKeyboardToolbarHeight,
    required this.richTextController,
    required this.titleFormatBottomSheet,
    required this.titleForegroundBottomSheet,
    required this.titleBackgroundBottomSheet,
    required this.titleQuickStyleBottomSheet,
    required this.titleBack,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ValueListenableBuilder(
            valueListenable: richTextController.applyRichTextOptionForTablet,
            builder: (context, value, _) {
              return Visibility(
                visible: richTextController.applyRichTextOptionForTablet.value,
                child: _buildRichTechOptionTabletView(),
              );
            }),
        Container(
            height: defaultKeyboardToolbarHeight,
            color: backgroundKeyboardToolBarColor,
            alignment: Alignment.centerLeft,
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
                    onTap: () => insertAttachment?.call(),
                  ),
                if (insertImage != null)
                  _buildIcon(
                    icon: SvgPicture.asset(
                      _imagePaths.icInsertImage,
                      fit: BoxFit.fill,
                      package: packageName,
                    ),
                    onTap: () => insertImage?.call(),
                  ),
                _buildIcon(
                  icon: SvgPicture.asset(
                    _imagePaths.icRichText,
                    color: Colors.black,
                    package: packageName,
                    fit: BoxFit.fill,
                  ),
                  onTap: () {
                    if (richTextController.responsiveUtils.isMobile(context)) {
                      richTextController.showRichTextBottomSheet(
                        context: context,
                        titleFormatBottomSheet: titleFormatBottomSheet,
                        titleQuickStyleBottomSheet: titleQuickStyleBottomSheet,
                        titleForegroundBottomSheet: titleForegroundBottomSheet,
                        titleBackgroundBottomSheet: titleBackgroundBottomSheet,
                      );
                    } else {
                      richTextController.applyRichTextOptionForTablet.value =
                          !richTextController
                              .applyRichTextOptionForTablet.value;
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
      builder: (context, value, _) {
        return Container(
          transform: Matrix4.translationValues(
              richTextController.dxRichTextButtonPosition.value - 34, 0.0, 0.0),
          child: ValueListenableBuilder(
              valueListenable:
                  richTextController.currentIndexStackOverlayRichTextForTablet,
              builder: (context, value, _) {
                return IndexedStack(
                  index: richTextController
                      .currentIndexStackOverlayRichTextForTablet.value,
                  children: [
                    OptionContainerForTablet(
                      richTextController: richTextController,
                      title: titleFormatBottomSheet,
                      child: RichTextOption(
                        richTextController: richTextController,
                        htmlEditorApi: richTextController.htmlEditorApi,
                        titleQuickStyleBottomSheet: titleQuickStyleBottomSheet,
                        titleForegroundBottomSheet: titleForegroundBottomSheet,
                        titleBackgroundBottomSheet: titleBackgroundBottomSheet,
                      ),
                    ),
                    OptionContainerForTablet(
                      padding: EdgeInsets.zero,
                      richTextController: richTextController,
                      titleBack: titleBack,
                      title: titleForegroundBottomSheet,
                      child: ColorPickerKeyboard(
                        onSelected: (color) {
                          richTextController.selectTextColor(color, context);
                        },
                      ),
                    ),
                    OptionContainerForTablet(
                      padding: EdgeInsets.zero,
                      richTextController: richTextController,
                      titleBack: titleBack,
                      title: titleBackgroundBottomSheet,
                      child: ColorPickerKeyboard(
                        onSelected: (color) {
                          richTextController.selectBackgroundColor(color, context);
                        },
                      ),
                    ),
                  ],
                );
              }),
        );
      },
    );
  }

  Widget _buildIcon({
    required Widget icon,
    OnTabCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: InkWell(
        onTap: onTap,
        onTapDown: (details) {
          final double position = details.globalPosition.dx / 30;
          richTextController.dxRichTextButtonPosition.value =
              position.floor() * 30 + 5;
        },
        child: SizedBox(
          width: 30,
          height: 30,
          child: icon,
        ),
      ),
    );
  }
}
