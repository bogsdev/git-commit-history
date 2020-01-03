import 'package:get_it/get_it.dart';

class Factory{
  static GetIt get i => GetIt.I;
  static T get<T>() => i<T>();
  static reset() => i.reset();
}