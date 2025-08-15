import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testflutt/data/model/auth_model.dart';
import 'package:testflutt/data/service/authservice.dart';

class RegisterState extends StateNotifier<AsyncValue<void>> {
  RegisterState() : super(AsyncValue.data(null));

  Future<void> register(RegisterModel user) async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() => Authservice().register(user));
  }
}

final registerStateProvider =
    StateNotifierProvider<RegisterState, AsyncValue<void>>(
      (ref) => RegisterState(),
    );

class LoginNotifier extends StateNotifier<AsyncValue<void>> {
  LoginNotifier() : super(AsyncValue.data(null));

  Future<void> login(LoginModel user) async {
    state = AsyncValue.loading();
    state = await AsyncValue.guard(() => Authservice().login(user));
  }
}

final loginProvider = StateNotifierProvider<LoginNotifier, AsyncValue<void>>(
  (ref) => LoginNotifier(),
);
