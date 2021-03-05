import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebasestarter/constants/assets.dart';
import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';

class ProfileImage extends StatelessWidget {
  final String image;
  final double height;
  final double width;

  const ProfileImage({this.image, this.height, this.width});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(15.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: image != null && isURL(image)
              ? Image(
                  image: CachedNetworkImageProvider(image),
                  width: width ?? 100,
                  height: height ?? 100,
                  fit: BoxFit.fill,
                )
              : Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  width: width ?? 100,
                  height: height ?? 100,
                  child: const Icon(
                    Icons.account_circle,
                    size: 90.0,
                  ),
                ),
        ),
      );
}
