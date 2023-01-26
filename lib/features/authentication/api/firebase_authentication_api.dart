import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:kanban_tracker/core/models/app_user/app_user.dart';
import 'package:kanban_tracker/features/authentication/api/authentication_api.dart';
import 'package:kanban_tracker/features/authentication/models/authentication_providers/email_authentication/provider_data/email_authentication_provider_sign_in_data.dart';
import 'package:kanban_tracker/features/authentication/models/authentication_providers/email_authentication/provider_data/email_authentication_provider_sign_up_data.dart';
import 'package:kanban_tracker/features/authentication/models/base_classes/authentication_provider_sign_in_data.dart';
import 'package:kanban_tracker/features/authentication/models/base_classes/authentication_provider_sign_up_data.dart';
import 'package:kanban_tracker/features/authentication/models/base_classes/authentication_sign_in_response/authentication_sign_in_response.dart';
import 'package:kanban_tracker/features/authentication/models/base_classes/authentication_sign_up_response/authentication_sign_up_response.dart';

@Named('FirebaseAuthenticationApi')
@LazySingleton(as: AuthenticationApi)
class FirebaseAuthenticationApi implements AuthenticationApi {
  @override
  Future<AppUser?> getCurrentUser() async {
    final User? firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser?.uid != null) {
      return AppUser(id: firebaseUser!.uid, email: firebaseUser.email ?? '');
    }
    return null;
  }

  @override
  Future<AuthenticationSignInResponse> signIn({
    required AuthenticationProviderSignInData signInData,
  }) async {
    if (signInData is EmailAuthenticationProviderSignInData) {
      return _emailProviderSignIn(signInData: signInData);
    } else {
      return const AuthenticationSignInResponse.error(
        error:
            'NO AUTH PROVIDER WAS FOUND, ADD YOUR PROVIDER AND CALL SIGN IN METHOD',
      );
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<AuthenticationSignUpResponse> signUp({
    required AuthenticationProviderSignUpData signUpData,
  }) {
    try {
      if (signUpData is EmailAuthenticationProviderSignUpData) {
        return FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: signUpData.email,
          password: signUpData.password,
        )
            .then((createdUser) {
          if (createdUser.user?.uid != null) {
            return AuthenticationSignUpResponse.signedUp(
              signedInUser: AppUser(id: createdUser.user!.uid),
            );
          } else {
            return const AuthenticationSignUpResponse.error(
              error: 'USER WASNT CREATED',
            );
          }
        });
      } else {
        return Future(
          () => const AuthenticationSignUpResponse.error(
            error: 'USER WASNT CREATED',
          ),
        );
      }
    } catch (e) {
      print(e);
      return Future(
        () => const AuthenticationSignUpResponse.error(error: 'SIGN UP ERROR'),
      );
    }
  }

  Future<AuthenticationSignInResponse> _emailProviderSignIn({
    required EmailAuthenticationProviderSignInData signInData,
  }) async {
    try {
      final signInResponse =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: signInData.email,
        password: signInData.password,
      );

      if (signInResponse.user?.uid != null) {
        final AppUser signedInUser = AppUser(
          id: signInResponse.user!.uid,
          email: signInResponse.user?.email ?? '',
        );
        return AuthenticationSignInResponse.signedId(
          signedInUser: signedInUser,
        );
      } else {
        return const AuthenticationSignInResponse.error(
          error: 'USER UID IS NULL',
        );
      }
      //todo: add error handling and email confirmation
    } on FirebaseAuthException catch (e) {
      return AuthenticationSignInResponse.error(error: e.message.toString());
    } catch (e) {
      return AuthenticationSignInResponse.error(error: e.toString());
    }
  }
}
