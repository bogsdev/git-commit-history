import 'package:bloc_test/bloc_test.dart';
import 'package:git_commit_history/domain/entities/commit.dart';
import 'package:git_commit_history/presentation/commit_history/bloc/commit_history_bloc.dart';
import 'package:git_commit_history/presentation/commit_history/bloc/commit_history_event.dart';
import 'package:git_commit_history/presentation/commit_history/bloc/commit_history_state.dart';
import 'package:git_commit_history/presentation/commit_history/data_interface/commit_history_loader.dart';
import 'package:git_commit_history/presentation/commit_history/messages/commit_history_ui_errors.dart';
import 'package:git_commit_history/presentation/errors/ui_error_messages.dart';
import 'package:mockito/mockito.dart';

class MockCommitHistoryLoader extends Mock implements CommitHistoryLoader {}

main() {
  CommitHistoryLoader mockCommitHistoryLoader = MockCommitHistoryLoader();
  UIErrorMessages uiErrorMessages = UIErrorMessages();
  CommitHistoryErrorMessages expectedMessages = CommitHistoryErrorMessages();

  blocTest(
    'test happy path - no result',
    build: () {
      when(mockCommitHistoryLoader.load())
          .thenAnswer((_) async => CommitHistoryLoaderResult(commits: []));
      return CommitHistoryBloc(
          loader: mockCommitHistoryLoader, uiErrorMessages: uiErrorMessages);
    },
    act: (bloc) => bloc.add(LoadAllCommitHistoryEvent()),
    expect: [
      InitialCommitHistoryState(),
      LoadingCommitHistoryState(),
      LoadedEmptyCommitHistoryState()
    ],
  );

  blocTest(
    'test happy path - with result',
    build: () {
      when(mockCommitHistoryLoader.load())
          .thenAnswer((_) async => CommitHistoryLoaderResult(commits: [
                Commit(
                    sha: "12345",
                    author: "me",
                    message: "test commit",
                    timestamp: DateTime.parse('2020-01-03T03:12:54Z'))
              ]));
      return CommitHistoryBloc(
          loader: mockCommitHistoryLoader, uiErrorMessages: uiErrorMessages);
    },
    act: (bloc) => bloc.add(LoadAllCommitHistoryEvent()),
    expect: [
      InitialCommitHistoryState(),
      LoadingCommitHistoryState(),
      LoadedCommitHistoryState([
        Commit(
            sha: "12345",
            author: "me",
            message: "test commit",
            timestamp: DateTime.parse('2020-01-03T03:12:54Z'))
      ])
    ],
  );

  blocTest(
    'test happy path - no internet',
    build: () {
      when(mockCommitHistoryLoader.load()).thenAnswer((_) async =>
          CommitHistoryLoaderResult(
              errorMessage: expectedMessages.noInternetConnection));
      return CommitHistoryBloc(
          loader: mockCommitHistoryLoader, uiErrorMessages: uiErrorMessages);
    },
    act: (bloc) => bloc.add(LoadAllCommitHistoryEvent()),
    expect: [
      InitialCommitHistoryState(),
      LoadingCommitHistoryState(),
      ErrorCommitHistoryState(expectedMessages.noInternetConnection)
    ],
  );

  blocTest(
    'test happy path - timeout',
    build: () {
      when(mockCommitHistoryLoader.load()).thenAnswer((_) async =>
          CommitHistoryLoaderResult(errorMessage: expectedMessages.timeOut));
      return CommitHistoryBloc(
          loader: mockCommitHistoryLoader, uiErrorMessages: uiErrorMessages);
    },
    act: (bloc) => bloc.add(LoadAllCommitHistoryEvent()),
    expect: [
      InitialCommitHistoryState(),
      LoadingCommitHistoryState(),
      ErrorCommitHistoryState(expectedMessages.timeOut)
    ],
  );

  blocTest(
    'test happy path - general error',
    build: () {
      when(mockCommitHistoryLoader.load()).thenAnswer((_) async =>
          CommitHistoryLoaderResult(errorMessage: expectedMessages.general));
      return CommitHistoryBloc(
          loader: mockCommitHistoryLoader, uiErrorMessages: uiErrorMessages);
    },
    act: (bloc) => bloc.add(LoadAllCommitHistoryEvent()),
    expect: [
      InitialCommitHistoryState(),
      LoadingCommitHistoryState(),
      ErrorCommitHistoryState(expectedMessages.general)
    ],
  );

  blocTest(
    'test happy path - negative',
    build: () {
      when(mockCommitHistoryLoader.load())
          .thenThrow(Exception('unknown exception'));
      return CommitHistoryBloc(
          loader: mockCommitHistoryLoader, uiErrorMessages: uiErrorMessages);
    },
    act: (bloc) => bloc.add(LoadAllCommitHistoryEvent()),
    expect: [
      InitialCommitHistoryState(),
      LoadingCommitHistoryState(),
      ErrorCommitHistoryState(uiErrorMessages.general)
    ],
  );
}
