import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_string_encryption/flutter_string_encryption.dart';
import 'package:git_commit_history/core/encryption/encryption_util.dart';
import 'package:git_commit_history/core/loader/factory.dart';
import 'package:git_commit_history/domain/entities/commit.dart';
import 'package:git_commit_history/presentation/commit_history/bloc/commit_history_bloc.dart';
import 'package:git_commit_history/presentation/commit_history/bloc/commit_history_event.dart';
import 'package:git_commit_history/presentation/commit_history/bloc/commit_history_state.dart';
import 'package:git_commit_history/presentation/commit_history/messages/commit_history_labels.dart';
import 'package:git_commit_history/presentation/commit_history/widget/commit_history_list_widget.dart';
import 'package:git_commit_history/presentation/commit_history/widget/commit_history_loading_widget.dart';

import 'commit_history_empty_commits_widget.dart';
import 'commit_history_error_widget.dart';
import 'commit_history_item_widget.dart';

class CommitHistoryPage extends StatefulWidget {
  CommitHistoryPage();

  @override
  _CommitHistoryPageState createState() => _CommitHistoryPageState();
}

class _CommitHistoryPageState extends State<CommitHistoryPage> {
  CommitHistoryBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = Factory.get<CommitHistoryBloc>();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _bloc.add(LoadAllCommitHistoryEvent()));
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Factory.get<CommitHistoryLabels>().title),
      ),
      body: Container(
        child: BlocBuilder(
          bloc: _bloc,
          builder: (context, state) {
            if (state is InitialCommitHistoryState ||
                state is LoadingCommitHistoryState) {
              return CommitHistoryLoadingWidget();
            } else if (state is LoadedEmptyCommitHistoryState) {
              return EmptyCommitHistoryLoadingWidget();
            } else if (state is LoadedCommitHistoryState) {
              return SingleChildScrollView(
                child: CommitHistoryListWidget(state.commits),
              );
            } else if (state is ErrorCommitHistoryState) {
              return CommitHistoryErrorWidget(state.errorMessage);
            } else {
              return Container();
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Container(child: Icon(Icons.refresh)),
        onPressed: () => _bloc.add(LoadAllCommitHistoryEvent()),
      ),
    );
  }
}
