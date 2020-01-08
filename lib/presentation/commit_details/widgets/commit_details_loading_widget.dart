import 'package:flutter/material.dart';
import 'package:git_commit_history/core/loader/factory.dart';
import 'package:git_commit_history/presentation/commit_details/messages/commit_details_labels.dart';
import 'package:git_commit_history/presentation/commit_history/messages/commit_history_labels.dart';

class CommitDetailsLoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Container(
          height: 150.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Text(Factory.get<CommitDetailsLabels>().loadingDetails),
              ),
              Container(
                padding: EdgeInsets.only(top: 10.0),
                height: 50.0,
                child: CircularProgressIndicator(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
