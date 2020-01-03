import 'package:flutter/material.dart';
import 'package:git_commit_history/domain/entities/commit.dart';

import 'commit_history_item_widget.dart';

class CommitHistoryListWidget extends StatelessWidget {
  final List<Commit> commits;

  CommitHistoryListWidget(this.commits);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: commits.map((c) => CommitHistoryItemWidget(c)).toList(),
      ),
    );
  }
}
