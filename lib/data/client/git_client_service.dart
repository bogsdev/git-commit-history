import 'package:chopper/chopper.dart';

import 'git_connection_info.dart';

part "git_client_service.chopper.dart";


@ChopperApi(baseUrl: "/commits")
abstract class GitClientService extends ChopperService {

  static GitClientService create(GitConnectionInfo connectionInfo) {
    final client = ChopperClient(
      baseUrl: connectionInfo.myRepositoryPath,
      services: [
        _$GitClientService(),
      ],
      interceptors: [
        HeadersInterceptor(
          {
          "Content-Type": "application/json; charset=utf-8",
            'Authorization': 'token ${connectionInfo.myToken}'
          }
        )
      ]
    );
    return _$GitClientService(client);
  }

  @Get()
  Future<Response> getCommits();

  @Get(path: "/{sha}")
  Future<Response> getCommit(@Path() String sha);
}
