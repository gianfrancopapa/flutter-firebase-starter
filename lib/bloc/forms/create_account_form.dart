import 'package:firebasestarter/mixins/validation_mixin.dart';
import 'package:rxdart/rxdart.dart';

class CreateAccountFormBloc with ValidationMixin {
  final _firstNameController = BehaviorSubject<String>.seeded('');
  final _lastNameController = BehaviorSubject<String>.seeded('');
  final _emailController = BehaviorSubject<String>.seeded('');
  final _passwordController = BehaviorSubject<String>.seeded('');
  final _passwordConfirmationController = BehaviorSubject<String>.seeded('');

  Stream<String> get firstName =>
      _firstNameController.transform(alphabeticTransfomer);
  Stream<String> get lastName =>
      _lastNameController.transform(alphabeticTransfomer);
  Stream<String> get email => _emailController.transform(emailTransfomer);
  Stream<String> get password =>
      _passwordController.transform(passwordTransfomer);
  Stream<String> get passwordConfirmation =>
      _passwordConfirmationController.transform(passwordTransfomer);

  Function(void) get onFirstNameChanged => _firstNameController.sink.add;
  Function(void) get onLastNameChanged => _lastNameController.sink.add;
  Function(void) get onEmailChanged => _emailController.sink.add;
  Function(void) get onPasswordChanged => _passwordController.sink.add;
  Function(void) get onPasswordConfirmationChanged =>
      _passwordConfirmationController.sink.add;

  Stream<bool> get activateButton => Rx.combineLatest2<String, String, bool>(
        email,
        password,
        (email, password) => true,
      );

  String get firstNameVal => _firstNameController.value;
  String get lastNameVal => _lastNameController.value;
  String get emailVal => _emailController.value;
  String get passwordVal => _passwordController.value;
  String get passwordConfVal => _passwordConfirmationController.value;
}
