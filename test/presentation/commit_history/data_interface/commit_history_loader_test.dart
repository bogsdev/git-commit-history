import 'package:flutter_test/flutter_test.dart';
import 'package:git_commit_history/core/errors/connection_errors/connection_errors.dart';
import 'package:git_commit_history/domain/entities/commit.dart';
import 'package:git_commit_history/domain/errors/commit_history/commit_history_conversion_errors.dart';
import 'package:git_commit_history/domain/errors/commit_history/commit_history_errors.dart';
import 'package:git_commit_history/domain/repositories/commit_history_repository.dart';
import 'package:git_commit_history/presentation/commit_history/data_interface/commit_history_loader.dart';
import 'package:git_commit_history/presentation/commit_history/messages/commit_history_ui_errors.dart';
import 'package:mockito/mockito.dart';

class MockCommitHistoryRepository extends Mock
    implements CommitHistoryRepository {}

main() {
  CommitHistoryRepository mockCommitHistoryRepository =
      MockCommitHistoryRepository();
  CommitHistoryErrorMessages messages = CommitHistoryErrorMessages();
  CommitHistoryLoader loader = CommitHistoryLoader(
      repository: mockCommitHistoryRepository, messages: messages);
  test('test load happy path', () async {
    when(mockCommitHistoryRepository.all()).thenAnswer((_) async => []);
    CommitHistoryLoaderResult result = await loader.load();
    expect(result.success, true);
    expect(result.commits.length, 0);

    when(mockCommitHistoryRepository.all()).thenAnswer((_) async => [
          Commit(
              sha: "12345",
              author: "me",
              message: "test commit",
              timestamp: DateTime.parse('2020-01-03T03:12:54Z'))
        ]);
    result = await loader.load();
    expect(result.success, true);
    expect(result.commits.length, 1);
    Commit commit = result.commits.first;
    expect(commit.sha, "12345");
    expect(commit.message, "test commit");
    expect(commit.author, "me");
    expect(commit.timestamp.isUtc, true);
    expect(commit.timestamp.toIso8601String(),
        DateTime.parse("2020-01-03T03:12:54Z").toIso8601String());

    when(mockCommitHistoryRepository.all()).thenAnswer((_) async => [
          Commit(
              sha: "12345",
              author: "me",
              message: "test commit",
              timestamp: DateTime.parse('2020-01-03T03:12:54Z')),
          Commit(
              sha: "23456",
              author: "you",
              message: "another test commit",
              timestamp: DateTime.parse('2020-01-04T03:12:54Z'))
        ]);
    result = await loader.load();
    expect(result.success, true);
    expect(result.commits.length, 2);
    commit = result.commits.first;
    expect(commit.sha, "12345");
    expect(commit.message, "test commit");
    expect(commit.author, "me");
    expect(commit.timestamp.isUtc, true);
    expect(commit.timestamp.toIso8601String(),
        DateTime.parse("2020-01-03T03:12:54Z").toIso8601String());
    commit = result.commits.last;
    expect(commit.sha, "23456");
    expect(commit.message, "another test commit");
    expect(commit.author, "you");
    expect(commit.timestamp.isUtc, true);
    expect(commit.timestamp.toIso8601String(),
        DateTime.parse("2020-01-04T03:12:54Z").toIso8601String());
  });

  test('test load happy path - no internet', () async {
    when(mockCommitHistoryRepository.all())
        .thenThrow(NoInternetConnectionError());
    CommitHistoryLoaderResult result = await loader.load();
    expect(result.success, false);
    expect(result.errorMessage, messages.noInternetConnection);
  });

  test('test load happy path - timeout error', () async {
    when(mockCommitHistoryRepository.all())
        .thenThrow(CommitHistoryTimeoutError());
    CommitHistoryLoaderResult result = await loader.load();
    expect(result.success, false);
    expect(result.errorMessage, messages.timeOut);
  });

  test('test load happy path - other errors', () async {
    when(mockCommitHistoryRepository.all())
        .thenThrow(CommitHistoryConversionError());
    CommitHistoryLoaderResult result = await loader.load();
    expect(result.success, false);
    expect(result.errorMessage, messages.general);

    when(mockCommitHistoryRepository.all())
        .thenThrow(CommitHistoryAuthenticationError());
    result = await loader.load();
    expect(result.success, false);
    expect(result.errorMessage, messages.general);

    when(mockCommitHistoryRepository.all()).thenThrow(CommitHistoryFailed());
    result = await loader.load();
    expect(result.success, false);
    expect(result.errorMessage, messages.general);

    when(mockCommitHistoryRepository.all())
        .thenThrow(CommitHistoryUnknownError());
    result = await loader.load();
    expect(result.success, false);
    expect(result.errorMessage, messages.general);
  });

  test('test load negative test', () async {
    when(mockCommitHistoryRepository.all())
        .thenThrow(Exception('unknown exception'));
    var error;
    try {
      CommitHistoryLoaderResult result = await loader.load();
    } catch (e) {
      error = e;
    }
    expect(error.toString(), 'Exception: unknown exception');
  });
}
