import 'package:flutter/material.dart';
import 'package:testflutt/text_app.dart';

class VerificationFailed extends StatelessWidget {
  const VerificationFailed({super.key, this.reason});

  final String? reason;

  @override
  Widget build(BuildContext context) {
    final message = switch (reason) {
      'expired' => 'Your verification link expired',
      'invalid' => 'Your verification link invalid',
      (_) => 'Email Verification failed',
    };

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 100, maxWidth: 150),
      child: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(message, style: 15.sp()),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('BACK TO REGISTER'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
