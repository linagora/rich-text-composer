import 'dart:async';

class RichTextAppendController {
  final StreamController<bool> richTextAppendStreamController = StreamController<bool>();

  Stream<bool> get richTextAppendStream => richTextAppendStreamController.stream;

  void showRichTextView() {
    richTextAppendStreamController.sink.add(true);
  }

  void hideRichTextView() {
    richTextAppendStreamController.sink.add(false);
  }

  void dispose() {
    richTextAppendStreamController.close();
  }}