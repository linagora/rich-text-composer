import 'dart:async';

import 'package:enough_html_editor/enough_html_editor.dart';
import 'package:flutter/material.dart' as ui;
import 'package:get/get.dart';
import 'package:rich_text_composer/views/widgets/rich_text_option_bottom_sheet.dart';

import 'models/types.dart';

class RichTextController {
  HtmlEditorApi? htmlEditorApi;

  final listSpecialTextStyleApply = RxSet<SpecialStyleType>();
  final paragraphTypeApply = Rx<ParagraphType>(ParagraphType.alignLeft);
  final dentTypeApply = Rxn<DentType>();
  final orderListTypeApply = Rxn<OrderListType>();
  final selectedTextColor = ui.Colors.black.obs;
  final selectedTextBackgroundColor = ui.Colors.white.obs;
  final headerStyleTypeApply = Rx<HeaderStyleType>(HeaderStyleType.normal);

  final StreamController<bool> richTextStreamController =
      StreamController<bool>();

  bool isBoldStyleAppended = false;
  bool isItalicStyleAppended = false;
  bool isUnderlineAppended = false;
  bool isStrikeThroughAppended = false;

  final isOrderListSelected = [false, false];

  Stream<bool> get richTextStream => richTextStreamController.stream;

  void listenHtmlEditorApi() {
    htmlEditorApi?.onFormatSettingsChanged = (formatSettings) {
      if (formatSettings.isBold) {
        isBoldStyleAppended = true;
        listSpecialTextStyleApply.add(SpecialStyleType.bold);
      } else {
        isBoldStyleAppended = false;
      }

      if (formatSettings.isItalic) {
        isItalicStyleAppended = true;
        listSpecialTextStyleApply.add(SpecialStyleType.italic);
      } else {
        isItalicStyleAppended = false;
      }

      if (formatSettings.isUnderline) {
        isUnderlineAppended = true;
        listSpecialTextStyleApply.add(SpecialStyleType.underline);
      } else {
        isUnderlineAppended = false;
      }

      if (formatSettings.isStrikeThrough) {
        isStrikeThroughAppended = true;
        listSpecialTextStyleApply.add(SpecialStyleType.strikeThrough);
      } else {
        isStrikeThroughAppended = false;
      }
    };
  }

  selectTextStyleType(SpecialStyleType richTextStyleType) {
    if (listSpecialTextStyleApply.contains(richTextStyleType)) {
      listSpecialTextStyleApply.remove(richTextStyleType);
    } else {
      listSpecialTextStyleApply.add(richTextStyleType);
    }
  }

  selectTextColor(ui.Color color) {
    selectedTextColor.value = color;
  }

  selectBackgroundColor(ui.Color color) {
    selectedTextBackgroundColor.value = color;
  }

  bool isTextStyleTypeSelected(SpecialStyleType richTextStyleType) {
    return listSpecialTextStyleApply.contains(richTextStyleType);
  }

  Future<void> appendSpecialRichText() async {
    if (isTextStyleTypeSelected(SpecialStyleType.bold) != isBoldStyleAppended) {
      await htmlEditorApi?.formatBold();
    }

    if (isTextStyleTypeSelected(SpecialStyleType.italic) != isBoldStyleAppended) {
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
        if (!isOrderListSelected[0]) {
          await htmlEditorApi?.insertUnorderedList();
          isOrderListSelected[0] = true;
          isOrderListSelected[1] = false;
        }
        return;
      case OrderListType.numberedList:
        if (!isOrderListSelected[1]) {
          await htmlEditorApi?.insertOrderedList();
          isOrderListSelected[0] = false;
          isOrderListSelected[1] = true;
        }
        return;
      default:
        if (isOrderListSelected[0]) {
          await htmlEditorApi?.insertUnorderedList();
        }

        if (isOrderListSelected[1]) {
          await htmlEditorApi?.insertOrderedList();
        }

        isOrderListSelected[0] = false;
        isOrderListSelected[1] = false;
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
