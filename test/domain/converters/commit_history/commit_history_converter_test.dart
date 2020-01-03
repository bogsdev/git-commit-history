import 'package:flutter_test/flutter_test.dart';
import 'package:git_commit_history/data/converters/commit_history/commit_history_converter.dart';
import 'package:git_commit_history/domain/converters/commit_history/commit_history_converter.dart';
import 'package:git_commit_history/domain/entities/commit.dart';
import 'package:git_commit_history/domain/errors/commit_history/commit_history_conversion_errors.dart';

import '../../../data/reader.dart';

main() {
  CommitHistoryConvert converter = CommitHistoryConvertImpl();
  Reader reader = Reader();
  test('test toCommit happy path', () async {
    Commit commit = converter.toCommit({
      "sha": "12345",
      "commit": {
        "author": {"name": "me", "date": "2020-01-03T03:12:54Z"},
        "message": "test commit"
      }
    });

    expect(commit.sha, "12345");
    expect(commit.message, "test commit");
    expect(commit.author, "me");
    expect(commit.timestamp.isUtc, true);
    expect(commit.timestamp.toIso8601String(),
        DateTime.parse("2020-01-03T03:12:54Z").toIso8601String());
  });

  test('test toCommitList happy path', () async {
    List<Commit> commits = converter.toCommitList([]);
    expect(commits.length, 0);
    commits = converter.toCommitList([
      {
        "sha": "12345",
        "commit": {
          "author": {"name": "me", "date": "2020-01-03T03:12:54Z"},
          "message": "test commit"
        }
      }
    ]);
    expect(commits.length, 1);
    Commit commit = commits.first;
    expect(commit.sha, "12345");
    expect(commit.message, "test commit");
    expect(commit.author, "me");
    expect(commit.timestamp.isUtc, true);
    expect(commit.timestamp.toIso8601String(),
        DateTime.parse("2020-01-03T03:12:54Z").toIso8601String());

    commits = converter.toCommitList([
      {
        "sha": "12345",
        "commit": {
          "author": {"name": "me", "date": "2020-01-03T03:12:54Z"},
          "message": "test commit"
        }
      },
      {
        "sha": "23456",
        "commit": {
          "author": {"name": "you", "date": "2020-01-04T03:12:54Z"},
          "message": "another test commit"
        }
      }
    ]);
    expect(commits.length, 2);
    commit = commits.first;
    expect(commit.sha, "12345");
    expect(commit.message, "test commit");
    expect(commit.author, "me");
    expect(commit.timestamp.isUtc, true);
    expect(commit.timestamp.toIso8601String(),
        DateTime.parse("2020-01-03T03:12:54Z").toIso8601String());

    commit = commits.last;
    expect(commit.sha, "23456");
    expect(commit.message, "another test commit");
    expect(commit.author, "you");
    expect(commit.timestamp.isUtc, true);
    expect(commit.timestamp.toIso8601String(),
        DateTime.parse("2020-01-04T03:12:54Z").toIso8601String());
  });

  test('test convert happy path', () async {
    List<Commit> commits = converter.convert("[]");
    expect(commits.length, 0);

    commits = converter.convert(reader.data('commit_history_single.json'));
    expect(commits.length, 1);
    Commit commit = commits.first;
    expect(commit.sha, "12345");
    expect(commit.message, "test commit");
    expect(commit.author, "me");
    expect(commit.timestamp.isUtc, true);
    expect(commit.timestamp.toIso8601String(),
        DateTime.parse("2020-01-03T03:12:54Z").toIso8601String());

    commits = converter.convert(reader.data('commit_history_multiple.json'));
    expect(commits.length, 2);
    commit = commits.first;
    expect(commit.sha, "12345");
    expect(commit.message, "test commit");
    expect(commit.author, "me");
    expect(commit.timestamp.isUtc, true);
    expect(commit.timestamp.toIso8601String(),
        DateTime.parse("2020-01-03T03:12:54Z").toIso8601String());

    commit = commits.last;
    expect(commit.sha, "23456");
    expect(commit.message, "another test commit");
    expect(commit.author, "you");
    expect(commit.timestamp.isUtc, true);
    expect(commit.timestamp.toIso8601String(),
        DateTime.parse("2020-01-04T03:12:54Z").toIso8601String());
  });

  test('test convert negative test', () async {
    try {
      List<Commit> commits = converter.convert(null);
    } catch (e) {
      expect(e is CommitHistoryConversionError, true);
    }

    try {
      List<Commit> commits = converter.convert("{}");
    } catch (e) {
      expect(e is CommitHistoryConversionError, true);
    }

    try {
      List<Commit> commits =
          converter.convert(reader.data('commit_history_single_invalid.json'));
    } catch (e) {
      expect(e is CommitHistoryConversionError, true);
    }
  });
}
