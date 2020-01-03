import 'package:flutter/material.dart';

class Commit {
  final String message;
  final String author;
  final String sha;
  final DateTime timestamp;

  Commit(
      {@required this.message,
      @required this.author,
      @required this.sha,
      @required this.timestamp});
}
