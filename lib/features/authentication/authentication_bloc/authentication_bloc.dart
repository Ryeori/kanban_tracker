// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kanban_tracker/core/models/app_user/app_user.dart';
import 'package:kanban_tracker/features/authentication/api/authentication_api.dart';
import 'package:kanban_tracker/features/authentication/models/base_classes/authentication_provider_sign_in_data.dart';
import 'package:kanban_tracker/features/authentication/models/base_classes/authentication_provider_sign_up_data.dart';

part 'authentication_bloc.freezed.dart';
part 'authentication_event.dart';
part 'authentication_state.dart';

@Singleton()
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc(
    @Named('FirebaseAuthenticationApi') this._authenticationApi,
  ) : super(const _Initial()) {
    on<AuthenticationEvent>((event, emit) {
      event.when(
        started: init,
        signUp: onSignUpEvent,
        signIn: onSignInEvent,
        signOut: onSignOutEvent,
      );
    });
  }
  //TODO: REPLACE WITH ABSTRACT CLASS AND MOVE INIT LOGIC HIGHER
  final AuthenticationApi _authenticationApi;
  Future<void> onSignInEvent(
    AuthenticationProviderSignInData signInData,
  ) async {
    emit(const AuthenticationState.loading());

    await _authenticationApi
        .signIn(signInData: signInData)
        .then((signInResponse) {
      signInResponse.maybeWhen(
        signedId: (signedInUser) {
          emit(AuthenticationState.signedIn(user: signedInUser));
        },
        error: (error) {
          emit(AuthenticationState.error(errorMessage: error));
        },
        orElse: () => emit(
          const AuthenticationState.error(
            errorMessage: 'AUTHENTICATION ERROR',
          ),
        ),
      );
    });
  }

  Future<void> onSignUpEvent(
    AuthenticationProviderSignUpData signUpData,
  ) async {
    emit(const AuthenticationState.loading());

    await _authenticationApi
        .signUp(signUpData: signUpData)
        .then((isAccountCreated) {
      isAccountCreated.maybeWhen(
        error: (error) {
          emit(AuthenticationState.error(errorMessage: error));
        },
        signedUp: (signedInUser) {
          emit(AuthenticationState.signedIn(user: signedInUser));
        },
        orElse: () {
          emit(
            const AuthenticationState.error(
              errorMessage: 'Bloc Sign up error',
            ),
          );
        },
      );
    });
  }

  Future<void> onSignOutEvent() async {
    emit(const AuthenticationState.loading());

    await _authenticationApi.signOut().then((isSignedOut) {
      if (isSignedOut) {
        emit(const AuthenticationState.signedOut());
      }
    });
  }

  Future<void> init() async {
    await checkAuthenticationStatus();
  }

  Future<void> checkAuthenticationStatus() async {
    final currentUser = await _authenticationApi.getCurrentUser();

    if (currentUser != null) {
      if (state is! _SignedIn) {
        emit(_SignedIn(user: currentUser));
      }
    } else {
      emit(const _Initial());
    }
  }
}
