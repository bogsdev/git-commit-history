import 'dart:async';

import 'package:flutter/material.dart';
import 'package:git_commit_history/data/client/git_client.dart';
import 'package:git_commit_history/domain/converters/commit_history/commit_history_converter.dart';
import 'package:git_commit_history/domain/entities/commit.dart';
import 'package:git_commit_history/domain/errors/commit_history/commit_history_errors.dart';
import 'package:git_commit_history/core/errors/connection_errors/connection_errors.dart';
import 'package:git_commit_history/domain/repositories/commit_history_repository.dart';
import 'package:git_commit_history/utils/connection.dart';
import 'package:git_commit_history/domain/errors/commit_history/commit_history_conversion_errors.dart';
import 'package:http/http.dart';

class CommitHistoryRepositoryImpl extends CommitHistoryRepository {
  final NetworkConnection networkConnection;
  final GitClient client;
  final CommitHistoryConvert converter;

  CommitHistoryRepositoryImpl(
      {@required this.networkConnection,
      @required this.client,
      @required this.converter});

  /// returns list of all [Commit]
  /// This function throws the following
  /// [NoInternetConnectionError],
  /// [CommitHistoryConversionError],
  /// [CommitHistoryTimeoutError],
  /// [CommitHistoryAuthenticationError],
  /// [CommitHistoryFailed],
  /// [CommitHistoryUnknownError]
  Future<List<Commit>> all() async {
    try {
      bool connected = await networkConnection.isConnected;
      if (!connected) throw NoInternetConnectionError();
      Response response = await client.getCommits();
      if (response.statusCode == SUCCESS_STATUS_CODE) {
        return converter.convert(response.body);
      } else if (response.statusCode == NOT_FOUND_STATUS_CODE ||
          response.statusCode == FORBIDDEN_STATUS_CODE) {
        //according to GIT api specs, both pertains to un-authorized access
        throw CommitHistoryAuthenticationError();
      } else {
        throw CommitHistoryFailed();
      }
    } on NoInternetConnectionError catch (e) {
      //TODO: Custom handling
      throw e;
    } on TimeoutException catch (e) {
      //TODO: Custom handling
      throw CommitHistoryTimeoutError();
    } on CommitHistoryConversionError catch (e) {
      //TODO: Custom handling
      throw e;
    } on CommitHistoryAuthenticationError catch (e) {
      //TODO: Custom handling
      throw e;
    } on CommitHistoryFailed catch (e) {
      //TODO: Custom handling
      throw e;
    } catch (e, s) {
      //TODO: Custom handling
      throw CommitHistoryUnknownError(exception: e, stackTrace: s);
    }
  }
}
