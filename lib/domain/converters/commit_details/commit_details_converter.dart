import 'package:git_commit_history/domain/entities/commit_details.dart';

import '../converter.dart';

/// The convert function throws
/// [CommitDetailsConversionError]
abstract class CommitDetailsConverter extends Converter<CommitDetails> {
  CommitDetails toCommitDetails(Map<String, dynamic> map);
}
