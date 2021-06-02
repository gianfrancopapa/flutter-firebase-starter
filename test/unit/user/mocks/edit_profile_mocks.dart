import 'package:firebasestarter/bloc/forms/edit_profile_form.dart';
import 'package:firebasestarter/services/image_picker/image_service.dart';
import 'package:firebasestarter/services/storage/storage_service.dart';
import 'package:mockito/mockito.dart';

class MockStorageService extends Mock implements StorageService {}

class MockImageService extends Mock implements ImageService {}

class MockEditProfileFormBloc extends Mock implements EditProfileFormBloc {}
