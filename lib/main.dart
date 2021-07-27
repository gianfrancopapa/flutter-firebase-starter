import 'package:firebasestarter/app.dart';
import 'package:firebasestarter/bootstrap.dart';

void main() async {
  bootstrap(
    () async {
      return const App();
    },
  );
}
