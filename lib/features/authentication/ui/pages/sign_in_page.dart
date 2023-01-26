import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_tracker/core/navigation/app_router.gr.dart';
import 'package:kanban_tracker/core/styles/app_sizes.dart';
import 'package:kanban_tracker/features/authentication/logic/authentication_bloc/authentication_bloc.dart';
import 'package:kanban_tracker/features/authentication/models/authentication_providers/email_authentication/provider_data/email_authentication_provider_sign_in_data.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final formkey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> onSignIn() async {
    BlocProvider.of<AuthenticationBloc>(context).add(
      AuthenticationEvent.signIn(
        signInData: EmailAuthenticationProviderSignInData(
          email: emailController.text.trim().toLowerCase(),
          password: passwordController.text.trim().toLowerCase(),
        ),
      ),
    );
  }

  Future<void> onSignUp() async {
    await AutoRouter.of(context).navigate(const SignUpPageRoute());
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
                        onPressed: onSignUp,
                        child: const Text('Create an account'),
                      )
                    ],
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onSignIn,
                    child: const Text('Sign in'),
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
