import 'dart:io';

class Reader {
  String data(String name) => File('test/data/json/$name').readAsStringSync();
}
