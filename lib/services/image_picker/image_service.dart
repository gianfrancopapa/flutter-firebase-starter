import 'package:image_picker/image_picker.dart';

abstract class ImageService {
  Future<XFile?> imgFromCamera();

  Future<XFile?> imgFromGallery();
}
