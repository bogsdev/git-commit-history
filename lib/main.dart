import 'package:flutter/material.dart';
import 'package:git_commit_history/presentation/home.dart';

import 'core/environments/environments.dart';
import 'core/environments/not_safe_token_reader.dart';
import 'core/loader/factory_helper.dart';

void main() async{
  //Define environment
  var environmentInfo = await loadEnvironmentInfo();
  await initializeFactory(environmentInfo);
  runApp(MyApp());
}

Future<EnvironmentInfo> loadEnvironmentInfo() async{
  WidgetsFlutterBinding.ensureInitialized();
  //GIT read only public access token work around
  NotSafeTokenReader reader = NotSafeTokenReader();
  String myToken = await reader.read();
  //Define environment
  return  EnvironmentInfo(
      env: Environments.dev,
      repository: my_repository,
      user: my_user,
      token: myToken
  );
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Git Commit History',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          title: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
              color: Colors.black87
          ),
          subtitle: TextStyle(
            fontSize: 13.0,
            fontWeight: FontWeight.bold,
              color: Colors.black54
          ),
          subhead: TextStyle(
            fontSize: 12.0,
            color: Colors.black54
          ),
          caption: TextStyle(
              fontSize: 12.0,
              color: Colors.white,
              fontWeight: FontWeight.bold
          )
        )
      ),
      home: HomePage(),
    );
  }
}


