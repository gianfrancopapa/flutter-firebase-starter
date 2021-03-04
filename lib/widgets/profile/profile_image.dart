import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebasestarter/constants/assets.dart';
import 'package:firebasestarter/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';

class ProfileImage extends StatelessWidget {
  final String image;
  final double height;
  final double width;
  final bool editable;
  final VoidCallback onTap;

  const ProfileImage({
    this.image,
    this.height,
    this.width,
    this.editable = false,
    this.onTap,
  });

  Widget _networkImage() => Image(
        image: CachedNetworkImageProvider(image),
        width: width ?? 100,
        height: height ?? 100,
        fit: BoxFit.fitHeight,
      );

  Widget _assetImage(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage(image ?? Assets.somnioLogo),
            fit: BoxFit.fitHeight,
          ),
        ),
        height: height ?? 100,
        width: width ?? 100,
      );

  Widget _editIcon() => InkWell(
        onTap: onTap,
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColor.blue,
          ),
          height: 35.0,
          width: 35.0,
          child: const Icon(
            Icons.edit,
            color: AppColor.white,
            size: 20.0,
          ),
        ),
      );

  Widget _imageToShow(BuildContext context) =>
      image != null && isURL(image) ? _networkImage() : _assetImage(context);

  Widget _editableImage(BuildContext context) => Stack(
        alignment: Alignment.bottomRight,
        children: [_image(context), _editIcon()],
      );

  Widget _image(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: _imageToShow(context),
      );

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(15.0),
        child: editable ? _editableImage(context) : _image(context),
      );
}
