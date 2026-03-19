class AppConstants {
  // Auth
  static const String baseUrl =
      'https://staging.pamtechcarcare.com'; // fix later
  static const String verifyOtpUri =
      'https://staging.pamtechcarcare.com/api/recover/verify_otp';
  static const String userLoginToken = 'BEARER_TOKEN'; //  fix later
  static const String registrationUri =
      'https://staging.pamtechcarcare.com/api/register';
  static const String googleSignInUri =
      'https://staging.pamtechcarcare.com/api/google_auth';
  static const String loginUri = 'https://staging.pamtechcarcare.com/api/login';
  static const String forgotPasswordUri =
      'https://staging.pamtechcarcare.com/api/recover/send_otp';
  static const String createNewPasswordUri =
      'https://staging.pamtechcarcare.com/api/recover/create_new_password';
  static const String reportIssueUri =
      'https://staging.pamtechcarcare.com/api/app/profile/report_issue';

  // Repairs
  static const String fetchUserRepairUri =
      'https://staging.pamtechcarcare.com/api/app/repair/fetch_user_repairs';
  static const String repairBaseUri =
      'https://staging.pamtechcarcare.com/api/app/repair/fetch_estimate';
  static const String rejectEstimateUri =
      'https://staging.pamtechcarcare.com/api/app/repair/reject_estimate_item';
  static const String acceptEstimateUri =
      'https://staging.pamtechcarcare.com/api/app/repair/accept_estimate_item';
  static const String fetchUserProfile =
      'https://staging.pamtechcarcare.com/api/app/profile/fetch';
  static const String uploadUserAvatar =
      'https://staging.pamtechcarcare.com/api/app/profile/change_avatar';
  static const String updateProfileUri =
      'https://staging.pamtechcarcare.com/api/app/profile/update';
  static const String updatePasswordUri =
      'https://staging.pamtechcarcare.com/api/app/profile/update_password';

  // Home
  static const String notificationsUri =
      'https://staging.pamtechcarcare.com/api/app/notifications/fetch';
  static const String unreadNotificationsUri =
      'https://staging.pamtechcarcare.com/api/app/notifications/fetch-unread';
  static const String markNotificationAsReadUri =
      'https://staging.pamtechcarcare.com/api/app/notifications/mark-asread';
  static const String vehiclesUri =
      'https://staging.pamtechcarcare.com/api/app/vehicle/fetch';
  static const String createVehicleUri =
      'https://staging.pamtechcarcare.com/api/app/vehicle/create';
  static const String garagesUri =
      'https://staging.pamtechcarcare.com/api/app/garage/fetch';
  static const String carDocumentsUri =
      'https://staging.pamtechcarcare.com/api/app/car_document/fetch';
  static const String createCarDocumentUri =
      'https://staging.pamtechcarcare.com/api/app/car_document/create';
  static const String updateCarDocumentUri =
      'https://staging.pamtechcarcare.com/api/app/car_document/update';
  static const String requestMechanicFetchServicesUri =
      'https://staging.pamtechcarcare.com/api/app/request_mechanic/fetch_services';
}
