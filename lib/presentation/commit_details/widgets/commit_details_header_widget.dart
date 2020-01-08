import 'package:flutter/material.dart';
import 'package:git_commit_history/domain/entities/commit.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommitDetailsHeaderWidget extends StatelessWidget {
  final Commit commit;

  CommitDetailsHeaderWidget(this.commit);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            color: Theme.of(context).primaryColor,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(bottom: 14.0, top: 4.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        commit.sha,
                        style: Theme.of(context).textTheme.caption.copyWith(
                              color: Colors.white70,
                            ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      bottom: 6.0,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        commit.message,
                        style: Theme.of(context)
                            .textTheme
                            .title
                            .copyWith(color: Colors.white, fontSize: 18.0),
                      ),
                    ),
                  ),
                  Container(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        commit.author,
                        style: Theme.of(context).textTheme.subtitle.copyWith(
                            color: Colors.white, fontWeight: FontWeight.normal),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            child: IntrinsicHeight(
              child: Stack(
                children: <Widget>[
                  Container(
                    color: Theme.of(context).primaryColor,
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 5.0),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0))),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          timeago.format(commit.timestamp),
                          style: Theme.of(context).textTheme.subtitle,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
