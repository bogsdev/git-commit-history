import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class CommitDetailsBlocEvent extends Equatable {}

class LoadCommitDetailsBlocEvent extends CommitDetailsBlocEvent {
  final String sha;

  LoadCommitDetailsBlocEvent(this.sha);

  @override
  List<Object> get props => [sha];
}
