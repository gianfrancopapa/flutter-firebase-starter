import 'package:flutter/material.dart';

class ImagePickerButton extends StatelessWidget {
  final Function dispatchImageFromGallery;
  final Function dispatchImageFromCamera;
  final Widget child;

  const ImagePickerButton({
    this.dispatchImageFromGallery,
    this.dispatchImageFromCamera,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showPicker(context);
      },
      child: child,
    );
  }

  Future<void> showPicker(context) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  dispatchImageFromGallery();
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  dispatchImageFromCamera();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
