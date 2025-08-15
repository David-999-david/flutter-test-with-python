import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testflutt/presentation/auth/login_screen.dart';
import 'package:testflutt/presentation/bottom_nav/bottom_nav.dart';
import 'package:testflutt/presentation/start_check/start_check_state.dart';

class StartCheck extends ConsumerStatefulWidget {
  const StartCheck({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StartCheckState();
}

class _StartCheckState extends ConsumerState<StartCheck> {
  bool _navigated = false;

  @override
  Widget build(BuildContext context) {
    ref.listen(startCheckProvider, (prev, next) {
      if (_navigated) return;
      next.when(
        data: (ok) {
          if (!mounted) return;
          _navigated = true;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ok ? BottomNav() : LoginScreen();
              },
            ),
          );
        },
        error: (error, _) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error.toString())));
        },
        loading: () {},
      );
    });

    final checkState = ref.watch(startCheckProvider);

    return Scaffold(
      body: Center(
        child: Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/cc.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            if (checkState.isLoading)
              Positioned(
                left: 180,
                bottom: 50,
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
