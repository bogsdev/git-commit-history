import 'package:flutter/material.dart';

import 'git_connection_info.dart';
import 'package:http/http.dart';

const SUCCESS_STATUS_CODE = 200;
const NOT_FOUND_STATUS_CODE = 404;
const FORBIDDEN_STATUS_CODE = 403;

class GitClient {
  final GitConnectionInfo connectionInfo;
  final MyGitClientHeaders header;
  final Client client;
  final timeout = const Duration(seconds: 30);

  GitClient(
      {@required this.connectionInfo,
      @required this.client,
      @required this.header});

  Future<Response> getCommits() async {
    return await client
        .get(connectionInfo.myRepositoryCommitsPath,
            headers: header.withAuthorization)
        .timeout(timeout);
  }
}

class MyGitClientHeaders {
  final GitConnectionInfo connectionInfo;

  MyGitClientHeaders(this.connectionInfo);

  Map<String, String> get withAuthorization => <String, String>{
        "Content-Type": "application/json; charset=utf-8",
        "Authorization": "token ${connectionInfo.myToken}"
      };
}
