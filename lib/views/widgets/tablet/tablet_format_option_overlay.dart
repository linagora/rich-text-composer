import 'package:flutter/material.dart';
import 'package:rich_text_composer/rich_text_composer.dart';
import 'package:rich_text_composer/views/widgets/color_picker_keyboard.dart';
import 'package:rich_text_composer/views/widgets/mobile/rich_text_option.dart';
import 'package:rich_text_composer/views/widgets/tablet/format_option_view_type.dart';
import 'package:rich_text_composer/views/widgets/tablet/option_container_for_tablet.dart';

class TabletFormatOptionOverlay extends StatefulWidget {
  final RichTextController richTextController;
  final String? formatLabel;
  final String? foregroundLabel;
  final String? backgroundLabel;
  final String? quickStyleLabel;
  final VoidCallback? onCloseAction;

  const TabletFormatOptionOverlay({
    super.key,
    required this.richTextController,
    this.formatLabel,
    this.foregroundLabel,
    this.backgroundLabel,
    this.quickStyleLabel,
    this.onCloseAction,
  });

  @override
  State<TabletFormatOptionOverlay> createState() => _TabletFormatOptionOverlayState();
}

class _TabletFormatOptionOverlayState extends State<TabletFormatOptionOverlay> {
  late FormatOptionViewType _viewType;

  @override
  void initState() {
    super.initState();
    _viewType = FormatOptionViewType.origin;
  }

  @override
  Widget build(BuildContext context) {
    switch (_viewType) {
      case FormatOptionViewType.origin:
        return OptionContainerForTablet(
          key: const Key('format_option_view'),
          richTextController: widget.richTextController,
          title: widget.formatLabel ?? 'Format',
          onCloseAction: widget.onCloseAction,
          child: RichTextOption(
            richTextController: widget.richTextController,
            quickStyleLabel: widget.quickStyleLabel,
            foregroundLabel: widget.foregroundLabel,
            backgroundLabel: widget.backgroundLabel,
            onSelectBackgroundColor: () => setState(() => _viewType = FormatOptionViewType.selectBackground),
            onSelectForegroundColor: () => setState(() => _viewType = FormatOptionViewType.selectForeground),
          ),
        );
      case FormatOptionViewType.selectForeground:
        return OptionContainerForTablet(
          key: const Key('select_foreground_color_view'),
          richTextController: widget.richTextController,
          titleBack: widget.formatLabel ?? 'Format',
          title: widget.foregroundLabel ?? 'Foreground',
          onBackAction: () => setState(() => _viewType = FormatOptionViewType.origin),
          onCloseAction: widget.onCloseAction,
          child: ValueListenableBuilder(
            valueListenable: widget.richTextController.selectedTextColor,
            builder: (context, _, __) {
              return ColorPickerKeyboard(
                key: const Key('foreground_color_picker_view'),
                currentColor: widget.richTextController.selectedTextColor.value,
                onSelected: widget.richTextController.selectTextColor);
            }
          ),
        );
      case FormatOptionViewType.selectBackground:
        return OptionContainerForTablet(
          key: const Key('select_background_color_view'),
          richTextController: widget.richTextController,
          titleBack: widget.formatLabel ?? 'Format',
          title: widget.backgroundLabel ?? 'Background',
          onBackAction: () => setState(() => _viewType = FormatOptionViewType.origin),
          onCloseAction: widget.onCloseAction,
          child: ValueListenableBuilder(
            valueListenable: widget.richTextController.selectedTextBackgroundColor,
            builder: (context, _, __) {
              return ColorPickerKeyboard(
                key: const Key('background_color_picker_view'),
                currentColor: widget.richTextController.selectedTextBackgroundColor.value,
                onSelected: widget.richTextController.selectBackgroundColor);
            }
          ),
        );
    }
  }
}
