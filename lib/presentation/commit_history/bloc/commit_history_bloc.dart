import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:git_commit_history/presentation/commit_history/data_interface/commit_history_loader.dart';
import 'package:git_commit_history/presentation/errors/ui_error_messages.dart';

import 'commit_history_event.dart';
import 'commit_history_state.dart';

class CommitHistoryBloc extends Bloc<CommitHistoryEvent, CommitHistoryState> {
  final CommitHistoryLoader loader;
  final UIErrorMessages uiErrorMessages;

  CommitHistoryBloc({@required this.loader, @required this.uiErrorMessages});

  @override
  CommitHistoryState get initialState => InitialCommitHistoryState();

  @override
  Stream<CommitHistoryState> mapEventToState(
    CommitHistoryEvent event,
  ) async* {
    if (event is LoadAllCommitHistoryEvent) {
      yield LoadingCommitHistoryState();
      CommitHistoryLoaderResult result;
      try {
        result = await loader.load();
      } catch (e) {}
      if (result != null) {
        if (result.success) {
          if(result.commits.length > 0) {
            yield LoadedCommitHistoryState(result.commits);
          } else {
            yield LoadedEmptyCommitHistoryState();
          }
        } else {
          yield ErrorCommitHistoryState(result.errorMessage);
        }
      } else {
        yield ErrorCommitHistoryState(uiErrorMessages.general);
      }
    }
  }
}
