import 'package:git_commit_history/domain/entities/commit_details.dart';

abstract class CommitDetailsRepository {
  final timeout = const Duration(seconds: 30);
  /// returns details of a commit
  /// This function throws the following
  /// [NoInternetConnectionError],
  /// [CommitHistoryConversionError],
  /// [CommitHistoryTimeoutError],
  /// [CommitHistoryAuthenticationError] and
  /// [CommitHistoryUnknownError]
  Future<CommitDetails> get(String sha);
}
