import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  final String image;
  const ProfileImage({this.image});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Image.network(
        image,
        width: 100,
        height: 100,
        fit: BoxFit.fitHeight,
      ),
    );
  }
}
