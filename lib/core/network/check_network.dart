import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkChecker {
  static Future<bool> isConnected() async {
    final result = await Connectivity().checkConnectivity();
    if(result.contains(ConnectivityResult.none)){
      return false;
    }
    return true;
  }
}
