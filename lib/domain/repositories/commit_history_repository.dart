import 'package:git_commit_history/domain/entities/commit.dart';
import 'package:git_commit_history/domain/errors/commit_history/commit_history_conversion_errors.dart';

abstract class CommitHistoryRepository {
  /// returns list of all [Commit]
  /// This function throws the following
  /// [NoInternetConnectionError],
  /// [CommitHistoryConversionError],
  /// [CommitHistoryTimeoutError],
  /// [CommitHistoryAuthenticationError] and
  /// [CommitHistoryUnknownError]
  Future<List<Commit>> all();
}
