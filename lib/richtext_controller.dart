import 'dart:async';

class RichTextController {
  final StreamController<bool> richTextStreamController = StreamController<bool>();

  Stream<bool> get richTextStream => richTextStreamController.stream;

  void showRichTextView() {
    richTextStreamController.sink.add(true);
  }

  void hideRichTextView() {
    richTextStreamController.sink.add(false);
  }

  void dispose() {
    richTextStreamController.close();
  }}