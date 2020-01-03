
import 'package:meta/meta.dart';

@immutable
abstract class CommitHistoryEvent{}

class LoadAllCommitHistoryEvent extends CommitHistoryEvent{}
