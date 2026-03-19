// import 'package:jwt_decoder/jwt_decoder.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:provider/provider.dart';

// class SharedPref {
//   SharedPreferences? prefs;
//   // DatesProvider? provider;

//   // SharedPref([this.provider]);
//   //  late DatesProvider prov;

//   // prov = context.read<DatesProvider>();

//   init() async {
//     prefs = await SharedPreferences.getInstance();
//   }

  
// }



import 'package:autotech/util/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  SharedPreferences? prefs;

  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  // Save token (you already have similar logic in login)
  Future<void> saveToken(String token) async {
    await prefs?.setString(AppConstants.userLoginToken, token);
  }

  // Get token
  String? getToken() {
    return prefs?.getString(AppConstants.userLoginToken);
  }

  // Remove token (new method for logout)
  Future<void> removeToken() async {
    await prefs?.remove(AppConstants.userLoginToken);
  }

  // Optional: Clear all app data if needed (more aggressive logout)
  Future<void> clearAll() async {
    await prefs?.clear();
  }
}