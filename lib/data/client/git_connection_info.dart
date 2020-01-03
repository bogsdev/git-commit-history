
import 'package:git_commit_history/core/environments/Environments.dart';

class GitConnectionInfo {
  final EnvironmentInfo environmentInfo;
  final String scheme = 'https';
  final String host = 'api.github.com';
  final String repos = 'repos';
  final String commits = 'commits';
  GitConnectionInfo(this.environmentInfo);

  String get hostPath => '$scheme://$host';
  String get reposPath => '$hostPath/$repos';
  String get myReposPath => '$reposPath/${environmentInfo.user}';
  String get myRepositoryPath => '$myReposPath/${environmentInfo.repository}';
  String get myRepositoryCommitsPath => '$myRepositoryPath/$commits';
  String get myToken => '${environmentInfo.token}';

}
