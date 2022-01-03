import 'package:firebase_starter_ui/firebase_starter_ui.dart';
import 'package:firebasestarter/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Image(
          image: AssetImage(
              Assets.packages.firebaseStarterUi.assets.images.somnioLogo.path),
          height: 220.0,
          width: 220.0,
        ),
      ),
      backgroundColor: FSColors.white,
    );
  }
}
