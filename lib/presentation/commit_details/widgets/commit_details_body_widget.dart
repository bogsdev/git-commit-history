import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:git_commit_history/core/loader/factory.dart';
import 'package:git_commit_history/domain/entities/commit.dart';
import 'package:git_commit_history/presentation/commit_details/bloc/commit_details_bloc.dart';
import 'package:git_commit_history/presentation/commit_details/bloc/commit_details_event.dart';
import 'package:git_commit_history/presentation/commit_details/bloc/commit_details_state.dart';
import 'package:git_commit_history/presentation/commit_details/messages/commit_details_labels.dart';
import 'package:git_commit_history/presentation/commit_details/widgets/commit_details_error_widget.dart';
import 'package:git_commit_history/presentation/commit_details/widgets/commit_details_not_found_widget.dart';

import 'commit_details_file_list_widget.dart';
import 'commit_details_header_widget.dart';
import 'commit_details_loading_widget.dart';

class CommitDetailsPage extends StatefulWidget {
  final Commit commit;

  CommitDetailsPage(this.commit);

  @override
  _CommitDetailsPageState createState() => _CommitDetailsPageState();
}

class _CommitDetailsPageState extends State<CommitDetailsPage> {
  CommitDetailsBloc _commitDetailsBloc;

  @override
  void initState() {
    super.initState();
    _commitDetailsBloc = Factory.get();
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        _commitDetailsBloc.add(LoadCommitDetailsBlocEvent(widget.commit.sha)));
  }

  @override
  void dispose() {
    _commitDetailsBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Factory.get<CommitDetailsLabels>().title),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              child: CommitDetailsHeaderWidget(widget.commit),
            ),
            Expanded(
              child: Container(
                child: BlocBuilder(
                  bloc: _commitDetailsBloc,
                  builder: (context, state) {
                    if (state is InitialCommitDetailsBlocState ||
                        state is CommitDetailsLoadingBlocState) {
                      return CommitDetailsLoadingWidget();
                    } else if (state is CommitDetailsNotFoundBlocState) {
                      return CommitDetailsNotFoundWidget();
                    } else if (state is CommitDetailsLoadedBlocState) {
                      return SingleChildScrollView(
                        child: CommitDetailsFileListWidget(
                            state.commitDetails.files),
                      );
                    } else if (state is CommitDetailsLoadedWithErrorBlocState) {
                      return CommitDetailsErrorWidget(state.errorMessage);
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Container(child: Icon(Icons.refresh)),
        onPressed: () => _commitDetailsBloc
            .add(LoadCommitDetailsBlocEvent(widget.commit.sha)),
      ),
    );
  }
}
