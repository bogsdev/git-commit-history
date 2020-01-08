import 'package:flutter/material.dart';

class Navigation {
  final GlobalKey<NavigatorState> key = new GlobalKey<NavigatorState>();
  Future<dynamic> navigateTo(String routeName, {dynamic arg}) {
    return key.currentState.pushNamed(routeName, arguments: arg);
  }
}
