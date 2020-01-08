import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'commit.dart';

class CommitDetails extends Equatable {
  final Commit commit;
  final List<CommitFile> files;

  CommitDetails({@required this.commit, this.files});

  @override
  List<Object> get props => [commit];
}

class CommitFile extends Equatable {
  final String fileName;
  final String status;
  final int changes;

  CommitFile(
      {@required this.fileName, @required this.status, @required this.changes});

  @override
  List<Object> get props => [fileName];
}
