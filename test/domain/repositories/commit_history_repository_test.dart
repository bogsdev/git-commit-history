import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:git_commit_history/core/errors/connection_errors/connection_errors.dart';
import 'package:git_commit_history/data/client/git_client.dart';
import 'package:git_commit_history/data/client/git_client_service.dart';
import 'package:git_commit_history/data/converters/commit_history/commit_history_converter.dart';
import 'package:git_commit_history/data/repositories/commit_history_repository.dart';
import 'package:git_commit_history/domain/entities/commit.dart';
import 'package:git_commit_history/domain/errors/commit_history/commit_history_errors.dart';
import 'package:git_commit_history/domain/repositories/commit_history_repository.dart';
import 'package:git_commit_history/utils/connection.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../data/reader.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

class MockConnectivity extends Mock implements Connectivity {}

class MockGitClient extends Mock implements GitClientService {}

main() {
  Reader reader = Reader();
  DataConnectionChecker mockDataConnectionChecker = MockDataConnectionChecker();
  Connectivity mockConnectivity = MockConnectivity();
  GitClientService gitClient = MockGitClient();
  NetworkConnection networkConnection = InternetConnectionUtils(
      connectionChecker: mockDataConnectionChecker,
      connectivity: mockConnectivity);
  CommitHistoryRepository commitHistoryRepository = CommitHistoryRepositoryImpl(
      networkConnection: networkConnection,
      service: gitClient,
      converter: CommitHistoryConvertImpl());

  test('test get all commits happy path', () async {
    when(mockConnectivity.checkConnectivity())
        .thenAnswer((_) async => ConnectivityResult.mobile);
    when(mockDataConnectionChecker.hasConnection).thenAnswer((_) async => true);
    String data = "[]";
    when(gitClient.getCommits()).thenAnswer(
        (_) => Future.value(Response(http.Response(data, 200), data)));
    List<Commit> commits = await commitHistoryRepository.all();
    expect(commits.length, 0);
    data = reader.data('commit_history_single.json');
    when(gitClient.getCommits()).thenAnswer(
        (_) => Future.value(Response(http.Response(data, 200), data)));
    commits = await commitHistoryRepository.all();
    expect(commits.length, 1);
    Commit commit = commits.first;
    expect(commit.sha, "12345");
    expect(commit.message, "test commit");
    expect(commit.author, "me");
    expect(commit.timestamp.isUtc, true);
    expect(commit.timestamp.toIso8601String(),
        DateTime.parse("2020-01-03T03:12:54Z").toIso8601String());
  });

  test('test get all commits negative path - not connected internet', () async {
    when(mockConnectivity.checkConnectivity())
        .thenAnswer((_) async => ConnectivityResult.none);
    when(mockDataConnectionChecker.hasConnection).thenAnswer((_) async => true);
    when(gitClient.getCommits()).thenAnswer(
        (_) => Future.value(Response(http.Response("[]", 200), '[]')));
    var exception;
    try {
      List<Commit> commits = await commitHistoryRepository.all();
    } catch (e) {
      exception = e;
    }
    expect(exception is NoInternetConnectionError, true);
  });

  test('test get all commits negative path - not stable internet', () async {
    when(mockConnectivity.checkConnectivity())
        .thenAnswer((_) async => ConnectivityResult.mobile);
    when(mockDataConnectionChecker.hasConnection)
        .thenAnswer((_) async => false);
    when(gitClient.getCommits()).thenAnswer(
        (_) => Future.value(Response(http.Response("[]", 200), '[]')));
    var exception;
    try {
      List<Commit> commits = await commitHistoryRepository.all();
    } catch (e) {
      exception = e;
    }
    expect(exception is NoInternetConnectionError, true);
  });

  test('test get all commits negative path - timeout', () async {
    when(mockConnectivity.checkConnectivity())
        .thenAnswer((_) async => ConnectivityResult.mobile);
    when(mockDataConnectionChecker.hasConnection).thenAnswer((_) async => true);
    when(gitClient.getCommits()).thenThrow(TimeoutException('timeout'));
    var exception;
    try {
      List<Commit> commits = await commitHistoryRepository.all();
    } catch (e) {
      exception = e;
    }
    expect(exception is CommitHistoryTimeoutError, true);
  });

  test('test get all commits negative path - git returned 404', () async {
    when(mockConnectivity.checkConnectivity())
        .thenAnswer((_) async => ConnectivityResult.mobile);
    when(mockDataConnectionChecker.hasConnection).thenAnswer((_) async => true);
    when(gitClient.getCommits()).thenAnswer(
        (_) => Future.value(Response(http.Response("[]", 404), '[]')));
    var exception;
    try {
      List<Commit> commits = await commitHistoryRepository.all();
    } catch (e) {
      exception = e;
    }
    expect(exception is CommitHistoryAuthenticationError, true);
  });

  test('test get all commits negative path - git returned 403', () async {
    when(mockConnectivity.checkConnectivity())
        .thenAnswer((_) async => ConnectivityResult.mobile);
    when(mockDataConnectionChecker.hasConnection).thenAnswer((_) async => true);
    when(gitClient.getCommits()).thenAnswer(
        (_) => Future.value(Response(http.Response("[]", 403), '[]')));
    var exception;
    try {
      List<Commit> commits = await commitHistoryRepository.all();
    } catch (e) {
      exception = e;
    }
    expect(exception is CommitHistoryAuthenticationError, true);
  });

  test('test get all commits negative path - git returned 500', () async {
    when(mockConnectivity.checkConnectivity())
        .thenAnswer((_) async => ConnectivityResult.mobile);
    when(mockDataConnectionChecker.hasConnection).thenAnswer((_) async => true);
    when(gitClient.getCommits()).thenAnswer(
        (_) => Future.value(Response(http.Response("[]", 500), '[]')));
    var exception;
    try {
      List<Commit> commits = await commitHistoryRepository.all();
    } catch (e) {
      exception = e;
    }
    expect(exception is CommitHistoryFailed, true);
  });

  test('test get all commits negative path - some unknown exception', () async {
    when(mockConnectivity.checkConnectivity())
        .thenAnswer((_) async => ConnectivityResult.mobile);
    when(mockDataConnectionChecker.hasConnection).thenAnswer((_) async => true);
    when(gitClient.getCommits()).thenThrow(Exception('Unkown Exception'));
    var exception;
    try {
      List<Commit> commits = await commitHistoryRepository.all();
    } catch (e) {
      exception = e;
    }
    expect(exception is CommitHistoryUnknownError, true);
  });
}
