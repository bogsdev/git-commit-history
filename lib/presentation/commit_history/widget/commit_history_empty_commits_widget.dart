import 'package:flutter/material.dart';
import 'package:git_commit_history/core/loader/factory.dart';
import 'package:git_commit_history/presentation/commit_history/messages/commit_history_labels.dart';

class EmptyCommitHistoryLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Container(
          height: 60.0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(Factory.get<CommitHistoryLabels>().noCommitsAvailable),
          ),
        ),
      ),
    );
  }
}
