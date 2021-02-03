import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterBoilerplate/constants/assets.dart';

class ProfileImage extends StatelessWidget {
  final String image;
  const ProfileImage({this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: image != null
            ? Image(
                image: CachedNetworkImageProvider(image),
                width: 100,
                height: 100,
                fit: BoxFit.fitHeight,
              )
            : Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width,
                child: Image.asset(AppAsset.somnioLogo),
              ),
      ),
    );
  }
}
