import 'package:flutter/material.dart';
import 'package:git_commit_history/domain/entities/commit_details.dart';

import 'commit_details_file_widget.dart';

class CommitDetailsFileListWidget extends StatelessWidget {
  final List<CommitFile> commitFiles;

  CommitDetailsFileListWidget(this.commitFiles);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: commitFiles.map((c) => CommitDetailsFileWidget(c)).toList(),
      ),
    );
  }
}
