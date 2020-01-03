abstract class CommitHistoryError implements Exception{}

class CommitHistoryTimeoutError extends CommitHistoryError{}
class CommitHistoryAuthenticationError extends CommitHistoryError{}
class CommitHistoryUnknownError extends CommitHistoryError{}
