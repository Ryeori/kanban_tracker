import 'dart:async';

import 'package:kanban_tracker/core/models/app_user/app_user.dart';
import 'package:kanban_tracker/features/authentication/models/base_classes/authentication_provider_sign_in_data.dart';
import 'package:kanban_tracker/features/authentication/models/base_classes/authentication_provider_sign_up_data.dart';
import 'package:kanban_tracker/features/authentication/models/base_classes/authentication_sign_in_response/authentication_sign_in_response.dart';
import 'package:kanban_tracker/features/authentication/models/base_classes/authentication_sign_up_response/authentication_sign_up_response.dart';

abstract class AuthenticationApi {
  Future<AuthenticationSignInResponse> signIn({
    required AuthenticationProviderSignInData signInData,
  });
  Future<AuthenticationSignUpResponse> signUp({
    required AuthenticationProviderSignUpData signUpData,
  });

  Future<bool> signOut();

  Future<AppUser?> getCurrentUser();
}
