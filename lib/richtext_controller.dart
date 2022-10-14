import 'dart:async';

import 'package:enough_html_editor/enough_html_editor.dart';
import 'package:flutter/material.dart' as ui;
import 'package:flutter/material.dart';
import 'package:rich_text_composer/views/commons/utils/responsive_utils.dart';
import 'package:rich_text_composer/views/widgets/list_header_style.dart';
import 'package:rich_text_composer/views/widgets/mobile/option_bottom_sheet.dart';
import 'package:rich_text_composer/views/widgets/mobile/rich_text_option.dart';

import 'models/types.dart';

const double defaultKeyboardToolbarHeight = 48;

class RichTextController {
  HtmlEditorApi? htmlEditorApi;

  final listSpecialTextStyleApply = ValueNotifier<Set<SpecialStyleType>>({});
  final paragraphTypeApply =
      ValueNotifier<ParagraphType>(ParagraphType.alignLeft);
  final dentTypeApply = ValueNotifier<DentType?>(null);
  final orderListTypeApply = ValueNotifier<OrderListType?>(null);
  final applyRichTextOptionForTablet = ValueNotifier<bool>(false);
  final selectedTextColor = ValueNotifier<ui.Color>(ui.Colors.black);
  final selectedTextBackgroundColor = ValueNotifier<ui.Color>(ui.Colors.white);
  final headerStyleTypeApply = ValueNotifier<HeaderStyleType>(HeaderStyleType.normal);
  final dxRichTextButtonPosition = ValueNotifier<int>(35);
  final currentIndexStackOverlayRichTextForTablet = ValueNotifier<int>(0);

  final StreamController<bool> richTextStreamController = StreamController<bool>.broadcast();
  final ResponsiveUtils responsiveUtils = ResponsiveUtils();

  bool isBoldStyleAppended = false;
  bool isItalicStyleAppended = false;
  bool isUnderlineAppended = false;
  bool isStrikeThroughAppended = false;
  int _currentLine = 1;

  int get currentLine => _currentLine;

  Stream<bool> get richTextStream => richTextStreamController.stream;

  void listenHtmlEditorApi() {
    htmlEditorApi?.onFormatSettingsChanged = (formatSettings) {
      if (formatSettings.isBold) {
        isBoldStyleAppended = true;
        listSpecialTextStyleApply.value =
            Set.from(listSpecialTextStyleApply.value)
              ..add(SpecialStyleType.bold);
      } else {
        listSpecialTextStyleApply.value =
            Set.from(listSpecialTextStyleApply.value)
              ..remove(SpecialStyleType.bold);
        isBoldStyleAppended = false;
      }

      if (formatSettings.isItalic) {
        isItalicStyleAppended = true;
        listSpecialTextStyleApply.value =
            Set.from(listSpecialTextStyleApply.value)
              ..add(SpecialStyleType.italic);
      } else {
        isItalicStyleAppended = false;
        listSpecialTextStyleApply.value =
            Set.from(listSpecialTextStyleApply.value)
              ..remove(SpecialStyleType.italic);
      }

      if (formatSettings.isUnderline) {
        isUnderlineAppended = true;
        listSpecialTextStyleApply.value =
            Set.from(listSpecialTextStyleApply.value)
              ..add(SpecialStyleType.underline);
      } else {
        listSpecialTextStyleApply.value =
            Set.from(listSpecialTextStyleApply.value)
              ..remove(SpecialStyleType.underline);
        isUnderlineAppended = false;
      }

      if (formatSettings.isStrikeThrough) {
        isStrikeThroughAppended = true;
        listSpecialTextStyleApply.value =
            Set.from(listSpecialTextStyleApply.value)
              ..add(SpecialStyleType.strikeThrough);
      } else {
        listSpecialTextStyleApply.value =
            Set.from(listSpecialTextStyleApply.value)
              ..remove(SpecialStyleType.strikeThrough);
        isStrikeThroughAppended = false;
      }
    };
  }

  void selectTextStyleType(SpecialStyleType richTextStyleType, BuildContext context) {
    if (listSpecialTextStyleApply.value.contains(richTextStyleType)) {
      listSpecialTextStyleApply.value =
          Set.from(listSpecialTextStyleApply.value)..remove(richTextStyleType);
    } else {
      listSpecialTextStyleApply.value =
          Set.from(listSpecialTextStyleApply.value)..add(richTextStyleType);
    }
    if (!responsiveUtils.isMobile(context)) {
      applySpecialRichText();
    }
  }

