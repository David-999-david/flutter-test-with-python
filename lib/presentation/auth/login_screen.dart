import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testflutt/data/model/auth_model.dart';
import 'package:testflutt/presentation/auth/register_screen.dart';
import 'package:testflutt/presentation/auth/state/auth_state.dart';
import 'package:testflutt/presentation/bottom_nav/bottom_nav.dart';
import 'package:testflutt/text_app.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GlobalKey<FormState> key = GlobalKey<FormState>();
    final TextEditingController email = TextEditingController();
    final TextEditingController password = TextEditingController();

    ref.listen(loginProvider, (prev, next) {
      next.when(
        data: (_) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => BottomNav(index: 0)),
            (_) => false,
          );
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Login in success!')));
        },
        error: (error, _) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error.toString())));
        },
        loading: () {},
      );
    });

    final loginstate = ref.watch(loginProvider);
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
                onPressed: loginstate.isLoading
                    ? CircularProgressIndicator.new
                    : () {
                        if (key.currentState!.validate()) {
                          ref
                              .read(loginProvider.notifier)
                              .login(
                                LoginModel(
                                  email: email.text,
                                  password: password.text,
                                ),
                              );
                        }
                      },
                child: Text('Sign in'),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return RegisterScreen();
                      },
                    ),
                  );
                },
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Don\'t have an account?  ',
                        style: 13.sp(),
                      ),
                      TextSpan(
                        text: 'Register',
                        style: 14.sp().copyWith(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
