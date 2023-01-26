import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kanban_tracker/core/models/app_user/app_user.dart';

part 'authentication_sign_up_response.freezed.dart';

@freezed
class AuthenticationSignUpResponse with _$AuthenticationSignUpResponse {
  const factory AuthenticationSignUpResponse.signedUp({
    required AppUser signedInUser,
  }) = _SignedUp;
  const factory AuthenticationSignUpResponse.confirmationRequired({
    required String furtherExplanationMessage,
  }) = _ConfirmationRequired;
  const factory AuthenticationSignUpResponse.error({required String error}) =
      _Error;
}
