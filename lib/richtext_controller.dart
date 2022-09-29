import 'dart:async';

import 'package:enough_html_editor/enough_html_editor.dart';
import 'package:flutter/material.dart' as ui;
import 'package:get/get.dart';
import 'package:rich_text_composer/views/widgets/rich_text_option_bottom_sheet.dart';

enum HeaderStyleType {
  normal,
  blockquote,
  code,
  h1,
  h2,
  h3,
  h4,
  h5,
  h6;

  String get styleName {
    switch (this) {
      case HeaderStyleType.normal:
        return 'Normal';
      case HeaderStyleType.blockquote:
        return 'Quote';
      case HeaderStyleType.code:
        return 'Code';
      case HeaderStyleType.h1:
        return 'Header 1';
      case HeaderStyleType.h2:
        return 'Header 2';
      case HeaderStyleType.h3:
        return 'Header 3';
      case HeaderStyleType.h4:
        return 'Header 4';
      case HeaderStyleType.h5:
        return 'Header 5';
      case HeaderStyleType.h6:
        return 'Header 6';
    }
  }

  String get styleValue {
    switch (this) {
      case HeaderStyleType.normal:
        return 'div';
      case HeaderStyleType.blockquote:
        return 'blockquote';
      case HeaderStyleType.code:
        return 'pre';
      case HeaderStyleType.h1:
        return 'h1';
      case HeaderStyleType.h2:
        return 'h2';
      case HeaderStyleType.h3:
        return 'h3';
      case HeaderStyleType.h4:
        return 'h4';
      case HeaderStyleType.h5:
        return 'h5';
      case HeaderStyleType.h6:
        return 'h6';
    }
  }

  double get textSize {
    switch (this) {
      case HeaderStyleType.normal:
        return 16;
      case HeaderStyleType.blockquote:
        return 16;
      case HeaderStyleType.code:
        return 13;
      case HeaderStyleType.h1:
        return 32;
      case HeaderStyleType.h2:
        return 24;
      case HeaderStyleType.h3:
        return 18;
      case HeaderStyleType.h4:
        return 16;
      case HeaderStyleType.h5:
        return 13;
      case HeaderStyleType.h6:
        return 11;
    }
  }

  ui.FontWeight get fontWeight {
    switch (this) {
      case HeaderStyleType.normal:
      case HeaderStyleType.blockquote:
      case HeaderStyleType.code:
        return ui.FontWeight.normal;
      case HeaderStyleType.h1:
      case HeaderStyleType.h2:
      case HeaderStyleType.h3:
      case HeaderStyleType.h4:
      case HeaderStyleType.h5:
      case HeaderStyleType.h6:
        return ui.FontWeight.bold;
    }
  }
}

enum SpecialStyleType {
  bold,
  italic,
  underline,
  strikeThrough;
}

enum ParagraphType {
  alignLeft,
  alignRight,
  alignCenter,
  justify;
}

enum DentType {
  indent,
  outdent;
}

enum OrderListType {
  bulletedList,
  numberedList;

  String get commandAction {
    switch (this) {
      case OrderListType.bulletedList:
        return 'insertUnorderedList';
      case OrderListType.numberedList:
        return 'insertOrderedList';
    }
  }
}

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

  final isSpecialStyleSelected = [false, false, false, false];

  final isOrderListSelected = [false, false];

  Stream<bool> get richTextStream => richTextStreamController.stream;

  void listenHtmlEditorApi() {
    htmlEditorApi?.onFormatSettingsChanged = (formatSettings) {
      listSpecialTextStyleApply.clear();
      if (formatSettings.isBold) {
        isSpecialStyleSelected[0] = true;
        listSpecialTextStyleApply.add(SpecialStyleType.bold);
      }

      if (formatSettings.isItalic) {
        isSpecialStyleSelected[1] = true;
        listSpecialTextStyleApply.add(SpecialStyleType.italic);
      }

      if (formatSettings.isUnderline) {
        isSpecialStyleSelected[2] = true;
        listSpecialTextStyleApply.add(SpecialStyleType.underline);
      }

      if (formatSettings.isStrikeThrough) {
        isSpecialStyleSelected[3] = true;
        listSpecialTextStyleApply.add(SpecialStyleType.strikeThrough);
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
    if (isTextStyleTypeSelected(SpecialStyleType.bold) &&
        !isSpecialStyleSelected[0]) {
      isSpecialStyleSelected[0] = true;
      await htmlEditorApi?.formatBold();
    }

    if (!isTextStyleTypeSelected(SpecialStyleType.bold) &&
        isSpecialStyleSelected[0]) {
      isSpecialStyleSelected[0] = false;
      await htmlEditorApi?.formatBold();
    }

    if (isTextStyleTypeSelected(SpecialStyleType.italic) &&
        !isSpecialStyleSelected[1]) {
      isSpecialStyleSelected[1] = true;
      await htmlEditorApi?.formatItalic();
    }

    if (!isTextStyleTypeSelected(SpecialStyleType.italic) &&
        isSpecialStyleSelected[1]) {
      isSpecialStyleSelected[1] = false;
      await htmlEditorApi?.formatItalic();
    }

    if (isTextStyleTypeSelected(SpecialStyleType.underline) &&
        !isSpecialStyleSelected[2]) {
      isSpecialStyleSelected[2] = true;
      await htmlEditorApi?.formatUnderline();
    }

    if (!isTextStyleTypeSelected(SpecialStyleType.underline) &&
        isSpecialStyleSelected[2]) {
      isSpecialStyleSelected[2] = false;
      await htmlEditorApi?.formatUnderline();
    }

    if (isTextStyleTypeSelected(SpecialStyleType.strikeThrough) &&
        !isSpecialStyleSelected[3]) {
      isSpecialStyleSelected[3] = true;
      await htmlEditorApi?.formatStrikeThrough();
    }

    if (!isTextStyleTypeSelected(SpecialStyleType.strikeThrough) &&
        isSpecialStyleSelected[3]) {
      isSpecialStyleSelected[3] = false;
      await htmlEditorApi?.formatStrikeThrough();
    }
  }

  void showRichTextBottomSheet(ui.BuildContext context) async {
    await htmlEditorApi?.unfocus();
    await ui.showModalBottomSheet(
      context: context,
      shape: ui.RoundedRectangleBorder(
        borderRadius: ui.BorderRadius.circular(16),
      ),
      backgroundColor: ui.Colors.white,
      builder: (context) => RichTextOptionBottomSheet(
        richTextController: this,
        title: 'Format',
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
