import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testflutt/deeplinks/deep_link_state.dart';
import 'package:testflutt/dioClient.dart';
import 'package:testflutt/global_navigation/naviagation_key.dart';
import 'package:testflutt/presentation/auth/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DioClient.init();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(deepLinkProvider);
    final navkey = ref.watch(naviagtionProvider);

    return MaterialApp(
      navigatorKey: navkey,
      home: RegisterScreen(),
    );
  }
}
