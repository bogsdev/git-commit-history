import 'package:flutter/material.dart';

//read only on public repository token
const String my_token = 'd6bbf5144cc7fa4a1e527a363a754d98210b4116';
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
