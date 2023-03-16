import 'dart:async';
import 'dart:io' show Platform;

import 'package:enough_html_editor/enough_html_editor.dart' as enough_html_editor;
import 'package:flutter/material.dart';
import 'package:rich_text_composer/views/commons/utils/responsive_utils.dart';
import 'package:rich_text_composer/views/widgets/dialog/dialog_utils.dart';
import 'package:rich_text_composer/views/widgets/mobile/option_bottom_sheet.dart';
import 'package:rich_text_composer/views/widgets/mobile/rich_text_option.dart';

import 'models/types.dart';

const double defaultKeyboardToolbarHeight = 48;

class RichTextController {
  enough_html_editor.HtmlEditorApi? htmlEditorApi;

  final listSpecialTextStyleApply = ValueNotifier<Set<SpecialStyleType>>({});
  final paragraphTypeApply = ValueNotifier<ParagraphType>(ParagraphType.alignLeft);
  final dentTypeApply = ValueNotifier<DentType?>(null);
  final orderListTypeApply = ValueNotifier<OrderListType?>(null);
  final applyRichTextOptionForTablet = ValueNotifier<bool>(false);
  final selectedTextColor = ValueNotifier<Color>(Colors.black);
  final selectedTextBackgroundColor = ValueNotifier<Color>(Colors.white);
  final dxRichTextButtonPosition = ValueNotifier<int>(35);
  final currentIndexStackOverlayRichTextForTablet = ValueNotifier<int>(0);

  final StreamController<bool> richTextStreamController = StreamController<bool>.broadcast();
  final ResponsiveUtils responsiveUtils = ResponsiveUtils();

  bool isBoldStyleAppended = false;
  bool isItalicStyleAppended = false;
  bool isUnderlineAppended = false;
  bool isStrikeThroughAppended = false;

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

    htmlEditorApi?.onAlignSettingsChanged = (elementAlign) {
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
    };

    htmlEditorApi?.onColorChanged = (colorSetting) {
      if (colorSetting.textForeground != null) {
        selectedTextColor.value = colorSetting.textForeground!;
      }

      if (colorSetting.textBackground != null) {
        selectedTextBackgroundColor.value = colorSetting.textBackground!;
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

    if (Platform.isAndroid) {
      if (!responsiveUtils.isMobileResponsive(context)) {
        applySpecialRichText(context);
      }
    } else {
      applySpecialRichText(context);
    }
  }

  void selectTextColor(Color color, BuildContext context) {
    selectedTextColor.value = color;
    if (Platform.isAndroid) {
      if (!responsiveUtils.isMobileResponsive(context)) {
        applyTextColor(context);
      }
    } else {
      applyTextColor(context);
    }
  }

  void selectBackgroundColor(Color color, BuildContext context) {
    selectedTextBackgroundColor.value = color;
    if (Platform.isAndroid) {
      if (!responsiveUtils.isMobileResponsive(context)) {
        applyBackgroundTextColor(context);
      }
    } else {
      applyBackgroundTextColor(context);
    }
  }

  void selectParagraphType(ParagraphType paragraphType, BuildContext context) {
    paragraphTypeApply.value = paragraphType;
    applyParagraphType();
  }

  void selectDentTypeType(DentType dentType, BuildContext context) {
    dentTypeApply.value = dentType;
    applyDentType();
  }

  void selectOrderListType(OrderListType orderListType, BuildContext context) {
    if (orderListTypeApply.value == orderListType) {
      orderListTypeApply.value = null;
    } else {
      orderListTypeApply.value = orderListType;
    }
    applyOrderListType();
  }

  bool isTextStyleTypeSelected(SpecialStyleType richTextStyleType) {
    return listSpecialTextStyleApply.value.contains(richTextStyleType);
  }

  void showRichTextBottomSheet({
    required BuildContext context,
    required String titleFormatBottomSheet,
    required String titleQuickStyleBottomSheet,
    required String titleForegroundBottomSheet,
    required String titleBackgroundBottomSheet,
  }) {
    DialogUtils.showDialogBottomSheet(context, OptionBottomSheet(
      title: titleFormatBottomSheet,
      child: RichTextOption(
        richTextController: this,
        titleQuickStyleBottomSheet: titleQuickStyleBottomSheet,
        titleForegroundBottomSheet: titleForegroundBottomSheet,
        titleBackgroundBottomSheet: titleBackgroundBottomSheet,
      )
    ));
  }

  Future<void> applySpecialRichText(BuildContext context) async {
    if (Platform.isAndroid && responsiveUtils.isMobileResponsive(context)) {
      await htmlEditorApi?.restoreSelectionRange();
    }

    if (isTextStyleTypeSelected(SpecialStyleType.bold) != isBoldStyleAppended) {
      await htmlEditorApi?.formatBold();
      isBoldStyleAppended = !isBoldStyleAppended;
    }

    if (isTextStyleTypeSelected(SpecialStyleType.italic) != isItalicStyleAppended) {
      await htmlEditorApi?.formatItalic();
      isItalicStyleAppended = !isItalicStyleAppended;
    }

    if (isTextStyleTypeSelected(SpecialStyleType.underline) != isUnderlineAppended) {
      await htmlEditorApi?.formatUnderline();
      isUnderlineAppended = !isUnderlineAppended;
    }

    if (isTextStyleTypeSelected(SpecialStyleType.strikeThrough) != isStrikeThroughAppended) {
      await htmlEditorApi?.formatStrikeThrough();
      isStrikeThroughAppended = !isStrikeThroughAppended;
    }
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

  Future<void> applyTextColor(BuildContext context) async {
    if (Platform.isAndroid && responsiveUtils.isMobileResponsive(context)) {
      await htmlEditorApi?.restoreSelectionRange();
    }
    htmlEditorApi?.setColorTextForeground(selectedTextColor.value);
  }

  Future<void> applyBackgroundTextColor(BuildContext context) async {
    if (Platform.isAndroid && responsiveUtils.isMobileResponsive(context)) {
      await htmlEditorApi?.restoreSelectionRange();
    }
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

  void editorOnFocus(VoidCallback? onFocus, BuildContext context) async {
    if (Platform.isAndroid && responsiveUtils.isMobileResponsive(context)) {
      await Future.wait([
        applySpecialRichText(context),
        applyTextColor(context),
        applyBackgroundTextColor(context),
      ]);
    }
    onFocus?.call();
    showRichTextView();
  }

  void onCreateHTMLEditor(
    enough_html_editor.HtmlEditorApi editorApi, {
    VoidCallback? onFocus,
    VoidCallback? onEnterKeyDown,
    Function(List<int>?)? onChangeCursor,
    required BuildContext context,
  }) {
    htmlEditorApi = editorApi;
    editorApi.onFocus = () {
      editorOnFocus.call(onFocus, context);
    };

    editorApi.onKeyDown = () {
      onEnterKeyDown?.call();
    };

    editorApi.onFocusOut = () {
      hideRichTextView();
    };

    editorApi.onCursorCoordinatesChanged = (coordinates) {
      onChangeCursor?.call(coordinates);
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
    dxRichTextButtonPosition.dispose();
  }
}
