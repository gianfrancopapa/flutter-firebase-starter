import 'package:image_picker/image_picker.dart';

class PickImageService {
  static final _imagePicker = ImagePicker();

  static Future<PickedFile> imgFromCamera() async =>
      _getImage(ImageSource.camera);

  static Future<PickedFile> imgFromGallery() async =>
      _getImage(ImageSource.gallery);

  static Future<PickedFile> _getImage(source) async {
    final image = await _imagePicker.getImage(source: source, imageQuality: 50);
    return image;
  }
}
