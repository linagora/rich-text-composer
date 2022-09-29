import 'dart:async';

import 'package:enough_html_editor/enough_html_editor.dart';
import 'package:flutter/material.dart' as ui;
import 'package:flutter/material.dart';
import 'package:rich_text_composer/views/widgets/rich_text_option_bottom_sheet.dart';

import 'models/types.dart';

class RichTextController {
  HtmlEditorApi? htmlEditorApi;

  final listSpecialTextStyleApply = ValueNotifier<Set<SpecialStyleType>>({});
  final paragraphTypeApply = ValueNotifier<ParagraphType>(ParagraphType.alignLeft);
  final dentTypeApply = ValueNotifier<DentType?>(null);
  final orderListTypeApply = ValueNotifier<OrderListType?>(null);
  final selectedTextColor = ValueNotifier<ui.Color>(ui.Colors.black);
  final selectedTextBackgroundColor = ValueNotifier<ui.Color>(ui.Colors.white);
  final headerStyleTypeApply = ValueNotifier<HeaderStyleType>(HeaderStyleType.normal);

  final StreamController<bool> richTextStreamController =
      StreamController<bool>();

  bool isBoldStyleAppended = false;
  bool isItalicStyleAppended = false;
  bool isUnderlineAppended = false;
  bool isStrikeThroughAppended = false;

  Stream<bool> get richTextStream => richTextStreamController.stream;

  void listenHtmlEditorApi() {
    htmlEditorApi?.onFormatSettingsChanged = (formatSettings) {
      if (formatSettings.isBold) {
        isBoldStyleAppended = true;
        listSpecialTextStyleApply.value.add(SpecialStyleType.bold);
        listSpecialTextStyleApply.notifyListeners();
      } else {
        listSpecialTextStyleApply.value.remove(SpecialStyleType.bold);
        isBoldStyleAppended = false;
        listSpecialTextStyleApply.notifyListeners();
      }

      if (formatSettings.isItalic) {
        isItalicStyleAppended = true;
        listSpecialTextStyleApply.value.add(SpecialStyleType.italic);
        listSpecialTextStyleApply.notifyListeners();
      } else {
        listSpecialTextStyleApply.value.remove(SpecialStyleType.italic);
        isItalicStyleAppended = false;
        listSpecialTextStyleApply.notifyListeners();
      }

      if (formatSettings.isUnderline) {
        isUnderlineAppended = true;
        listSpecialTextStyleApply.value.add(SpecialStyleType.underline);
        listSpecialTextStyleApply.notifyListeners();
      } else {
        listSpecialTextStyleApply.value.remove(SpecialStyleType.underline);
        isUnderlineAppended = false;
        listSpecialTextStyleApply.notifyListeners();
      }

      if (formatSettings.isStrikeThrough) {
        isStrikeThroughAppended = true;
        listSpecialTextStyleApply.value.add(SpecialStyleType.strikeThrough);
        listSpecialTextStyleApply.notifyListeners();
      } else {
        listSpecialTextStyleApply.value.remove(SpecialStyleType.strikeThrough);
        isStrikeThroughAppended = false;
        listSpecialTextStyleApply.notifyListeners();
      }
    };
  }

  selectTextStyleType(SpecialStyleType richTextStyleType) {
    if (listSpecialTextStyleApply.value.contains(richTextStyleType)) {
      listSpecialTextStyleApply.value.remove(richTextStyleType);
    } else {
      listSpecialTextStyleApply.value.add(richTextStyleType);
    }
    listSpecialTextStyleApply.notifyListeners();
  }

  selectTextColor(ui.Color color) {
    selectedTextColor.value = color;
  }

  selectBackgroundColor(ui.Color color) {
    selectedTextBackgroundColor.value = color;
  }

  bool isTextStyleTypeSelected(SpecialStyleType richTextStyleType) {
    return listSpecialTextStyleApply.value.contains(richTextStyleType);

  }

  Future<void> appendSpecialRichText() async {
    if (isTextStyleTypeSelected(SpecialStyleType.bold) != isBoldStyleAppended) {
      await htmlEditorApi?.formatBold();
    }

    if (isTextStyleTypeSelected(SpecialStyleType.italic) != isItalicStyleAppended) {
      await htmlEditorApi?.formatItalic();
    }

    if (isTextStyleTypeSelected(SpecialStyleType.underline) != isUnderlineAppended) {
      await htmlEditorApi?.formatUnderline();
    }

    if (isTextStyleTypeSelected(SpecialStyleType.strikeThrough) != isStrikeThroughAppended) {
      await htmlEditorApi?.formatStrikeThrough();
    }
  }

  void showRichTextBottomSheet({
    required ui.BuildContext context,
    required String titleFormatBottomSheet,
    required String titleQuickStyleBottomSheet,
    required String titleForegroundBottomSheet,
    required String titleBackgroundBottomSheet,
  }) async {
    await htmlEditorApi?.unfocus();
    await ui.showModalBottomSheet(
      context: context,
      shape: ui.RoundedRectangleBorder(
        borderRadius: ui.BorderRadius.circular(16),
      ),
      backgroundColor: ui.Colors.white,
      builder: (context) => RichTextOptionBottomSheet(
        richTextController: this,
        title: titleFormatBottomSheet,
        titleQuickStyleBottomSheet: titleQuickStyleBottomSheet,
        titleForegroundBottomSheet: titleForegroundBottomSheet,
        titleBackgroundBottomSheet: titleBackgroundBottomSheet,
      ),
    );
  }

  Future<void> applyHeaderStyle() async {
    await htmlEditorApi?.formatHeader(headerStyleTypeApply.value.styleValue);
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
    htmlEditorApi?.setColorTextForeground(selectedTextColor.value);
  }

  Future<void> applyBackgroundTextColor() async {
    htmlEditorApi?.setColorTextBackground(selectedTextBackgroundColor.value);
  }

  selectOrderListType(OrderListType orderListType) {
    if (orderListTypeApply.value == orderListType) {
      orderListTypeApply.value = null;
    } else {
      orderListTypeApply.value = orderListType;
    }
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
    richTextStreamController.sink.add(true);
  }

  void hideRichTextView() {
    richTextStreamController.sink.add(false);
  }

  Future<void> editorOnFocus() async {
    await applyParagraphType();
    await applyOrderListType();
    await applyDentType();
    await applyHeaderStyle();
    await appendSpecialRichText();
    await applyTextColor();
    await applyBackgroundTextColor();
    showRichTextView();
  }

  void onCreateHTMLEditor(HtmlEditorApi editorApi) {
    htmlEditorApi = editorApi;
    editorApi.onFocus = editorOnFocus;
    editorApi.onFocusOut = () {
      hideRichTextView();
    };
    listenHtmlEditorApi();
  }

  void dispose() {
    richTextStreamController.close();
  }
}
