import 'dart:async';
import 'dart:io';

import 'package:enough_html_editor/enough_html_editor.dart' as enough_html_editor;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rich_text_composer/views/commons/logger.dart';
import 'package:rich_text_composer/views/widgets/dialog/dialog_utils.dart';
import 'package:rich_text_composer/views/widgets/mobile/option_bottom_sheet.dart';
import 'package:rich_text_composer/views/widgets/mobile/rich_text_option.dart';

import 'models/types.dart';

class RichTextController {
  static const MethodChannel _methodChannel = MethodChannel('rich_text_composer');

  enough_html_editor.HtmlEditorApi? htmlEditorApi;

  final listSpecialTextStyleApply = ValueNotifier<Set<SpecialStyleType>>({});
  final paragraphTypeApply = ValueNotifier<ParagraphType>(ParagraphType.alignLeft);
  final dentTypeApply = ValueNotifier<DentType?>(null);
  final orderListTypeApply = ValueNotifier<OrderListType?>(null);
  final selectedTextColor = ValueNotifier<Color>(Colors.black);
  final selectedTextBackgroundColor = ValueNotifier<Color>(Colors.white);
  final dxRichTextButtonPosition = ValueNotifier<int>(35);
  final richTextToolbarNotifier = ValueNotifier<bool>(false);

  Future<void> selectTextStyleType(SpecialStyleType styleType) async {
    log('RichTextController::selectTextStyleType:StyleType = $styleType');
    final currentStyles = listSpecialTextStyleApply.value;
    if (currentStyles.contains(styleType)) {
      currentStyles.remove(styleType);
    } else {
      currentStyles.add(styleType);
    }

    listSpecialTextStyleApply.value = {...currentStyles};

    switch (styleType) {
      case SpecialStyleType.bold:
        await htmlEditorApi?.formatBold();
        break;
      case SpecialStyleType.italic:
        await htmlEditorApi?.formatItalic();
        break;
      case SpecialStyleType.underline:
        await htmlEditorApi?.formatUnderline();
        break;
      case SpecialStyleType.strikeThrough:
        await htmlEditorApi?.formatStrikeThrough();
        break;
    }
    log('RichTextController::selectTextStyleType:ListSpecialTextStyleApply = ${listSpecialTextStyleApply.value}');
  }

  void selectTextColor(Color color) {
    selectedTextColor.value = color;
    applyTextColor();
  }

  void selectBackgroundColor(Color color) {
    selectedTextBackgroundColor.value = color;
    applyBackgroundTextColor();
  }

  void selectParagraphType(ParagraphType paragraphType) {
    paragraphTypeApply.value = paragraphType;
    applyParagraphType();
  }

  void selectDentTypeType(DentType dentType) {
    dentTypeApply.value = dentType;
    applyDentType();
  }

  void selectOrderListType(OrderListType orderListType) {
    if (orderListTypeApply.value == orderListType) {
      orderListTypeApply.value = null;
    } else {
      orderListTypeApply.value = orderListType;
    }
    applyOrderListType();
  }

  Future<void> showFormatOptionBottomSheet({
    required BuildContext context,
    String? formatLabel,
    String? foregroundLabel,
    String? backgroundLabel,
    String? quickStyleLabel,
  }) async {
    await DialogUtils().showDialogBottomSheet(
      context,
      OptionBottomSheet(
        title: formatLabel ?? 'Format',
        child: RichTextOption(
          richTextController: this,
          quickStyleLabel: quickStyleLabel,
          foregroundLabel: foregroundLabel,
          backgroundLabel: backgroundLabel,
          padding: const EdgeInsets.all(24),
        )
      )
    ).whenComplete(showDeviceKeyboard);
  }

  void applyHeaderStyle(HeaderStyleType styleType) async {
    await htmlEditorApi?.formatHeader(styleType.styleValue);
  }

  Future<void> applyParagraphType() async {
    switch (paragraphTypeApply.value) {
      case ParagraphType.alignLeft:
        await htmlEditorApi?.formatAlignLeft();
        return;
      case ParagraphType.alignRight:
        await htmlEditorApi?.formatAlignRight();
        return;
      case ParagraphType.alignCenter:
        await htmlEditorApi?.formatAlignCenter();
        return;
      case ParagraphType.justify:
        await htmlEditorApi?.formatAlignJustify();
        return;
    }
  }

  Future<void> applyDentType() async {
    switch (dentTypeApply.value) {
      case DentType.indent:
        await htmlEditorApi?.formatIndent();
        dentTypeApply.value = null;
        return;
      case DentType.outdent:
        await htmlEditorApi?.formatOutent();
        dentTypeApply.value = null;
        return;
      default:
        return;
    }
  }

  Future<void> applyTextColor() async {
    await htmlEditorApi?.setColorTextForeground(selectedTextColor.value);
  }

