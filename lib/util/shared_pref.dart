import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

class SharedPref {
  SharedPreferences? prefs;
  // DatesProvider? provider;

  // SharedPref([this.provider]);
  //  late DatesProvider prov;

  // prov = context.read<DatesProvider>();

  init() async {
    prefs = await SharedPreferences.getInstance();
  }

  
}
