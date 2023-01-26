part of 'authentication_bloc.dart';

@freezed
class AuthenticationEvent with _$AuthenticationEvent {
  const factory AuthenticationEvent.started() = _StartedEvent;
  const factory AuthenticationEvent.signOut() = _SignOutEvent;
  const factory AuthenticationEvent.signIn({
    required AuthenticationProviderSignInData signInData,
  }) = _SignInEvent;
  const factory AuthenticationEvent.signUp({
    required AuthenticationProviderSignUpData signUpData,
  }) = _SignUpEvent;
}
