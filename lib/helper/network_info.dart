import 'package:flutter/material.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:provider/provider.dart';

class NetworkInfo {
  final Connectivity connectivity;
  NetworkInfo(this.connectivity);

  //  Future<bool> get isConnected async {
  //   ConnectivityResult result = await connectivity.checkConnectivity();
  //   return result != ConnectivityResult.none;
  // }

  

}
