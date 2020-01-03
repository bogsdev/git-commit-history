import 'package:git_commit_history/domain/entities/commit.dart';

abstract class CommitHistoryRepository{
  /// returns list of all [Commit]
  /// This function throws the following
  /// [NoInternetConnectionError],
  /// [CommitHistoryTimeoutError],
  /// [CommitHistoryAuthenticationError] and
  /// [CommitHistoryUnknownError]
  Future<List<Commit>> all();
}