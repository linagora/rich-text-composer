import 'package:rich_text_composer/views/commons/assets_paths.dart';

class ImagePaths {
  static ImagePaths? _instance;

  ImagePaths._();

  factory ImagePaths() => _instance ??= ImagePaths._();

  String get icRichText => _getImagePath('ic_rich_text.svg');
  String get icInsertImage => _getImagePath('ic_insert_image.svg');
  String get icAttachmentsComposer => _getImagePath('ic_attachments_composer.svg');
  String get icDismiss => _getImagePath('ic_dismiss.svg');
  String get icBoldStyle => _getImagePath('ic_bold_style.svg');
  String get icItalicStyle => _getImagePath('ic_italic_style.svg');
  String get icStrikeThrough => _getImagePath('ic_strike_through.svg');
  String get icUnderLine => _getImagePath('ic_under_line.svg');
  String get icArrowRight => _getImagePath('ic_arrow_right.svg');
  String get icAlignCenter => _getImagePath('ic_align_center.svg');
  String get icAlignLeft => _getImagePath('ic_align_left.svg');
  String get icAlignRight => _getImagePath('ic_align_right.svg');
  String get icTextColor => _getImagePath('ic_text_color.svg');
  String get icBackgroundColor => _getImagePath('ic_background_color.svg');
  String get icIndentFormat => _getImagePath('ic_indent_format.svg');
  String get icOutDentFormat => _getImagePath('ic_outdent_format.svg');
  String get icBulletOrder => _getImagePath('ic_bullet_order.svg');
  String get icNumberOrder => _getImagePath('ic_number_order.svg');
  String get icBack => _getImagePath('ic_back.svg');

  String _getImagePath(String imageName) {
    return AssetsPaths.images + imageName;
  }
}