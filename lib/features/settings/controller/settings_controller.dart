// import 'package:autotech/data/model/api_response.dart';
// import 'package:flutter/material.dart';
// import 'package:autotech/features/settings/domain/services/settings_service_interface.dart';

// class SettingsController extends ChangeNotifier {
//   final SettingsServiceInterface settingsServiceInterface;
//   SettingsController({required this.settingsServiceInterface});

//   bool _isLoading = false;
//   bool get isLoading => _isLoading;
//   String? _errorMessage;
//   String? get errorMessage => _errorMessage;
//   bool _reportProblemSuccess = false;
//   bool get reportProblemSuccess => _reportProblemSuccess;

//   Future<bool> reportProblem({
//     required String? subject,
//     required String message,
//   }) async {
//     _isLoading = true;
//     _errorMessage = null;
//     _reportProblemSuccess = false;
//     notifyListeners();
//     try {
//       final ApiResponseModel response = await settingsServiceInterface.reportProblem(String: subject, String message)

//     } catch (err) {
//     } finally {

//     }
//   }
// }



import 'package:autotech/data/model/api_response.dart';
import 'package:flutter/material.dart';
import 'package:autotech/features/settings/domain/services/settings_service_interface.dart';

class SettingsController extends ChangeNotifier {
  final SettingsServiceInterface settingsServiceInterface;

  SettingsController({required  this.settingsServiceInterface});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _reportSuccess = false;
  bool get reportSuccess => _reportSuccess;

  Future<bool> reportProblem({
    required String subject,
    required String message,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _reportSuccess = false;
    notifyListeners();

    try {
      final success = await settingsServiceInterface.reportProblem(
        subject: subject,
        message: message,
      );

      _reportSuccess = success;
      _errorMessage = success ? null : 'Failed to submit report';
      return success;
    } catch (e, st) {
      debugPrint("reportProblem error: $e\n$st");
      _errorMessage = 'An error occurred. Please try again.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void resetReportState() {
    _reportSuccess = false;
    _errorMessage = null;
    notifyListeners();
  }
}