  void selectTextColor(ui.Color color, BuildContext context) {
    selectedTextColor.value = color;
    if (!responsiveUtils.isMobile(context)) {
      applyTextColor();
    }
  }

  void selectBackgroundColor(ui.Color color, BuildContext context) {
    selectedTextBackgroundColor.value = color;
    if (!responsiveUtils.isMobile(context)) {
      applyBackgroundTextColor();
    }
  }

  void selectParagraphType(ParagraphType paragraphType, BuildContext context) {
    paragraphTypeApply.value = paragraphType;
    if (!responsiveUtils.isMobile(context)) {
      applyParagraphType();
    }
  }

  void selectDentTypeType(DentType dentType, BuildContext context) {
    dentTypeApply.value = dentType;
    if (!responsiveUtils.isMobile(context)) {
      applyDentType();
    }
  }

  void selectOrderListType(OrderListType orderListType, BuildContext context) {
    if (orderListTypeApply.value == orderListType) {
      orderListTypeApply.value = null;
    } else {
      orderListTypeApply.value = orderListType;
    }

    if (!responsiveUtils.isMobile(context)) {
      applyOrderListType();
    }
  }

  bool isTextStyleTypeSelected(SpecialStyleType richTextStyleType) {
    return listSpecialTextStyleApply.value.contains(richTextStyleType);
  }

  void showDialogSelectHeaderStyle(
    BuildContext context,
    String titleQuickStyleBottomSheet,
  ) {
    AlertDialog dialog = AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: SizedBox(
        width: 448,
        height: 436,
        child: OptionBottomSheet(
          title: titleQuickStyleBottomSheet,
          child: ListHeaderStyle(
            itemSelected: (item) {
              Navigator.of(context).pop();
              headerStyleTypeApply.value = item;
              applyHeaderStyle();
            },
          ),
        ),
      ),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
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
      builder: (context) => OptionBottomSheet(
        title: titleFormatBottomSheet,
        child: RichTextOption(
          richTextController: this,
          titleQuickStyleBottomSheet: titleQuickStyleBottomSheet,
          titleForegroundBottomSheet: titleForegroundBottomSheet,
          titleBackgroundBottomSheet: titleBackgroundBottomSheet,
        ),
      ),
    );
  }

  Future<void> applySpecialRichText() async {
    if (isTextStyleTypeSelected(SpecialStyleType.bold) != isBoldStyleAppended) {
      await htmlEditorApi?.formatBold();
      isBoldStyleAppended = !isBoldStyleAppended;
    }

    if (isTextStyleTypeSelected(SpecialStyleType.italic) !=
        isItalicStyleAppended) {
      await htmlEditorApi?.formatItalic();
      isItalicStyleAppended = !isItalicStyleAppended;
    }

    if (isTextStyleTypeSelected(SpecialStyleType.underline) !=
        isUnderlineAppended) {
      await htmlEditorApi?.formatUnderline();
      isUnderlineAppended = !isUnderlineAppended;
    }

    if (isTextStyleTypeSelected(SpecialStyleType.strikeThrough) !=
        isStrikeThroughAppended) {
      await htmlEditorApi?.formatStrikeThrough();
      isStrikeThroughAppended = !isStrikeThroughAppended;
    }
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

  Future<void> editorOnFocus(VoidCallback? onFocus, BuildContext context) async {
    if(responsiveUtils.isMobile(context)) {
      await Future.wait([
        applyParagraphType(),
        applyOrderListType(),
        applyDentType(),
        applyHeaderStyle(),
        applySpecialRichText(),
        applyTextColor(),
        applyBackgroundTextColor(),
      ]);
    }
    onFocus?.call();
    showRichTextView();
  }

  void onCreateHTMLEditor(
    HtmlEditorApi editorApi, {
    VoidCallback? onFocus,
    VoidCallback? onEnterKeyDown,
    required BuildContext context,
  }) {
    htmlEditorApi = editorApi;
    editorApi.onFocus = () {
      editorOnFocus.call(onFocus, context);
    };

    editorApi.onKeyDown = () {
      onEnterKeyDown?.call();
      _currentLine++;
    };

    editorApi.onFocusOut = () {
      hideRichTextView();
    };
    listenHtmlEditorApi();
  }

  void dispose() {
    richTextStreamController.close();
    applyRichTextOptionForTablet.dispose();
    listSpecialTextStyleApply.dispose();
    paragraphTypeApply.dispose();
    dentTypeApply.dispose();
    orderListTypeApply.dispose();
    selectedTextColor.dispose();
    selectedTextBackgroundColor.dispose();
    headerStyleTypeApply.dispose();
    dxRichTextButtonPosition.dispose();
  }
}
