import 'dart:io';
import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  final File image;
  const ProfileImage({this.image});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Image.file(
          image,
          width: 100,
          height: 100,
          fit: BoxFit.fitHeight,
        ),
      )
    ]);
  }
}
