import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testflutt/data/model/auth_model.dart';
import 'package:testflutt/presentation/auth/login_screen.dart';
import 'package:testflutt/presentation/auth/state/auth_state.dart';
import 'package:testflutt/text_app.dart';

class RegisterScreen extends ConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GlobalKey<FormState> key = GlobalKey<FormState>();

    final TextEditingController email = TextEditingController();
    final TextEditingController phone = TextEditingController();
    final TextEditingController password = TextEditingController();
    final TextEditingController name = TextEditingController();

    ref.listen(registerStateProvider, (pre, next) {
      next.when(
        data: (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Reigster success, pleash check your mail for email verify!",
              ),
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

    final register = ref.watch(registerStateProvider);

    return Scaffold(
      body: Center(
        child: Form(
          key: key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Register', style: 20.sp()),
              SizedBox(height: 10),
              textfiedl(name, 'Name', 'Name'),
              textfiedl(phone, 'Phone', 'Phone'),
              textfiedl(email, "Eamil", 'Email'),
              textfiedl(password, "Password", 'Passowrd'),
              ElevatedButton(
                onPressed: register.isLoading
                    ? CircularProgressIndicator.new
                    : () {
                        if (key.currentState!.validate()) {
                          ref
                              .read(registerStateProvider.notifier)
                              .register(
                                RegisterModel(
                                  name: name.text,
                                  email: email.text,
                                  phone: phone.text,
                                  passowrd: password.text,
                                ),
                              );
                        }
                      },
                child: Text('Sign up'),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return LoginScreen();
                      },
                    ),
                  );
                },
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Already have and account?  ',
                        style: 13.sp(),
                      ),
                      TextSpan(
                        text: 'Login',
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

Widget textfiedl(TextEditingController c, String hint, String label) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextFormField(
      controller: c,
      decoration: InputDecoration(hintText: hint),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label is missing';
        }
        return null;
      },
    ),
  );
}
