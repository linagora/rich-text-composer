import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rich_text_composer/views/commons/image_paths.dart';

typedef IconWebCallback = void Function();
const String packageName = 'rich_text_composer';

class RichTextKeyboardToolBar extends StatelessWidget {
  final bool? isLandScapeMode;
  final VoidCallback insertImage;
  final VoidCallback insertAttachment;
  final VoidCallback appendRickText;

  final ImagePaths _imagePaths = ImagePaths();

  RichTextKeyboardToolBar({
    super.key,
    required this.insertImage,
    required this.insertAttachment,
    required this.appendRickText,
    this.isLandScapeMode,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isLandScapeMode == true ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.start,
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
          onTap: () => appendRickText(),
        ),
      ],
    );
  }

  Widget _buildIcon({
    required Widget icon,
    IconWebCallback? onTap,
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
