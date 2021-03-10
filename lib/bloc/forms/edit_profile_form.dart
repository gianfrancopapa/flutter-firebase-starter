import 'package:firebasestarter/mixins/validation_mixin.dart';
import 'package:rxdart/rxdart.dart';

class EditProfileFormBloc with ValidationMixin {
  final _firstNameController = BehaviorSubject<String>.seeded('');
  final _lastNameController = BehaviorSubject<String>.seeded('');

  Stream<String> get firstName =>
      _firstNameController.transform(alphabeticTransfomer);

  Stream<String> get lastName =>
      _lastNameController.transform(alphabeticTransfomer);

  Function(void) get onFirstNameChanged => _firstNameController.sink.add;

  Function(void) get onLastNameChanged => _lastNameController.sink.add;

  Stream<bool> get activateButton => Rx.combineLatest2<String, String, bool>(
        firstName,
        lastName,
        (firstName, lastName) => true,
      );

  String get firstNameVal => _firstNameController.value;
  String get lastNameVal => _lastNameController.value;
}
