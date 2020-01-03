import 'package:flutter/material.dart';

//read only on public repository token
const String my_token = '29278978356931c488acde6c7a0519fab5262ee4';
const String my_user = 'bogsdev';
const String my_repository = 'git-commit-history';

enum Environments { dev, qa, staging, production }

class EnvironmentInfo {
  final Environments env;
  final String user;
  final String repository;
  final String token;

  EnvironmentInfo(
      {@required this.env,
      @required this.user,
      @required this.repository,
      @required this.token});
}
