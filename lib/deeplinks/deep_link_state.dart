import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testflutt/global_navigation/naviagation_key.dart';
import 'package:testflutt/presentation/email_verification/verification_failed.dart';
import 'package:testflutt/presentation/email_verification/verification_success.dart';

class DeepLinkState extends Notifier<void> {
  late final AppLinks _appLinks;
  StreamSubscription<Uri>? sub;
  GlobalKey<NavigatorState> get _key => ref.read(naviagtionProvider);
  bool _handleInitial = false;
  bool _dialogShowing = false;

  @override
  void build() {
    _appLinks = AppLinks();
    _init();
  }

  Future<void> _init() async {
    try {
      final initial = await _appLinks.getInitialLink();
      if (initial != null) {
        await _handleUri(initial, isInitial: true);
      }
    } catch (_) {}
    sub = _appLinks.uriLinkStream.listen(
      (uri) => _handleUri(uri, isInitial: false),
      onError: (_) {},
    );
  }

  Future<void> _safeShowDialog(Widget dialog) async {
    if (_dialogShowing) return;
    _dialogShowing = true;

    final nav = await _waitForNavigatorReady();
    if (!nav.mounted) {
      _dialogShowing = false;
      return;
    }

    await showDialog(context: nav.context, builder: (_) => dialog);

    _dialogShowing = false;
  }

  Future<NavigatorState> _waitForNavigatorReady() async {
    for (var i = 0; i < 10; i++) {
      final nav = _key.currentState;
      if (nav != null) return nav;
      final c = Completer<void>();
      WidgetsBinding.instance.addPostFrameCallback((_) => c.complete());
      await c.future;
    }
    return _key.currentState!;
  }

  Future<void> _handleUri(Uri uri, {required bool isInitial}) async {
    debugPrint(
      'DEEP: $uri  '
      'scheme=${uri.scheme} '
      'host=${uri.host} '
      'path=${uri.path} '
      'segs=${uri.pathSegments}'
      'quars=${uri.queryParameters['reason']}',
    );
    if (uri.scheme != "htayapp") return;

    if (isInitial && _handleInitial) return;
    if (isInitial) _handleInitial = true;

    final route = uri.host.isNotEmpty
        ? uri.host
        : (uri.pathSegments.isNotEmpty ? uri.pathSegments.first : '');

    switch (route) {
      case "verify-success":
        await _safeShowDialog(VerificationSuccess());
        return;
      case "verify-failed":
        final reason = uri.queryParameters['reason'];
        await _safeShowDialog(VerificationFailed(reason: reason));
        return;
      default:
        return;
    }
  }
}

final deepLinkProvider = NotifierProvider<DeepLinkState, void>(
  DeepLinkState.new,
);
