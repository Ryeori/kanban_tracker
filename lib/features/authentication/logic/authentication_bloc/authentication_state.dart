part of 'authentication_bloc.dart';

@freezed
class AuthenticationState with _$AuthenticationState {
  const factory AuthenticationState.initial() = _Initial;
  const factory AuthenticationState.signedIn({required AppUser user}) =
      _SignedIn;
  const factory AuthenticationState.signedOut() = _SignedOut;
  const factory AuthenticationState.loading() = _Loading;
  const factory AuthenticationState.error({required String errorMessage}) =
      _Error;
}
