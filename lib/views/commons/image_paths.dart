import 'package:rich_text_composer/views/commons/assets_paths.dart';

class ImagePaths {
  String get icRichText => _getImagePath('ic_rich_text.svg');
  String get icInsertImage => _getImagePath('ic_insert_image.svg');
  String get icAttachmentsComposer => _getImagePath('ic_attachments_composer.svg');
  String get icDismiss => _getImagePath('ic_dismiss.svg');
  String get icBoldStyle => _getImagePath('ic_bold_style.svg');
  String get icItalicStyle => _getImagePath('ic_italic_style.svg');
  String get icStrikeThrough => _getImagePath('ic_strike_through.svg');
  String get icUnderLine => _getImagePath('ic_under_line.svg');
  String get icArrowRight => _getImagePath('ic_arrow_right.svg');

  String _getImagePath(String imageName) {
    return AssetsPaths.images + imageName;
  }
}