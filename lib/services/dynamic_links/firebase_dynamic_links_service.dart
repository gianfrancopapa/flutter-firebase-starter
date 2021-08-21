import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebasestarter/login/login.dart';
import 'package:firebasestarter/services/dynamic_links/dynamic_links_service.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class FirebaseDynamicLinksService extends DynamicLinksService {
  @override
  void initDynamicLinks({BuildContext context}) async {
    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (PendingDynamicLinkData dynamicLink) async {
        final deepLink = dynamicLink?.link;

        if (deepLink != null) {
          context.read<LoginBloc>().add(LoginPasswordlessRequested(uri: deepLink));
        }
      },
      onError: (OnLinkErrorException e) async {
        print('onLinkError');
        print(e.message);
      },
    );

    final data = await FirebaseDynamicLinks.instance.getInitialLink();
    final deepLink = data?.link;

    if (deepLink != null) {
      context.read<LoginBloc>().add(LoginPasswordlessRequested(uri: deepLink));
    }
  }

  @override
  Uri shortenUrl({Uri uri}) {
    // TODO: implement shortenUrl
    throw UnimplementedError();
  }
}
