import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:git_commit_history/core/errors/connection_errors/connection_errors.dart';
import 'package:git_commit_history/data/client/git_client.dart';
import 'package:git_commit_history/data/converters/commit_details/commit_details_converter.dart';
import 'package:git_commit_history/data/converters/commit_history/commit_history_converter.dart';
import 'package:git_commit_history/data/repositories/commit_details_repository.dart';
import 'package:git_commit_history/data/repositories/commit_history_repository.dart';
import 'package:git_commit_history/domain/converters/commit_details/commit_details_converter.dart';
import 'package:git_commit_history/domain/entities/commit.dart';
import 'package:git_commit_history/domain/entities/commit_details.dart';
import 'package:git_commit_history/domain/errors/commit_details/commit_details_errors.dart';
import 'package:git_commit_history/domain/errors/commit_history/commit_history_errors.dart';
import 'package:git_commit_history/domain/repositories/commit_details_repository.dart';
import 'package:git_commit_history/domain/repositories/commit_history_repository.dart';
import 'package:git_commit_history/utils/connection.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';

import '../../data/reader.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

class MockConnectivity extends Mock implements Connectivity {}

class MockGitClient extends Mock implements GitClient {}

main() {
  Reader reader = Reader();
  DataConnectionChecker mockDataConnectionChecker = MockDataConnectionChecker();
  Connectivity mockConnectivity = MockConnectivity();
  GitClient gitClient = MockGitClient();
  NetworkConnection networkConnection = InternetConnectionUtils(
      connectionChecker: mockDataConnectionChecker,
      connectivity: mockConnectivity);
  CommitDetailsRepository commitDetailsRepository = CommitDetailsRepositoryImpl(
      networkConnection: networkConnection,
      client: gitClient,
      converter: CommitDetailsConverterImpl());

  String input = 'sha';

  test('test commit details happy path', () async {
    when(mockConnectivity.checkConnectivity())
        .thenAnswer((_) async => ConnectivityResult.mobile);
    when(mockDataConnectionChecker.hasConnection).thenAnswer((_) async => true);
    when(gitClient.getCommit(input)).thenAnswer((_) => Future.value(Response(
        reader.data('commit_details/commit_details_single.json'), 200)));
    CommitDetails commitDetails = await commitDetailsRepository.get(input);
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

  test('test commit details negative path - not connected internet', () async {
    when(mockConnectivity.checkConnectivity())
        .thenAnswer((_) async => ConnectivityResult.none);
    when(mockDataConnectionChecker.hasConnection).thenAnswer((_) async => true);
    when(gitClient.getCommit(input))
        .thenAnswer((_) => Future.value(Response("{}", 200)));
    var exception;
    try {
      CommitDetails commitDetails = await commitDetailsRepository.get(input);
    } catch (e) {
      exception = e;
    }
    expect(exception is NoInternetConnectionError, true);
  });

  test('test commit details negative path - not stable internet', () async {
    when(mockConnectivity.checkConnectivity())
        .thenAnswer((_) async => ConnectivityResult.mobile);
    when(mockDataConnectionChecker.hasConnection)
        .thenAnswer((_) async => false);
    when(gitClient.getCommit(input))
        .thenAnswer((_) => Future.value(Response("{}", 200)));
    var exception;
    try {
      CommitDetails commitDetails = await commitDetailsRepository.get(input);
    } catch (e) {
      exception = e;
    }
    expect(exception is NoInternetConnectionError, true);
  });

  test('test get commit details negative path - timeout', () async {
    when(mockConnectivity.checkConnectivity())
        .thenAnswer((_) async => ConnectivityResult.mobile);
    when(mockDataConnectionChecker.hasConnection).thenAnswer((_) async => true);
    when(gitClient.getCommit(input)).thenThrow(TimeoutException('timeout'));
    var exception;
    try {
      CommitDetails commitDetails = await commitDetailsRepository.get(input);
    } catch (e) {
      exception = e;
    }
    expect(exception is CommitDetailsTimeoutError, true);
  });

  test('test get commit details negative path - git returned 404', () async {
    when(mockConnectivity.checkConnectivity())
        .thenAnswer((_) async => ConnectivityResult.mobile);
    when(mockDataConnectionChecker.hasConnection).thenAnswer((_) async => true);
    when(gitClient.getCommit(input))
        .thenAnswer((_) => Future.value(Response("{}", 404)));
    var exception;
    try {
      CommitDetails commitDetails = await commitDetailsRepository.get(input);
    } catch (e) {
      exception = e;
    }
    expect(exception is CommitDetailsAuthenticationError, true);
  });

  test('test get commit details negative path - git returned 403', () async {
    when(mockConnectivity.checkConnectivity())
        .thenAnswer((_) async => ConnectivityResult.mobile);
    when(mockDataConnectionChecker.hasConnection).thenAnswer((_) async => true);
    when(gitClient.getCommit(input))
        .thenAnswer((_) => Future.value(Response("{}", 403)));
    var exception;
    try {
      CommitDetails commitDetails = await commitDetailsRepository.get(input);
    } catch (e) {
      exception = e;
    }
    expect(exception is CommitDetailsAuthenticationError, true);
  });

  test('test get commit details negative path - git returned 500', () async {
    when(mockConnectivity.checkConnectivity())
        .thenAnswer((_) async => ConnectivityResult.mobile);
    when(mockDataConnectionChecker.hasConnection).thenAnswer((_) async => true);
    when(gitClient.getCommit(input))
        .thenAnswer((_) => Future.value(Response("{}", 500)));
    var exception;
    try {
      CommitDetails commitDetails = await commitDetailsRepository.get(input);
    } catch (e) {
      exception = e;
    }
    expect(exception is CommitDetailsFailed, true);
  });

  test('test get commit details negative path - some unknown exception',
      () async {
    when(mockConnectivity.checkConnectivity())
        .thenAnswer((_) async => ConnectivityResult.mobile);
    when(mockDataConnectionChecker.hasConnection).thenAnswer((_) async => true);
    when(gitClient.getCommit(input)).thenThrow(Exception('Unkown Exception'));
    var exception;
    try {
      CommitDetails commitDetails = await commitDetailsRepository.get(input);
    } catch (e) {
      exception = e;
    }
    expect(exception is CommitDetailsUnknownError, true);
  });
}
