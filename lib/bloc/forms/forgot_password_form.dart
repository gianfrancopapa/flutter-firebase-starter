import 'package:firebasestarter/mixins/validation_mixin.dart';
import 'package:rxdart/rxdart.dart';

class ForgotPasswordFormBloc with ValidationMixin {
  final _emailController = BehaviorSubject<String>.seeded('');

  ForgotPasswordFormBloc();

  Stream<String> get email => _emailController.transform(emailTransfomer);

  Function(void) get onEmailChanged => _emailController.sink.add;

  String get emailValue => _emailController.value;
}
