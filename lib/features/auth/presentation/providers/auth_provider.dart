
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/entities/user_entity.dart';
import '../../../../core/errors/failures.dart';

class AuthProvider extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;

  bool _isLoading = false;
  String? _errorMessage;
  String? _token;

  AuthProvider({
    required this.loginUseCase,
    required this.registerUseCase,
  }) {
    _loadToken();
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _token != null && _token!.isNotEmpty;

  // Load token when provider is created
  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    notifyListeners();
  }

  // Save token after successful login/register
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    _token = token;
    notifyListeners();
  }

  // Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    _token = null;
    notifyListeners();
  }

  // Register (now fully implemented)
  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await registerUseCase.execute(
      name: name,
      email: email,
      phone: phone,
      password: password,
    );

    return result.fold(
      (failure) {
        _errorMessage = failure.message;
        _isLoading = false;
        notifyListeners();
        return false;
      },
      (user) async {
        if (user.token != null && user.token!.isNotEmpty) {
          await _saveToken(user.token!);
          _isLoading = false;
          notifyListeners();
          return true;
        }
        _errorMessage = 'Registration successful but no token received';
        _isLoading = false;
        notifyListeners();
        return false;
      },
    );
  }
}