import 'package:seulgiful/src/core/utils/exceptions/app_exception.dart';

class AuthException extends AppException {
  const AuthException(super.message, {super.code});
  
  // Factory constructors for common auth errors
  factory AuthException.invalidCredentials() => 
      const AuthException('Invalid email or password', code: 'invalid_credentials');
      
  factory AuthException.userNotFound() => 
      const AuthException('User not found', code: 'user_not_found');
      
  factory AuthException.emailNotConfirmed() => 
      const AuthException('Please confirm your email address', code: 'email_not_confirmed');
      
  factory AuthException.sessionExpired() => 
      const AuthException('Your session has expired. Please sign in again', code: 'session_expired');
      
  factory AuthException.accountLinking() => 
      const AuthException('Failed to link account. Please try again', code: 'account_linking_failed');
}