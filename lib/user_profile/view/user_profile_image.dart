import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_starter_ui/firebase_starter_ui.dart';
import 'package:firebasestarter/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';

class UserProfileImage extends StatelessWidget {
  const UserProfileImage({
    Key? key,
    this.image,
    this.height,
    this.width,
    this.editable = false,
    this.onTap,
  }) : super(key: key);

  final String? image;
  final double? height;
  final double? width;
  final bool editable;
  final VoidCallback? onTap;

  Widget _networkImage() => Image(
        image: CachedNetworkImageProvider(image!),
        width: width ?? 150,
        height: height ?? 150,
        fit: BoxFit.fitHeight,
      );

  Widget _assetImage(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FSColors.white,
        shape: BoxShape.circle,
        image: DecorationImage(
          image: image != null && image!.isNotEmpty
              ? Image.file(File(image!)).image
              : AssetImage(Assets
                  .packages.firebaseStarterUi.assets.images.somnioLogo.path),
          fit: BoxFit.fitHeight,
        ),
      ),
      height: height ?? 150,
      width: width ?? 150,
    );
  }

  Widget _editIcon() => InkWell(
        key: const Key('profileImage_editImageIcon'),
        onTap: onTap,
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: FSColors.blue,
          ),
          height: 35.0,
          width: 35.0,
          child: const Icon(
            Icons.edit,
            color: FSColors.white,
            size: 20.0,
          ),
        ),
      );

  Widget _imageToShow(BuildContext context) {
    return image != null && image!.isNotEmpty && isURL(image!)
        ? _networkImage()
        : _assetImage(context);
  }

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
