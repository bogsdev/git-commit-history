import 'package:flutter_test/flutter_test.dart';
import 'package:git_commit_history/data/converters/commit_details/commit_details_converter.dart';
import 'package:git_commit_history/data/converters/commit_history/commit_history_converter.dart';
import 'package:git_commit_history/domain/converters/commit_details/commit_details_converter.dart';
import 'package:git_commit_history/domain/converters/commit_history/commit_history_converter.dart';
import 'package:git_commit_history/domain/entities/commit.dart';
import 'package:git_commit_history/domain/entities/commit_details.dart';
import 'package:git_commit_history/domain/errors/commit_details/commit_details_conversion_errors.dart';
import 'package:git_commit_history/domain/errors/commit_history/commit_history_conversion_errors.dart';

import '../../../data/reader.dart';

main() {
  CommitDetailsConverter converter = CommitDetailsConverterImpl();
  Reader reader = Reader();
  test('test toCommitDetails happy path', () async {
    CommitDetails commitDetails = converter.toCommitDetails({
      "sha": "12345",
      "commit": {
        "author": {"name": "me", "date": "2020-01-03T03:12:54Z"},
        "message": "test commit"
      },
      "files": [
        {"filename": "File.txt", "changes": 8, "status": "modified"}
      ]
    });

    expect(commitDetails.commit.sha, "12345");
    expect(commitDetails.commit.message, "test commit");
    expect(commitDetails.commit.author, "me");
    expect(commitDetails.commit.timestamp.isUtc, true);
    expect(commitDetails.commit.timestamp.toIso8601String(),
        DateTime.parse("2020-01-03T03:12:54Z").toIso8601String());
    expect(commitDetails.files.length, 1);
    expect(commitDetails.files.first.fileName, "File.txt");
    expect(commitDetails.files.first.changes, 8);
    expect(commitDetails.files.first.status, "modified");
  });

  test('test convert happy path', () async {
    CommitDetails commitDetails = converter
        .convert(reader.data('commit_details/commit_details_single.json'));
    expect(commitDetails != null, true);
    Commit commit = commitDetails.commit;
    expect(commit.sha, "12345");
    expect(commit.message, "test commit");
    expect(commit.author, "me");
    expect(commit.timestamp.isUtc, true);
    expect(commit.timestamp.toIso8601String(),
        DateTime.parse("2020-01-03T03:12:54Z").toIso8601String());
    expect(commitDetails.files.length, 1);
    expect(commitDetails.files.first.fileName, "File.txt");
    expect(commitDetails.files.first.changes, 8);
    expect(commitDetails.files.first.status, "modified");
  });

  test('test convert negative test', () async {
    try {
      CommitDetails commitDetails = converter.convert('{}');
    } catch (e) {
      expect(e is CommitDetailsConversionError, true);
    }

    try {
      CommitDetails commitDetails = converter.convert(null);
    } catch (e) {
      expect(e is CommitDetailsConversionError, true);
    }

    try {
      CommitDetails commitDetails = converter.convert("{}");
    } catch (e) {
      expect(e is CommitDetailsConversionError, true);
    }

    try {
      CommitDetails commitDetails = converter.convert(
          reader.data('commit_details/commit_details_single_invalid.json'));
    } catch (e) {
      expect(e is CommitDetailsConversionError, true);
    }
  });
}
