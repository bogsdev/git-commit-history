import 'package:equatable/equatable.dart';
import 'package:git_commit_history/domain/entities/commit_details.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CommitDetailsBlocState extends Equatable {}

class InitialCommitDetailsBlocState extends CommitDetailsBlocState {
  @override
  List<Object> get props => [];
}

class CommitDetailsLoadingBlocState extends CommitDetailsBlocState {
  @override
  List<Object> get props => [];
}

class CommitDetailsLoadedBlocState extends CommitDetailsBlocState {
  final CommitDetails commitDetails;

  CommitDetailsLoadedBlocState(this.commitDetails);

  @override
  List<Object> get props => [commitDetails];
}

class CommitDetailsNotFoundBlocState extends CommitDetailsBlocState {
  @override
  List<Object> get props => [];
}

class CommitDetailsLoadedWithErrorBlocState extends CommitDetailsBlocState {
  final String errorMessage;

  CommitDetailsLoadedWithErrorBlocState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
