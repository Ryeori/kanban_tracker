import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kanban_tracker/features/authentication/models/base_classes/authentication_provider.dart';

part 'email_authentication_provider.freezed.dart';

@freezed
class EmailAuthenticationProvider extends AuthenticationProvider
    with _$EmailAuthenticationProvider {
  const factory EmailAuthenticationProvider({
    required String id,
    required bool isEmailConfirmed,
    required String email,
    required String name,
  }) = _EmailAuthenticationProvider;
}
