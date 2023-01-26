import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kanban_tracker/core/models/app_user/app_user.dart';

part 'authentication_sign_in_response.freezed.dart';

@freezed
class AuthenticationSignInResponse with _$AuthenticationSignInResponse {
  const factory AuthenticationSignInResponse.signedId({
    required AppUser signedInUser,
  }) = _SignedIn;
  const factory AuthenticationSignInResponse.error({required String error}) =
      _Error;
}
