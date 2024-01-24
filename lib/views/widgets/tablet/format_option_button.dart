import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart' as portal;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rich_text_composer/rich_text_composer.dart';
import 'package:rich_text_composer/views/commons/constants.dart';
import 'package:rich_text_composer/views/commons/image_paths.dart';
import 'package:rich_text_composer/views/widgets/button/keyboard_button.dart';
import 'package:rich_text_composer/views/widgets/tablet/tablet_format_option_overlay.dart';

class FormatOptionButton extends StatefulWidget {

  final RichTextController richTextController;
  final EdgeInsetsGeometry? iconMargin;
  final EdgeInsetsGeometry? iconPadding;
  final String? formatLabel;
  final String? foregroundLabel;
  final String? backgroundLabel;
  final String? quickStyleLabel;

  const FormatOptionButton({
    super.key,
    required this.richTextController,
    this.iconMargin,
    this.iconPadding,
    this.formatLabel,
    this.foregroundLabel,
    this.backgroundLabel,
    this.quickStyleLabel,
  });

  @override
  State<FormatOptionButton> createState() => _FormatOptionButtonState();
}

class _FormatOptionButtonState extends State<FormatOptionButton> {

  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return portal.PortalTarget(
      visible: _visible,
      portalFollower: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => setState(() => _visible = false)
      ),
      child: portal.PortalTarget(
        anchor: const portal.Aligned(
          follower: Alignment.bottomLeft,
          target: Alignment.topLeft,
        ),
        portalFollower: TabletFormatOptionOverlay(
          richTextController: widget.richTextController,
          formatLabel: widget.formatLabel,
          quickStyleLabel: widget.quickStyleLabel,
          foregroundLabel: widget.foregroundLabel,
          backgroundLabel: widget.backgroundLabel,
          onCloseAction: () => setState(() => _visible = false),
        ),
        visible: _visible,
        child: KeyboardButton(
          onTapAction: () => setState(() => _visible = true),
          margin: widget.iconMargin ?? const EdgeInsetsDirectional.only(start: 4),
          padding: widget.iconPadding ?? const EdgeInsets.all(12),
          child: SvgPicture.asset(
            ImagePaths().icRichText,
            fit: BoxFit.fill,
            package: packageName,
          ),
        )
      )
    );
  }
}