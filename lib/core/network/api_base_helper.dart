import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

class ApiBaseHelper {
  Future<dynamic> get(String url) async {
    var responseJson;
    try {
      final response = await http.get(
        Uri.parse(AppConfig.baseUrl + url),
        headers: {"Content-Type": "application/json"},
      );
      responseJson = _returnResponse(response);
    } catch (e) {
      throw Exception('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> post(String url, dynamic body, String token) async {
    var responseJson;
    try {
      final response = await http.post(
        Uri.parse(AppConfig.baseUrl + url),
        body: json.encode(body),
        headers: {
          "Content-Type": "application/json",
          if (token.isNotEmpty) "Authorization": "Bearer $token",
        },
      );
      responseJson = _returnResponse(response);
    } catch (e) {
      throw Exception('No Internet connection');
    }
    return responseJson;
  }

  // Add put, delete, etc. as needed

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 201:
        var responseJson = json.decode(response.body.toString());
        return responseJson;
      case 400:
        throw Exception('Bad request');
      case 401:
        throw Exception('Unauthorized');
      case 403:
        throw Exception('Forbidden');
      case 500:
      default:
        throw Exception('Error occurred while communicating with server');
    }
  }
}