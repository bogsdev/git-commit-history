import 'dart:convert';

import 'package:git_commit_history/domain/converters/commit_history/commit_history_converter.dart';
import 'package:git_commit_history/domain/entities/commit.dart';
import 'package:git_commit_history/domain/errors/commit_history/commit_history_conversion_errors.dart';

class CommitHistoryConvertImpl extends CommitHistoryConvert {
  @override
  List<Commit> convert(String jsonString) {
    try {
      List<dynamic> maps = json.decode(jsonString);
      return toCommitList(maps);
    } catch (e, s) {
      throw CommitHistoryConversionError(exception: e, stackTrace: s);
    }
  }

  @override
  Commit toCommit(Map<String, dynamic> map) {
    return Commit(
        message: map['commit']['message'],
        author: map['commit']['author']['name'],
        sha: map['sha'],
        timestamp: DateTime.parse(map['commit']['author']['date']));
  }

  @override
  List<Commit> toCommitList(List<dynamic> maps) {
    return maps.map((m) => toCommit(m as Map<String,dynamic>)).toList();
  }
}
