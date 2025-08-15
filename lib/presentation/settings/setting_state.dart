import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testflutt/data/service/authservice.dart';

class SettingState extends StateNotifier<AsyncValue<void>> {
  SettingState() : super(AsyncValue.data(null));

  Future<void> logout() async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() => Authservice().logout());
  }
}

final logoutProvider = StateNotifierProvider<SettingState, AsyncValue<void>>(
  (ref) => SettingState(),
);
