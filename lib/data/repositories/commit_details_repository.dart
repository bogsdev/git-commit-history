import 'dart:async';
import 'package:flutter/material.dart';
import 'package:git_commit_history/domain/converters/commit_details/commit_details_converter.dart';
import 'package:git_commit_history/domain/entities/commit_details.dart';
import 'package:git_commit_history/domain/errors/commit_details/commit_details_errors.dart';
import 'package:git_commit_history/domain/repositories/commit_details_repository.dart';
import 'package:git_commit_history/domain/errors/commit_details/commit_details_conversion_errors.dart';

import '../../core/errors/connection_errors/connection_errors.dart';
import '../../utils/connection.dart';
import '../client/git_client.dart';

import 'package:http/http.dart';

class CommitDetailsRepositoryImpl extends CommitDetailsRepository {
  final NetworkConnection networkConnection;
  final GitClient client;
  final CommitDetailsConverter converter;

  CommitDetailsRepositoryImpl(
      {@required this.networkConnection,
      @required this.client,
      @required this.converter});

  /// returns details of a commit
  /// This function throws the following
  /// [NoInternetConnectionError],
  /// [CommitHistoryConversionError],
  /// [CommitHistoryTimeoutError],
  /// [CommitHistoryAuthenticationError] and
  /// [CommitHistoryUnknownError]
  @override
  Future<CommitDetails> get(String sha) async {
    try {
      bool connected = await networkConnection.isConnected;
      if (!connected) throw NoInternetConnectionError();
      Response response = await client.getCommit(sha);
      if (response.statusCode == SUCCESS_STATUS_CODE) {
        return converter.convert(response.body);
      } else if (response.statusCode == NOT_FOUND_STATUS_CODE ||
          response.statusCode == FORBIDDEN_STATUS_CODE) {
        //according to GIT api specs, both pertains to un-authorized access
        throw CommitDetailsAuthenticationError();
      } else {
        throw CommitDetailsFailed();
      }
    } on NoInternetConnectionError catch (e) {
      //TODO: Custom handling
      throw e;
    } on TimeoutException catch (e) {
      //TODO: Custom handling
      throw CommitDetailsTimeoutError();
    } on CommitDetailsConversionError catch (e) {
      //TODO: Custom handling
      throw e;
    } on CommitDetailsAuthenticationError catch (e) {
      //TODO: Custom handling
      throw e;
    } on CommitDetailsFailed catch (e) {
      //TODO: Custom handling
      throw e;
    } catch (e, s) {
      //TODO: Custom handling
      throw CommitDetailsUnknownError(exception: e, stackTrace: s);
    }
  }
}
