import 'dart:async';

import 'package:enough_html_editor/enough_html_editor.dart';
import 'package:flutter/material.dart';
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
    switch(this) {
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

  FontWeight get fontWeight {
    switch(this) {
      case HeaderStyleType.normal:
      case HeaderStyleType.blockquote:
      case HeaderStyleType.code:
        return FontWeight.normal;
      case HeaderStyleType.h1:
      case HeaderStyleType.h2:
      case HeaderStyleType.h3:
      case HeaderStyleType.h4:
      case HeaderStyleType.h5:
      case HeaderStyleType.h6:
        return FontWeight.bold;
    }
  }
}

enum SpecialStyleType {
  bold,
  italic,
  underline,
  strikeThrough;
}

class RichTextController {

  HtmlEditorApi? htmlEditorApi;

  final listSpecialTextStyleApply = RxSet<SpecialStyleType>();
  final headerStyleTypeApply = Rx<HeaderStyleType>(HeaderStyleType.normal);

  final StreamController<bool> richTextStreamController = StreamController<bool>();

  final isSpecialStyleSelected = [false, false, false, false];


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

  bool isTextStyleTypeSelected(SpecialStyleType richTextStyleType) {
    return listSpecialTextStyleApply.contains(richTextStyleType);
  }

  void appendSpecialRichText() {
    if (isTextStyleTypeSelected(SpecialStyleType.bold) && !isSpecialStyleSelected[0]) {
      isSpecialStyleSelected[0] = true;
      htmlEditorApi?.formatBold();
    }

    if (!isTextStyleTypeSelected(SpecialStyleType.bold) && isSpecialStyleSelected[0]) {
      isSpecialStyleSelected[0] = false;
      htmlEditorApi?.formatBold();
    }

    if (isTextStyleTypeSelected(SpecialStyleType.italic) && !isSpecialStyleSelected[1]) {
      isSpecialStyleSelected[1] = true;
      htmlEditorApi?.formatItalic();
    }

    if (!isTextStyleTypeSelected(SpecialStyleType.italic) && isSpecialStyleSelected[1]) {
      isSpecialStyleSelected[1] = false;
      htmlEditorApi?.formatItalic();
    }

    if (isTextStyleTypeSelected(SpecialStyleType.underline) && !isSpecialStyleSelected[2]) {
      isSpecialStyleSelected[2] = true;
      htmlEditorApi?.formatUnderline();
    }

    if (!isTextStyleTypeSelected(SpecialStyleType.underline) && isSpecialStyleSelected[2]) {
      isSpecialStyleSelected[2] = false;
      htmlEditorApi?.formatUnderline();
    }

    if (isTextStyleTypeSelected(SpecialStyleType.strikeThrough) && !isSpecialStyleSelected[3]) {
      isSpecialStyleSelected[3] = true;
      htmlEditorApi?.formatStrikeThrough();
    }

    if (!isTextStyleTypeSelected(SpecialStyleType.strikeThrough) && isSpecialStyleSelected[3]) {
      isSpecialStyleSelected[3] = false;
      htmlEditorApi?.formatStrikeThrough();
    }
  }

  void showRichTextBottomSheet(BuildContext context) async {
    await htmlEditorApi?.removeVirtualKeyboard();
    await showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: Colors.white,
      builder: (context) => RichTextOptionBottomSheet(
        richTextController: this,
        title: 'Format',
      ),
    );
    await htmlEditorApi?.ableVirtualKeyboard();
  }

  Future<void> applyHeaderStyle() async {
    await htmlEditorApi?.formatHeader(headerStyleTypeApply.value.styleValue);
  }

  void showRichTextView() {
    richTextStreamController.sink.add(true);
  }

  void hideRichTextView() {
    richTextStreamController.sink.add(false);
  }

  void dispose() {
    richTextStreamController.close();
  }}