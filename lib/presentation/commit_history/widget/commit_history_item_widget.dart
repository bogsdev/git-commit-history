import 'package:flutter/material.dart';
import 'package:git_commit_history/core/loader/factory.dart';
import 'package:git_commit_history/domain/entities/commit.dart';
import 'package:git_commit_history/presentation/navigation/navigation.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommitHistoryItemWidget extends StatelessWidget {
  final Commit commit;

  CommitHistoryItemWidget(this.commit);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Factory.get<Navigation>()
              .navigateTo('/commit_details', arg: commit),
          child: Container(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          color: Theme.of(context).primaryColor,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 10.0),
                            child: Row(
                              children: <Widget>[
                                Container(
                                    child: Text(
                                  timeago.format(commit.timestamp),
                                  style: Theme.of(context).textTheme.caption,
                                )),
                                Expanded(
                                  child: Container(),
                                ),
                                Container(
                                  child: Container(
                                      child: Text(
                                    commit.sha.substring(0, 8),
                                    style: Theme.of(context).textTheme.caption,
                                  )),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 10.0),
                          child: Column(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                    child: Text(
                                  commit.message,
                                  style: Theme.of(context).textTheme.title,
                                )),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                    padding:
                                        EdgeInsets.only(top: 4.0, bottom: 10.0),
                                    child: Text(
                                      commit.author,
                                      style:
                                          Theme.of(context).textTheme.subtitle,
                                    )),
                              ),
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
      ),
    );
  }
}
