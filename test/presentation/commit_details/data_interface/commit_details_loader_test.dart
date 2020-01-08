import 'package:flutter_test/flutter_test.dart';
import 'package:git_commit_history/core/errors/connection_errors/connection_errors.dart';
import 'package:git_commit_history/domain/entities/commit.dart';
import 'package:git_commit_history/domain/entities/commit_details.dart';
import 'package:git_commit_history/domain/errors/commit_details/commit_details_conversion_errors.dart';
import 'package:git_commit_history/domain/errors/commit_details/commit_details_errors.dart';
import 'package:git_commit_history/domain/repositories/commit_details_repository.dart';
import 'package:git_commit_history/presentation/commit_details/data_interface/commit_details_loader.dart';
import 'package:git_commit_history/presentation/commit_details/messages/commit_details_ui_errors.dart';
import 'package:mockito/mockito.dart';

class MockCommitDetailsRepository extends Mock
    implements CommitDetailsRepository {}

main() {
  CommitDetailsRepository mockCommitDetailsRepository =
      MockCommitDetailsRepository();
  CommitDetailsErrorMessages messages = CommitDetailsErrorMessages();
  CommitDetailsLoader loader = CommitDetailsLoader(
      repository: mockCommitDetailsRepository, messages: messages);
  String input = 'sha';
  test('test load happy path', () async {
    when(mockCommitDetailsRepository.get(input)).thenAnswer((_) async =>
        CommitDetails(
            commit: Commit(
                sha: "12345",
                author: "me",
                message: "test commit",
                timestamp: DateTime.parse('2020-01-03T03:12:54Z')),
            files: [
              CommitFile(fileName: 'File.txt', changes: 8, status: 'modified')
            ]));
    CommitDetailsLoaderResult result = await loader.load(input);
    expect(result.success, true);
    expect(result.commitDetails != null, true);

    CommitDetails commitDetails = result.commitDetails;
    Commit commit = commitDetails.commit;

    expect(commit.sha, "12345");
    expect(commit.message, "test commit");
    expect(commit.author, "me");
    expect(commit.timestamp.isUtc, true);
    expect(commit.timestamp.toIso8601String(),
        DateTime.parse("2020-01-03T03:12:54Z").toIso8601String());
    expect(commitDetails.files.length, 1);
    expect(commitDetails.files.first.fileName, "File.txt");
    expect(commitDetails.files.first.changes, 8);
    expect(commitDetails.files.first.status, "modified");
  });

  test('test load happy path - no internet', () async {
    when(mockCommitDetailsRepository.get(input))
        .thenThrow(NoInternetConnectionError());
    CommitDetailsLoaderResult result = await loader.load(input);
    expect(result.success, false);
    expect(result.errorMessage, messages.noInternetConnection);
  });

  test('test load happy path - timeout error', () async {
    when(mockCommitDetailsRepository.get(input))
        .thenThrow(CommitDetailsTimeoutError());
    CommitDetailsLoaderResult result = await loader.load(input);
    expect(result.success, false);
    expect(result.errorMessage, messages.timeOut);
  });

  test('test load happy path - other errors', () async {
    when(mockCommitDetailsRepository.get(input))
        .thenThrow(CommitDetailsConversionError());
    CommitDetailsLoaderResult result = await loader.load(input);
    expect(result.success, false);
    expect(result.errorMessage, messages.fetchFailed);

    when(mockCommitDetailsRepository.get(input))
        .thenThrow(CommitDetailsAuthenticationError());
    result = await loader.load(input);
    expect(result.success, false);
    expect(result.errorMessage, messages.fetchFailed);

    when(mockCommitDetailsRepository.get(input))
        .thenThrow(CommitDetailsFailed());
    result = await loader.load(input);
    expect(result.success, false);
    expect(result.errorMessage, messages.fetchFailed);

    when(mockCommitDetailsRepository.get(input))
        .thenThrow(CommitDetailsUnknownError());
    result = await loader.load(input);
    expect(result.success, false);
    expect(result.errorMessage, messages.fetchFailed);
  });

  test('test load negative test', () async {
    when(mockCommitDetailsRepository.get(input))
        .thenThrow(Exception('unknown exception'));
    var error;
    try {
      CommitDetailsLoaderResult result = await loader.load(input);
    } catch (e) {
      error = e;
    }
    expect(error.toString(), 'Exception: unknown exception');
  });
}
