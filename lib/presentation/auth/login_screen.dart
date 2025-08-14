import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testflutt/presentation/auth/register_screen.dart';
import 'package:testflutt/text_app.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GlobalKey<FormState> key = GlobalKey<FormState>();
    final TextEditingController email = TextEditingController();
    final TextEditingController password = TextEditingController();
    return Scaffold(
      body: Center(
        child: Form(
          key: key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('LOGIN', style: 20.sp()),
              SizedBox(height: 10),

              textfiedl(email, "Eamil", 'Email'),
              textfiedl(password, "Password", 'Passowrd'),
              ElevatedButton(
                onPressed:
                    // register.isLoading
                    //     ? CircularProgressIndicator.new
                    () {
                      // if (key.currentState!.validate()) {
                      //   ref
                      //       .read(registerStateProvider.notifier)
                      //       .register(
                      //         RegisterModel(
                      //           name: name.text,
                      //           email: email.text,
                      //           phone: phone.text,
                      //           passowrd: password.text,
                      //         ),
                      //       );
                      // }
                    },
                child: Text('Sign up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
