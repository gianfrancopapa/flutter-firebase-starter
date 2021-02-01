import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/constants/assets.dart';

class ProfileImage extends StatelessWidget {
  final String image;
  const ProfileImage({this.image});

  @override
  Widget build(BuildContext context) {
    if (image != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Image(
          image: CachedNetworkImageProvider(image),
          width: 100,
          height: 100,
          fit: BoxFit.fitHeight,
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Image.asset(
        AppAsset.anonUser,
        width: 100,
        height: 100,
        fit: BoxFit.fitHeight,
      ),
    );
  }
}
