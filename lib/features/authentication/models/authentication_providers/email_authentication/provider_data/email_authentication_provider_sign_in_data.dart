import 'package:kanban_tracker/features/authentication/models/base_classes/authentication_provider_sign_in_data.dart';

class EmailAuthenticationProviderSignInData
    extends AuthenticationProviderSignInData {
  EmailAuthenticationProviderSignInData({
    required this.password,
    required this.email,
  });

  final String email;
  final String password;
}
