import 'package:firebasestarter/mixins/validation_mixin.dart';
import 'package:rxdart/rxdart.dart';

class LoginFormBloc with ValidationMixin {
  final _emailController = BehaviorSubject<String>.seeded('');
  final _passwordController = BehaviorSubject<String>.seeded('');

  LoginFormBloc();

  Stream<String> get email => _emailController.transform(emailTransfomer);
  Stream<String> get password =>
      _passwordController.transform(passwordTransfomer);
  Stream<bool> get activateButton => Rx.combineLatest2<String, String, bool>(
        email,
        password,
        (email, password) => true,
      );

  Function(void) get onEmailChanged => _emailController.sink.add;
  Function(void) get onPasswordChanged => _passwordController.sink.add;

  String get emailValue => _emailController.value;
  String get passwordValue => _passwordController.value;

  Future<void> close() async {
    await _emailController.close();
    await _passwordController.close();
  }
}
