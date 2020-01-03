import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Commit extends Equatable{
  final String message;
  final String author;
  final String sha;
  final DateTime timestamp;

  Commit(
      {@required this.message,
      @required this.author,
      @required this.sha,
      @required this.timestamp});

  @override
  List<Object> get props => [sha];
}
