import 'package:git_commit_history/core/errors/conversion_errors/conversion_errors.dart';

class CommitHistoryConversionError extends ConversionError {
  final exception;
  final StackTrace stackTrace;

  CommitHistoryConversionError({this.exception, this.stackTrace});
}
