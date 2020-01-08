import 'package:flutter/material.dart';

abstract class CommitDetailsError implements Exception {}

class CommitDetailsTimeoutError extends CommitDetailsError {}

class CommitDetailsAuthenticationError extends CommitDetailsError {}

class CommitDetailsFailed extends CommitDetailsError {}

class CommitDetailsUnknownError extends CommitDetailsError {
  final exception;
  final StackTrace stackTrace;
  CommitDetailsUnknownError(
      {@required this.exception, @required this.stackTrace});
}
