import 'package:flutter/material.dart';
import 'package:testflutt/presentation/auth/login_screen.dart';
import 'package:testflutt/text_app.dart';

class VerificationSuccess extends StatelessWidget {
  const VerificationSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 200),
      child: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Email VERIFIED SUCCESS', style: 15.sp()),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return LoginScreen();
                        },
                      ),
                      (_) => false,
                    );
                  },
                  child: Text('LOGIN'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
