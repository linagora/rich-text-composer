import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/route_manager.dart';
import 'package:rich_text_composer/views/commons/image_paths.dart';
import 'package:rich_text_composer/views/widgets/rich_text_option_bottom_sheet.dart';
import 'package:enough_html_editor/enough_html_editor.dart' as html_editor;

typedef OnTabCallback = void Function();

const String packageName = 'rich_text_composer';

class RichTextKeyboardToolBar extends StatelessWidget {
  final bool? isLandScapeMode;
  final VoidCallback insertImage;
  final VoidCallback insertAttachment;
  final ImagePaths _imagePaths = ImagePaths();
  final html_editor.HtmlEditorApi? htmlEditorApi;

  RichTextKeyboardToolBar({
    super.key,
    required this.insertImage,
    required this.insertAttachment,
    this.isLandScapeMode,
    this.htmlEditorApi,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isLandScapeMode == true
          ? MainAxisAlignment.spaceEvenly
          : MainAxisAlignment.start,
      children: [
        _buildIcon(
          iconPadding: EdgeInsets.zero,
          icon: SvgPicture.asset(
            _imagePaths.icAttachmentsComposer,
            color: Colors.black,
            fit: BoxFit.fill,
            package: packageName,
          ),
          onTap: () => insertAttachment(),
        ),
        _buildIcon(
          iconPadding: EdgeInsets.zero,
          icon: SvgPicture.asset(
            _imagePaths.icInsertImage,
            fit: BoxFit.fill,
            package: packageName,
          ),
          onTap: () => insertImage(),
        ),
        _buildIcon(
          iconPadding: EdgeInsets.zero,
          icon: SvgPicture.asset(
            _imagePaths.icRichText,
            color: Colors.black,
            package: packageName,
            fit: BoxFit.fill,
          ),
          onTap: () async {
            htmlEditorApi?.unfocus();
            await Get.bottomSheet(
              RichTextOptionBottomSheet(
                title: 'Format',
              ),
              useRootNavigator: true,
            );
            htmlEditorApi?.moveCursorAtLastNode();
          },
        ),
      ],
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
