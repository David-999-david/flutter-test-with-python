import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final naviagtionProvider = Provider<GlobalKey<NavigatorState>>(
  (ref) => GlobalKey<NavigatorState>(),
);
