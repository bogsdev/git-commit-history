import 'package:flutter/material.dart';
import 'package:git_commit_history/domain/entities/commit_details.dart';
import 'package:git_commit_history/domain/repositories/commit_details_repository.dart';
import 'package:git_commit_history/presentation/commit_details/messages/commit_details_ui_errors.dart';
import 'package:git_commit_history/presentation/data_interface/data_loader.dart';
import 'package:git_commit_history/core/errors/connection_errors/connection_errors.dart';
import 'package:git_commit_history/domain/errors/commit_details/commit_details_errors.dart';
import 'package:git_commit_history/domain/errors/commit_details/commit_details_conversion_errors.dart';

class CommitDetailsLoaderResult {
  CommitDetails commitDetails;
  String errorMessage;

  CommitDetailsLoaderResult({this.commitDetails, this.errorMessage});

  bool get success => errorMessage == null;
}

class CommitDetailsLoader
    extends DataLoaderWithParam<CommitDetailsLoaderResult, String> {
  final CommitDetailsRepository repository;
  final CommitDetailsErrorMessages messages;

  CommitDetailsLoader({@required this.repository, @required this.messages});

  @override
  Future<CommitDetailsLoaderResult> load(String sha) async {
    String errorMessage;
    try {
      CommitDetails commitDetails = await repository.get(sha);
      return CommitDetailsLoaderResult(commitDetails: commitDetails);
    } on NoInternetConnectionError catch (e) {
      errorMessage = messages.noInternetConnection;
    } on CommitDetailsTimeoutError catch (e) {
      errorMessage = messages.timeOut;
    } on CommitDetailsConversionError catch (e) {
      errorMessage = messages.fetchFailed;
    } on CommitDetailsAuthenticationError catch (e) {
      errorMessage = messages.fetchFailed;
    } on CommitDetailsFailed catch (e) {
      errorMessage = messages.fetchFailed;
    } on CommitDetailsUnknownError catch (e) {
      //TODO: Add further handling
      errorMessage = messages.fetchFailed;
    }
    return CommitDetailsLoaderResult(errorMessage: errorMessage);
  }
}
