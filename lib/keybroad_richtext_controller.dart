import 'dart:async';

class KeyboardRichTextController {
  final StreamController<bool> richTextStreamController = StreamController<bool>()..add(true);

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