  Future<void> applyBackgroundTextColor() async {
    await htmlEditorApi?.setColorTextBackground(selectedTextBackgroundColor.value);
  }

  Future<void> applyOrderListType() async {
    switch (orderListTypeApply.value) {
      case OrderListType.bulletedList:
        await htmlEditorApi?.insertUnorderedList();
        orderListTypeApply.value = null;
        return;
      case OrderListType.numberedList:
        await htmlEditorApi?.insertOrderedList();
        orderListTypeApply.value = null;
        return;
      default:
        return;
    }
  }

  void showRichTextView() {
    richTextToolbarNotifier.value = true;
  }

  void hideRichTextView() {
    richTextToolbarNotifier.value = false;
  }

  void _onFocusEditor(VoidCallback? onFocus) {
    log('RichTextController::_onFocusEditor:');
    showRichTextView();
    onFocus?.call();
  }

  void onCreateHTMLEditor(
    enough_html_editor.HtmlEditorApi editorApi, {
    VoidCallback? onFocus,
    VoidCallback? onFocusOut,
    VoidCallback? onEnterKeyDown,
    Function(List<int>?)? onChangeCursor,
  }) {
    htmlEditorApi = editorApi
      ..onFocus = (() => _onFocusEditor(onFocus))
      ..onKeyDown = onEnterKeyDown
      ..onFocusOut = onFocusOut
      ..onCursorCoordinatesChanged = onChangeCursor
      ..onFormatSettingsChanged = _onFormatSettingsChanged
      ..onAlignSettingsChanged = _onAlignSettingsChanged
      ..onColorChanged = _onColorChanged;
  }

  void _onFormatSettingsChanged(
    enough_html_editor.FormatSettings formatSettings,
  ) {
    log(
      'RichTextController::_onFormatSettingsChanged:'
      ' isBold = ${formatSettings.isBold} |'
      ' isItalic = ${formatSettings.isItalic} |'
      ' isUnderline = ${formatSettings.isUnderline} |'
      ' isStrikeThrough = ${formatSettings.isStrikeThrough}',
    );

    final updatedStyles = <SpecialStyleType>{};

    if (formatSettings.isBold) {
     updatedStyles.add(SpecialStyleType.bold);
    }
    if (formatSettings.isItalic) {
      updatedStyles.add(SpecialStyleType.italic);
    }
    if (formatSettings.isUnderline) {
      updatedStyles.add(SpecialStyleType.underline);
    }
    if (formatSettings.isStrikeThrough) {
      updatedStyles.add(SpecialStyleType.strikeThrough);
    }

    listSpecialTextStyleApply.value = updatedStyles;
    log('RichTextController::_onFormatSettingsChanged:ListSpecialTextStyleApply = ${listSpecialTextStyleApply.value}');
  }


  void _onAlignSettingsChanged(enough_html_editor.ElementAlign elementAlign) {
    log('RichTextController::_onAlignSettingsChanged: elementAlign = $elementAlign');
    switch(elementAlign) {
      case enough_html_editor.ElementAlign.left:
        paragraphTypeApply.value = ParagraphType.alignLeft;
        break;
      case enough_html_editor.ElementAlign.center:
        paragraphTypeApply.value = ParagraphType.alignCenter;
        break;
      case enough_html_editor.ElementAlign.right:
        paragraphTypeApply.value = ParagraphType.alignRight;
        break;
      case enough_html_editor.ElementAlign.justify:
        paragraphTypeApply.value = ParagraphType.justify;
        break;
    }
  }

  void _onColorChanged(enough_html_editor.ColorSetting colorSetting) {
    log('RichTextController::_onColorChanged: colorSetting = $colorSetting');
    if (colorSetting.textForeground != null) {
      selectedTextColor.value = colorSetting.textForeground!;
    }
    if (colorSetting.textBackground != null) {
      selectedTextBackgroundColor.value = colorSetting.textBackground!;
    }
  }

  Future<void> showDeviceKeyboard() async {
    try {
      if (Platform.isAndroid) {
        await _methodChannel.invokeMethod('showSoftInput');
      } else if (Platform.isIOS) {
        await htmlEditorApi?.requestFocus();
      } else {
        log('RichTextController::showSoftInput: PLATFORM NOT SUPPORTED');
      }
    } catch (e) {
      logError('RichTextController::showDeviceKeyboard: $e');
    }
  }

  void dispose() {
    richTextToolbarNotifier.dispose();
    listSpecialTextStyleApply.dispose();
    paragraphTypeApply.dispose();
    dentTypeApply.dispose();
    orderListTypeApply.dispose();
    selectedTextColor.dispose();
    selectedTextBackgroundColor.dispose();
    dxRichTextButtonPosition.dispose();
  }
}
