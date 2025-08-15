import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testflutt/deeplinks/deep_link_state.dart';
import 'package:testflutt/dioClient.dart';
import 'package:testflutt/global_navigation/naviagation_key.dart';
import 'package:testflutt/presentation/start_check/start_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();
  await DioClient.init(key);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(deepLinkProvider);
    final navkey = ref.watch(naviagtionProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navkey,
      home: StartCheck(),
    );
  }
}
