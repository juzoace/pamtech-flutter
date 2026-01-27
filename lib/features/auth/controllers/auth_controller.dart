import 'dart:convert';
import 'dart:developer';
import 'package:autotech/features/auth/domain/models/register_model.dart';
import 'package:autotech/features/auth/domain/services/auth_service_interface.dart';
import 'package:flutter/material.dart';

class AuthController with ChangeNotifier {
  final AuthServiceInterface authServiceInterface;
  AuthController({required this.authServiceInterface});

  bool _isLoading = false;

  set setIsLoading(bool value) => _isLoading = value;

  bool _sendToEmail = false;
  bool get sendToEmail => _sendToEmail;

  Future registration( RegisterModel register, Function callback,
  ) async {

  }
}
