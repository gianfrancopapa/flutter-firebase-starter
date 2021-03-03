import 'package:image_picker/image_picker.dart';

abstract class ImageService {
  Future<PickedFile> imgFromCamera();
  Future<PickedFile> imgFromGallery();
}
