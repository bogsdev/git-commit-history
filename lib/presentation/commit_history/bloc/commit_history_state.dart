import 'package:equatable/equatable.dart';
import 'package:git_commit_history/domain/entities/commit.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CommitHistoryState extends Equatable {}

class InitialCommitHistoryState extends CommitHistoryState {
  @override
  List<Object> get props => [];
}

class LoadingCommitHistoryState extends CommitHistoryState {
  @override
  List<Object> get props => [];
}

class LoadedCommitHistoryState extends CommitHistoryState {
  final List<Commit> commits;
  LoadedCommitHistoryState(this.commits);
  @override
  List<Object> get props => [commits];
}

class LoadedEmptyCommitHistoryState extends CommitHistoryState {
  @override
  List<Object> get props => [];
}

class ErrorCommitHistoryState extends CommitHistoryState {
  final String errorMessage;
  ErrorCommitHistoryState(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
}
