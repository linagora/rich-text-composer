import 'package:rich_text_composer/views/commons/assets_paths.dart';

class ImagePaths {
  String get icRichText => _getImagePath('ic_rich_text.svg');
  String get icInsertImage => _getImagePath('ic_insert_image.svg');
  String get icAttachmentsComposer => _getImagePath('ic_attachments_composer.svg');

  String _getImagePath(String imageName) {
    return AssetsPaths.images + imageName;
  }
}