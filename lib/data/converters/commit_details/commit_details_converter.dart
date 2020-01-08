import 'dart:convert';

import 'package:git_commit_history/domain/converters/commit_details/commit_details_converter.dart';
import 'package:git_commit_history/domain/entities/commit_details.dart';
import 'package:git_commit_history/domain/errors/commit_details/commit_details_conversion_errors.dart';

import '../../../domain/entities/commit.dart';

class CommitDetailsConverterImpl extends CommitDetailsConverter {
  @override
  CommitDetails convert(String jsonString) {
    try {
      Map<String, dynamic> map = json.decode(jsonString);
      return toCommitDetails(map);
    } catch (e, s) {
      throw CommitDetailsConversionError(exception: e, stackTrace: s);
    }
  }

  @override
  CommitDetails toCommitDetails(Map<String, dynamic> map) {
    return CommitDetails(
        commit: Commit(
            message: map['commit']['message'],
            author: map['commit']['author']['name'],
            sha: map['sha'],
            timestamp: DateTime.parse(map['commit']['author']['date'])),
        files: map['files'] != null
            ? (map['files'] as List)
                .map((m) => CommitFile(
                    fileName: m['filename'],
                    changes: m['changes'],
                    status: m['status']))
                .toList()
            : null);
  }
}
