import 'package:flutter/material.dart';

abstract class CommitHistoryError implements Exception{}

class CommitHistoryTimeoutError extends CommitHistoryError{}
class CommitHistoryAuthenticationError extends CommitHistoryError{}
class CommitHistoryFailed extends CommitHistoryError{}
class CommitHistoryUnknownError extends CommitHistoryError{
  final exception;
  final StackTrace stackTrace;
  CommitHistoryUnknownError({@required this.exception, @required this.stackTrace});
}
