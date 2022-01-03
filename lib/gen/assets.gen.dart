/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// ignore_for_file: directives_ordering,unnecessary_import

import 'package:flutter/widgets.dart';

class $PackagesGen {
  const $PackagesGen();

  $PackagesFirebaseStarterUiGen get firebaseStarterUi =>
      const $PackagesFirebaseStarterUiGen();
}

class $PackagesFirebaseStarterUiGen {
  const $PackagesFirebaseStarterUiGen();

  $PackagesFirebaseStarterUiAssetsGen get assets =>
      const $PackagesFirebaseStarterUiAssetsGen();
}

class $PackagesFirebaseStarterUiAssetsGen {
  const $PackagesFirebaseStarterUiAssetsGen();

  $PackagesFirebaseStarterUiAssetsImagesGen get images =>
      const $PackagesFirebaseStarterUiAssetsImagesGen();
}

class $PackagesFirebaseStarterUiAssetsImagesGen {
  const $PackagesFirebaseStarterUiAssetsImagesGen();

  /// File path: packages/firebase_starter_ui/assets/images/anon_login.png
  AssetGenImage get anonLogin => const AssetGenImage(
      'packages/firebase_starter_ui/assets/images/anon_login.png');

  /// File path: packages/firebase_starter_ui/assets/images/anonymous_user.png
  AssetGenImage get anonymousUser => const AssetGenImage(
      'packages/firebase_starter_ui/assets/images/anonymous_user.png');

  /// File path: packages/firebase_starter_ui/assets/images/apple_logo.png
  AssetGenImage get appleLogo => const AssetGenImage(
      'packages/firebase_starter_ui/assets/images/apple_logo.png');

  /// File path: packages/firebase_starter_ui/assets/images/confluence_logo.png
  AssetGenImage get confluenceLogo => const AssetGenImage(
      'packages/firebase_starter_ui/assets/images/confluence_logo.png');

  /// File path: packages/firebase_starter_ui/assets/images/facebook_logo.png
  AssetGenImage get facebookLogo => const AssetGenImage(
      'packages/firebase_starter_ui/assets/images/facebook_logo.png');

  /// File path: packages/firebase_starter_ui/assets/images/google_logo.png
  AssetGenImage get googleLogo => const AssetGenImage(
      'packages/firebase_starter_ui/assets/images/google_logo.png');

  /// File path: packages/firebase_starter_ui/assets/images/setting.png
  AssetGenImage get setting => const AssetGenImage(
      'packages/firebase_starter_ui/assets/images/setting.png');

  /// File path: packages/firebase_starter_ui/assets/images/somnio_grey_logo.svg
  String get somnioGreyLogo =>
      'packages/firebase_starter_ui/assets/images/somnio_grey_logo.svg';

  /// File path: packages/firebase_starter_ui/assets/images/somnio_logo.png
  AssetGenImage get somnioLogo => const AssetGenImage(
      'packages/firebase_starter_ui/assets/images/somnio_logo.png');
}

class Assets {
  Assets._();

  static const $PackagesGen packages = $PackagesGen();
}

class AssetGenImage extends AssetImage {
  const AssetGenImage(String assetName) : super(assetName);

  Image image({
    Key? key,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? width,
    double? height,
    Color? color,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    FilterQuality filterQuality = FilterQuality.low,
  }) {
    return Image(
      key: key,
      image: this,
      frameBuilder: frameBuilder,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      width: width,
      height: height,
      color: color,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      filterQuality: filterQuality,
    );
  }

  String get path => assetName;
}
