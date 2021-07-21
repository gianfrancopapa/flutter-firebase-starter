import 'package:flutter/material.dart';
import 'package:firebasestarter/constants/assets.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Image(
          image: AssetImage(Assets.somnioLogo),
          height: 220.0,
          width: 220.0,
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
