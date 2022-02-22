import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebasestarter/login/login.dart';
import 'package:firebasestarter/services/dynamic_links/dynamic_links_service.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class FirebaseDynamicLinksService extends DynamicLinksService {
  @override
  void initDynamicLinks({required BuildContext context}) async {
    FirebaseDynamicLinks.instance.onLink.listen((event) {
      context
          .read<LoginBloc>()
          .add(LoginPasswordlessRequested(uri: event.link));
    });
  }

  @override
  Uri shortenUrl({required Uri uri}) {
    // TODO: implement shortenUrl
    throw UnimplementedError();
  }
}
