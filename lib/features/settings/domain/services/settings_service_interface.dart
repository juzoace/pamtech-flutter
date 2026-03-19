abstract class SettingsServiceInterface {
  Future<bool> reportProblem({
    required String subject,
    required String message,
  });
}
