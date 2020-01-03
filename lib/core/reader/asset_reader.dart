import 'package:flutter/services.dart';

class AssetReader{
  Future<String> readAsset(String path) async {
    return await rootBundle.loadString(path);
  }
}