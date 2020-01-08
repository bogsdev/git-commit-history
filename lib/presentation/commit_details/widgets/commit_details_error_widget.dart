import 'package:flutter/material.dart';

class CommitDetailsErrorWidget extends StatelessWidget {
  final String errorMessage;

  CommitDetailsErrorWidget(this.errorMessage);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Container(
          height: 150.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 40.0,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Text(errorMessage, textAlign: TextAlign.center),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
