import 'package:flutter/material.dart';

abstract class DynamicLinksService {
  void initDynamicLinks({@required BuildContext context});

  Uri shortenUrl({@required Uri uri});
}
