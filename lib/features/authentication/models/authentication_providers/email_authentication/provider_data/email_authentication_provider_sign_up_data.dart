import 'package:kanban_tracker/features/authentication/models/base_classes/authentication_provider_sign_up_data.dart';

class EmailAuthenticationProviderSignUpData
    extends AuthenticationProviderSignUpData {
  EmailAuthenticationProviderSignUpData({
    required this.password,
    required this.email,
  });

  final String email;
  final String password;
}
