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
import 'package:rich_text_composer/views/widgets/tablet/format_option_button.dart';

class RichTextKeyboardToolBar extends StatelessWidget {
  final BuildContext rootContext;
  final VoidCallback? insertImage;
  final VoidCallback? insertAttachment;
  final String? formatLabel;
  final String? titleBack;
  final String? quickStyleLabel;
  final String? foregroundLabel;
  final String? backgroundLabel;
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
    this.formatLabel,
    this.foregroundLabel,
    this.backgroundLabel,
    this.quickStyleLabel,
    this.titleBack
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  fit: BoxFit.fill,
                  package: packageName,
                ),
              ),
            if (ResponsiveUtils().isMobile(context))
              KeyboardButton(
                key: const Key('open_format_option_button'),
                onTapAction: () => _showMobileFormatOption(rootContext),
                margin: iconMargin ?? const EdgeInsetsDirectional.only(start: 4),
                padding: iconPadding ?? const EdgeInsets.all(12),
                child: SvgPicture.asset(
                  ImagePaths().icRichText,
                  fit: BoxFit.fill,
                  package: packageName,
                ),
              )
            else
              FormatOptionButton(
                key: const Key('open_format_option_button'),
                richTextController: richTextController,
                formatLabel: formatLabel,
                quickStyleLabel: quickStyleLabel,
                foregroundLabel: foregroundLabel,
                backgroundLabel: backgroundLabel,
              )
          ],
        ),
      )
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
        formatLabel: formatLabel,
        quickStyleLabel: quickStyleLabel,
        foregroundLabel: foregroundLabel,
        backgroundLabel: backgroundLabel,
      );
    } else {
      logError('RichTextKeyboardToolBar::_showMobileFormatOption: CONTEXT UNMOUNTED');
    }
  }
}
