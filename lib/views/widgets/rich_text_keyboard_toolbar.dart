import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rich_text_composer/richtext_controller.dart';
import 'package:rich_text_composer/views/commons/image_paths.dart';
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
                    iconPadding: EdgeInsets.zero,
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
                    iconPadding: EdgeInsets.zero,
                    icon: SvgPicture.asset(
                      _imagePaths.icInsertImage,
                      fit: BoxFit.fill,
                      package: packageName,
                    ),
                    onTap: () => insertImage?.call(),
                  ),
                _buildIcon(
                  iconPadding: EdgeInsets.zero,
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
    return OptionContainerForTablet(
      title: titleFormatBottomSheet,
      child: RichTextOption(
        richTextController: richTextController,
        htmlEditorApi: richTextController.htmlEditorApi,
        titleQuickStyleBottomSheet: titleQuickStyleBottomSheet,
        titleForegroundBottomSheet: titleForegroundBottomSheet,
        titleBackgroundBottomSheet: titleBackgroundBottomSheet,
      ),
    );
  }

  Widget _buildIcon({
    required Widget icon,
    OnTabCallback? onTap,
    EdgeInsets? iconPadding,
    double? iconSize,
    double? splashRadius,
    double? minSize,
    Color? colorSelected,
    Color? colorFocus,
    ShapeBorder? shapeBorder,
  }) {
    return Material(
        color: colorSelected ?? Colors.transparent,
        shape: shapeBorder ?? const CircleBorder(),
        child: IconButton(
            icon: icon,
            focusColor: colorFocus,
            iconSize: iconSize,
            constraints: minSize != null
                ? BoxConstraints(minWidth: minSize, minHeight: minSize)
                : null,
            padding: iconPadding ?? const EdgeInsets.all(8.0),
            splashRadius: splashRadius ?? 15,
            onPressed: onTap));
  }
}
