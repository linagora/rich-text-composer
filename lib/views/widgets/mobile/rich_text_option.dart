import 'package:flutter/material.dart';
import 'package:rich_text_composer/rich_text_controller.dart';
import 'package:rich_text_composer/views/widgets/format_quick_style.dart';
import 'package:rich_text_composer/views/widgets/list_format_color.dart';
import 'package:rich_text_composer/views/widgets/list_format_dent_style.dart';
import 'package:rich_text_composer/views/widgets/list_format_order.dart';
import 'package:rich_text_composer/views/widgets/list_format_special_style.dart';
import 'package:rich_text_composer/views/widgets/list_paragraph_align.dart';
import 'package:rich_text_composer/views/widgets/responsive/responsive_widget.dart';

class RichTextOption extends StatelessWidget {
  const RichTextOption({
    super.key,
    required this.richTextController,
    this.quickStyleLabel,
    this.foregroundLabel,
    this.backgroundLabel,
    this.onSelectForegroundColor,
    this.onSelectBackgroundColor,
    this.padding,
  });

  final RichTextController richTextController;
  final String? foregroundLabel;
  final String? backgroundLabel;
  final String? quickStyleLabel;
  final VoidCallback? onSelectForegroundColor;
  final VoidCallback? onSelectBackgroundColor;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: padding ?? const EdgeInsetsDirectional.only(
          start: 24,
          end: 24,
          top: 24,
          bottom: 35),
        child: ResponsiveWidget(
          defaultDevice: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListFormatSpecialStyle(richTextController: richTextController),
              const SizedBox(height: 8),
              FormatQuickStyle(richTextController: richTextController, label: quickStyleLabel),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: ListParagraphAlign(richTextController: richTextController)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ListFormatColor(
                      richTextController: richTextController,
                      foregroundColorLabel: foregroundLabel,
                      backgroundColorLabel: backgroundLabel,
                      onSelectBackgroundColor: onSelectBackgroundColor,
                      onSelectForegroundColor: onSelectForegroundColor,
                    )
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: ListFormatDentStyle(richTextController: richTextController)),
                  const SizedBox(width: 8),
                  Expanded(child: ListFormatOrder(richTextController: richTextController)),
                ],
              )
            ],
          ),
          landscapeMobile: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: ListFormatSpecialStyle(richTextController: richTextController)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FormatQuickStyle(
                      richTextController: richTextController,
                      label: quickStyleLabel)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: ListParagraphAlign(richTextController: richTextController)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ListFormatColor(
                      richTextController: richTextController,
                      foregroundColorLabel: foregroundLabel,
                      backgroundColorLabel: backgroundLabel,
                      onSelectBackgroundColor: onSelectBackgroundColor,
                      onSelectForegroundColor: onSelectForegroundColor,
                    )
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: ListFormatDentStyle(richTextController: richTextController)),
                  const SizedBox(width: 8),
                  Expanded(child: ListFormatOrder(richTextController: richTextController)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}