import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:git_commit_history/presentation/commit_details/data_interface/commit_details_loader.dart';
import 'package:git_commit_history/presentation/errors/ui_error_messages.dart';

import 'commit_details_event.dart';
import 'commit_details_state.dart';

class CommitDetailsBloc
    extends Bloc<CommitDetailsBlocEvent, CommitDetailsBlocState> {
  final CommitDetailsLoader loader;
  final UIErrorMessages uiErrorMessages;

  CommitDetailsBloc({@required this.loader, @required this.uiErrorMessages});

  @override
  CommitDetailsBlocState get initialState => InitialCommitDetailsBlocState();

  @override
  Stream<CommitDetailsBlocState> mapEventToState(
    CommitDetailsBlocEvent event,
  ) async* {
    if (event is LoadCommitDetailsBlocEvent) {
      yield CommitDetailsLoadingBlocState();
      CommitDetailsLoaderResult result;
      try {
        result = await loader.load(event.sha);
      } catch (e) {}
      if (result != null) {
        if (result.success) {
          if (result.commitDetails != null) {
            yield CommitDetailsLoadedBlocState(result.commitDetails);
          } else {
            yield CommitDetailsNotFoundBlocState();
          }
        } else {
          yield CommitDetailsLoadedWithErrorBlocState(result.errorMessage);
        }
      } else {
        yield CommitDetailsLoadedWithErrorBlocState(uiErrorMessages.general);
      }
    }
  }
}
