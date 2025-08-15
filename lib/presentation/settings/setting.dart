import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testflutt/presentation/settings/setting_state.dart';

class Setting extends ConsumerStatefulWidget {
  const Setting({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingState();
}

class _SettingState extends ConsumerState<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {
            ref.read(logoutProvider.notifier).logout();
          },
          child: Text('Log out'),
        ),
      ),
    );
  }
}
