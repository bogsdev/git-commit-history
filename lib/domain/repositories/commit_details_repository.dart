import 'package:git_commit_history/domain/entities/commit_details.dart';

abstract class CommitDetailsRepository {
  /// returns details of a commit
  /// This function throws the following
  /// [NoInternetConnectionError],
  /// [CommitHistoryConversionError],
  /// [CommitHistoryTimeoutError],
  /// [CommitHistoryAuthenticationError] and
  /// [CommitHistoryUnknownError]
  Future<CommitDetails> get(String sha);
}
