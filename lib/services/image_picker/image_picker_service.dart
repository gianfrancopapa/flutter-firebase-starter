import 'package:firebasestarter/services/image_picker/image_service.dart';
import 'package:image_picker/image_picker.dart';

class PickImageService implements ImageService {
  final _imagePicker = ImagePicker();

  @override
  Future<PickedFile> imgFromCamera() async => _getImage(ImageSource.camera);

  @override
  Future<PickedFile> imgFromGallery() async => _getImage(ImageSource.gallery);

  Future<PickedFile> _getImage(source) async {
    final image = await _imagePicker.getImage(source: source, imageQuality: 50);
    return image;
  }
}
