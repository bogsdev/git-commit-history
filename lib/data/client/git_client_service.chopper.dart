// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'git_client_service.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

class _$GitClientService extends GitClientService {
  _$GitClientService([ChopperClient client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final definitionType = GitClientService;

  @override
  Future<Response> getCommits() {
    final $url = '/commits';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response> getCommit(String sha) {
    final $url = '/commits/$sha';
    final $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }
}
