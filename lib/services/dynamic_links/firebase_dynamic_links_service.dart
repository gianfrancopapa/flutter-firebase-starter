import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebasestarter/authentication/authentication.dart';
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

    final data = await FirebaseDynamicLinks.instance.getInitialLink();
    final deepLink = data?.link;

    if (deepLink != null) {
      context.read<LoginBloc>().add(LoginPasswordlessRequested(uri: deepLink));
    }
  }
}
