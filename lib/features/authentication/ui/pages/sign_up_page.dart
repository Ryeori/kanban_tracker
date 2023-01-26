import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_tracker/core/styles/app_sizes.dart';
import 'package:kanban_tracker/features/authentication/authentication_bloc/authentication_bloc.dart';
import 'package:kanban_tracker/features/authentication/models/authentication_providers/email_authentication/provider_data/email_authentication_provider_sign_up_data.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignUpPage> {
  final formkey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> onSignUp() async {
    BlocProvider.of<AuthenticationBloc>(context).add(
      AuthenticationEvent.signUp(
        signUpData: EmailAuthenticationProviderSignUpData(
          email: emailController.text.trim().toLowerCase(),
          password: passwordController.text.trim().toLowerCase(),
        ),
      ),
    );
  }

  Future<void> onBackToLogin() async {
    await AutoRouter.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.all(appPrimaryPadding),
        child: Center(
          child: Form(
            key: formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Email'),
                  controller: emailController,
                ),
                TextFormField(
                  decoration: const InputDecoration(hintText: 'Password'),
                  obscureText: true,
                  controller: passwordController,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: appPrimaryPadding),
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: onBackToLogin,
                        child: const Text('Back to login'),
                      )
                    ],
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onSignUp,
                    child: const Text('Create an account'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
