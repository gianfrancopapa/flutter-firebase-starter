import 'package:image_picker/image_picker.dart';

import 'image_picker.dart';

class PickImageService implements ImageService {
  final _imagePicker = ImagePicker();

  @override
  Future<XFile?> imgFromCamera() async => _getImage(ImageSource.camera);

  @override
  Future<XFile?> imgFromGallery() async => _getImage(ImageSource.gallery);

  Future<XFile?> _getImage(source) async {
    final image =
        await _imagePicker.pickImage(source: source, imageQuality: 50);
    return image;
  }
}
