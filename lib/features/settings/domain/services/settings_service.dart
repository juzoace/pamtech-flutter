import 'package:autotech/data/model/api_response.dart';
import 'package:autotech/features/settings/domain/services/settings_service_interface.dart';

class SettingsService implements SettingsServiceInterface {
  final SettingsServiceInterface settingsRepoInterface;

  SettingsService({required this.settingsRepoInterface});

  @override
  Future<bool> reportProblem({required String subject, required String message}) {

    return settingsRepoInterface.reportProblem(subject: subject, message: message);
  }
}
