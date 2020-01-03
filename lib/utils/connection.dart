

import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';

abstract class NetworkConnection{
  Future<bool> get isConnected;
}


class InternetConnectionUtils extends NetworkConnection{
  DataConnectionChecker connectionChecker;
  Connectivity connectivity;

  InternetConnectionUtils({@required this.connectivity, @required this.connectionChecker});

  @override
  Future<bool> get isConnected async{
    var connectivityResult = await connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile
        || connectivityResult == ConnectivityResult.wifi) {
      return await connectionChecker.hasConnection;
    } else {
      return false;
    }
  }


}