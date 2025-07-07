import 'package:seulgiful/src/core/utils/exceptions/app_exception.dart';

class ProfileException extends AppException {
  const ProfileException(super.message, {super.code});
  
  // Factory constructors for common profile errors
  factory ProfileException.notFound() => 
      const ProfileException('Profile not found', code: 'profile_not_found');
      
  factory ProfileException.updateFailed() => 
      const ProfileException('Failed to update profile', code: 'update_failed');
      
  factory ProfileException.featureLimitReached(String featureType) => 
      ProfileException('You have reached the limit for $featureType', code: 'feature_limit_reached');
      
  factory ProfileException.invalidData(String field) => 
      ProfileException('Invalid data for field: $field', code: 'invalid_data');
}