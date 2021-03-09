import 'package:flutter/material.dart';
import 'package:firebasestarter/constants/assets.dart';

class Splash extends StatelessWidget {
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
