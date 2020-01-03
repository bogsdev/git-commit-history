import 'package:flutter/material.dart';
import 'package:git_commit_history/core/loader/factory.dart';
import 'package:git_commit_history/presentation/commit_history/messages/commit_history_labels.dart';

class CommitHistoryLoadingWidget extends StatelessWidget {
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
                child: Text(Factory.get<CommitHistoryLabels>().loading),
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
