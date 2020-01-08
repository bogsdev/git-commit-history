import 'package:flutter/material.dart';
import 'package:git_commit_history/core/loader/factory.dart';
import 'package:git_commit_history/core/loader/factory.dart';
import 'package:git_commit_history/core/loader/factory.dart';

import 'package:git_commit_history/domain/entities/commit_details.dart';
import 'package:git_commit_history/presentation/commit_details/messages/commit_details_labels.dart';

class CommitDetailsFileWidget extends StatelessWidget {
  final CommitFile commitFile;

  CommitDetailsFileWidget(this.commitFile);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        child: IntrinsicHeight(
          child: Row(
            children: <Widget>[
              Container(
                width: 4.0,
                color: Theme.of(context).primaryColor.withOpacity(0.6),
              ),
              Expanded(
                child: Container(
                  color: Colors.grey.shade100,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        child: Column(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                  child: Text(
                                commitFile.fileName,
                                style: Theme.of(context).textTheme.title,
                              )),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                  padding:
                                      EdgeInsets.only(top: 4.0, bottom: 10.0),
                                  child: Text(
                                    commitFile.status,
                                    style: Theme.of(context).textTheme.subtitle,
                                  )),
                            ),
                            Container(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                    padding:
                                        EdgeInsets.only(top: 4.0, bottom: 2.0),
                                    child: Text(
                                      Factory.get<CommitDetailsLabels>()
                                          .linesChanged,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle
                                          .copyWith(
                                              fontWeight: FontWeight.normal),
                                    )),
                              ),
                            ),
                            Container(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                    child: Text(
                                  '${commitFile.changes}',
                                  style: Theme.of(context).textTheme.subtitle,
                                )),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
