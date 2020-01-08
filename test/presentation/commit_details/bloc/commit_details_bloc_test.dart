import 'package:bloc_test/bloc_test.dart';
import 'package:git_commit_history/domain/entities/commit.dart';
import 'package:git_commit_history/domain/entities/commit_details.dart';
import 'package:git_commit_history/presentation/commit_details/bloc/commit_details_bloc.dart';
import 'package:git_commit_history/presentation/commit_details/bloc/commit_details_event.dart';
import 'package:git_commit_history/presentation/commit_details/bloc/commit_details_state.dart';
import 'package:git_commit_history/presentation/commit_details/data_interface/commit_details_loader.dart';
import 'package:git_commit_history/presentation/commit_details/messages/commit_details_ui_errors.dart';
import 'package:git_commit_history/presentation/commit_history/bloc/commit_history_bloc.dart';
import 'package:git_commit_history/presentation/commit_history/bloc/commit_history_event.dart';
import 'package:git_commit_history/presentation/commit_history/bloc/commit_history_state.dart';
import 'package:git_commit_history/presentation/commit_history/data_interface/commit_history_loader.dart';
import 'package:git_commit_history/presentation/commit_history/messages/commit_history_ui_errors.dart';
import 'package:git_commit_history/presentation/errors/ui_error_messages.dart';
import 'package:mockito/mockito.dart';

class MockCommitDetailsLoader extends Mock implements CommitDetailsLoader {}

main() {
  CommitDetailsLoader mockCommitDetailsLoader = MockCommitDetailsLoader();
  UIErrorMessages uiErrorMessages = UIErrorMessages();
  CommitDetailsErrorMessages expectedMessages = CommitDetailsErrorMessages();
  String input = 'sha';
  blocTest(
    'test happy path - no result',
    build: () {
      when(mockCommitDetailsLoader.load(input))
          .thenAnswer((_) async => CommitDetailsLoaderResult());
      return CommitDetailsBloc(
          loader: mockCommitDetailsLoader, uiErrorMessages: uiErrorMessages);
    },
    act: (bloc) => bloc.add(LoadCommitDetailsBlocEvent(input)),
    expect: [
      InitialCommitDetailsBlocState(),
      CommitDetailsLoadingBlocState(),
      CommitDetailsNotFoundBlocState()
    ],
  );

  blocTest(
    'test happy path - with result',
    build: () {
      when(mockCommitDetailsLoader.load(input)).thenAnswer((_) async =>
          CommitDetailsLoaderResult(
              commitDetails: CommitDetails(
                  commit: Commit(
                      sha: "12345",
                      author: "me",
                      message: "test commit",
                      timestamp: DateTime.parse('2020-01-03T03:12:54Z')),
                  files: [
                CommitFile(fileName: 'File.txt', changes: 8, status: 'modified')
              ])));
      return CommitDetailsBloc(
          loader: mockCommitDetailsLoader, uiErrorMessages: uiErrorMessages);
    },
    act: (bloc) => bloc.add(LoadCommitDetailsBlocEvent(input)),
    expect: [
      InitialCommitDetailsBlocState(),
      CommitDetailsLoadingBlocState(),
      CommitDetailsLoadedBlocState(CommitDetails(
          commit: Commit(
              sha: "12345",
              author: "me",
              message: "test commit",
              timestamp: DateTime.parse('2020-01-03T03:12:54Z')),
          files: [
            CommitFile(fileName: 'File.txt', changes: 8, status: 'modified')
          ]))
    ],
  );

  blocTest(
    'test happy path - no internet',
    build: () {
      when(mockCommitDetailsLoader.load(input)).thenAnswer((_) async =>
          CommitDetailsLoaderResult(
              errorMessage: expectedMessages.noInternetConnection));
      return CommitDetailsBloc(
          loader: mockCommitDetailsLoader, uiErrorMessages: uiErrorMessages);
    },
    act: (bloc) => bloc.add(LoadCommitDetailsBlocEvent(input)),
    expect: [
      InitialCommitDetailsBlocState(),
      CommitDetailsLoadingBlocState(),
      CommitDetailsLoadedWithErrorBlocState(
          expectedMessages.noInternetConnection)
    ],
  );

  blocTest(
    'test happy path - timeout',
    build: () {
      when(mockCommitDetailsLoader.load(input)).thenAnswer((_) async =>
          CommitDetailsLoaderResult(errorMessage: expectedMessages.timeOut));
      return CommitDetailsBloc(
          loader: mockCommitDetailsLoader, uiErrorMessages: uiErrorMessages);
    },
    act: (bloc) => bloc.add(LoadCommitDetailsBlocEvent(input)),
    expect: [
      InitialCommitDetailsBlocState(),
      CommitDetailsLoadingBlocState(),
      CommitDetailsLoadedWithErrorBlocState(expectedMessages.timeOut)
    ],
  );

  blocTest(
    'test happy path - general error',
    build: () {
      when(mockCommitDetailsLoader.load(input)).thenAnswer((_) async =>
          CommitDetailsLoaderResult(
              errorMessage: expectedMessages.fetchFailed));
      return CommitDetailsBloc(
          loader: mockCommitDetailsLoader, uiErrorMessages: uiErrorMessages);
    },
    act: (bloc) => bloc.add(LoadCommitDetailsBlocEvent(input)),
    expect: [
      InitialCommitDetailsBlocState(),
      CommitDetailsLoadingBlocState(),
      CommitDetailsLoadedWithErrorBlocState(expectedMessages.fetchFailed)
    ],
  );

  blocTest(
    'test happy path - negative',
    build: () {
      when(mockCommitDetailsLoader.load(input))
          .thenThrow(Exception('unknown exception'));
      return CommitDetailsBloc(
          loader: mockCommitDetailsLoader, uiErrorMessages: uiErrorMessages);
    },
    act: (bloc) => bloc.add(LoadCommitDetailsBlocEvent(input)),
    expect: [
      InitialCommitDetailsBlocState(),
      CommitDetailsLoadingBlocState(),
      CommitDetailsLoadedWithErrorBlocState(uiErrorMessages.general)
    ],
  );
}
