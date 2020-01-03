import 'package:flutter/material.dart';
import 'package:git_commit_history/domain/entities/commit.dart';
import 'package:git_commit_history/domain/repositories/commit_history_repository.dart';
import 'package:git_commit_history/presentation/commit_history/messages/commit_history_ui_errors.dart';
import 'package:git_commit_history/core/errors/connection_errors/connection_errors.dart';
import 'package:git_commit_history/domain/errors/commit_history/commit_history_conversion_errors.dart';
import 'package:git_commit_history/domain/errors/commit_history/commit_history_errors.dart';
import 'dart:async';

class CommitHistoryLoaderResult {
  final List<Commit> commits;
  final String errorMessage;

  CommitHistoryLoaderResult({this.commits, this.errorMessage});

  bool get success => errorMessage == null;
}

class CommitHistoryLoader {
  final CommitHistoryRepository repository;
  final CommitHistoryErrorMessages messages;

  CommitHistoryLoader({@required this.repository, @required this.messages});

  Future<CommitHistoryLoaderResult> load() async {
    String errorMessage;
    try {
      List<Commit> commits = await repository.all();
      return CommitHistoryLoaderResult(commits: commits);
    } on NoInternetConnectionError catch (e) {
      errorMessage = messages.noInternetConnection;
    } on CommitHistoryTimeoutError catch (e) {
      errorMessage = messages.timeOut;
    } on CommitHistoryConversionError catch (e) {
      errorMessage = messages.general;
    } on CommitHistoryAuthenticationError catch (e) {
      errorMessage = messages.general;
    } on CommitHistoryFailed catch (e) {
      errorMessage = messages.general;
    } on CommitHistoryUnknownError catch (e) {
      //TODO: Add further handling
      errorMessage = messages.general;
    }
    return CommitHistoryLoaderResult(errorMessage: errorMessage);
  }
}
