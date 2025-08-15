import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testflutt/data/service/authservice.dart';

class StartCheckState extends StateNotifier<AsyncValue<bool>> {
  StartCheckState() : super(AsyncLoading()) {
    check();
  }

  Future<void> check() async {
    state = AsyncValue.loading();
    await Future.delayed(Duration(seconds: 5));
    final result = await AsyncValue.guard(() => Authservice().handlerStart());
    state = result;
  }
}

final startCheckProvider =
    StateNotifierProvider<StartCheckState, AsyncValue<bool>>(
      (ref) => StartCheckState(),
    );
