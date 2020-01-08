import 'package:git_commit_history/core/errors/conversion_errors/conversion_errors.dart';

class CommitDetailsConversionError extends ConversionError {
  final exception;
  final StackTrace stackTrace;

  CommitDetailsConversionError({this.exception, this.stackTrace});
}
