import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:git_commit_history/presentation/commit_details/widgets/commit_details_body_widget.dart';

import '../home.dart';

class NavigationRoutes {
  Route<dynamic> routes(RouteSettings settings) {
    var arg = settings.arguments;
    switch (settings.name) {
      case '/':
        return CupertinoPageRoute(builder: (_) => HomePage());
      case '/commit_details':
        return CupertinoPageRoute(builder: (_) => CommitDetailsPage(arg));
      default:
        return CupertinoPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('Page not found: ${settings.name}'),
                  ),
                ));
    }
  }
}
