import 'dart:convert';

import 'package:git_commit_history/domain/entities/commit.dart';

import '../../../domain/converters/converter.dart';

/// The convert function throws
/// [CommitHistoryConversionError]
abstract class CommitHistoryConvert extends Converter<List<Commit>>{
  Commit toCommit(Map<String,dynamic> map);
  List<Commit> toCommitList(List<dynamic> maps);
}