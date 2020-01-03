import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:git_commit_history/core/encryption/encryption_util.dart';
import 'package:git_commit_history/core/environments/environments.dart';
import 'package:git_commit_history/core/reader/asset_reader.dart';
import 'package:git_commit_history/data/client/git_client.dart';
import 'package:git_commit_history/data/client/git_connection_info.dart';
import 'package:git_commit_history/data/converters/commit_history/commit_history_converter.dart';
import 'package:git_commit_history/data/repositories/commit_history_repository.dart';
import 'package:git_commit_history/domain/converters/commit_history/commit_history_converter.dart';
import 'package:git_commit_history/domain/repositories/commit_history_repository.dart';
import 'package:git_commit_history/presentation/commit_history/bloc/commit_history_bloc.dart';
import 'package:git_commit_history/presentation/commit_history/data_interface/commit_history_loader.dart';
import 'package:git_commit_history/presentation/commit_history/messages/commit_history_labels.dart';
import 'package:git_commit_history/presentation/commit_history/messages/commit_history_ui_errors.dart';
import 'package:git_commit_history/presentation/errors/ui_error_messages.dart';
import 'package:git_commit_history/utils/connection.dart';
import 'package:http/http.dart' as http;
import 'factory.dart';

Future<void> initializeFactory(EnvironmentInfo env) async {
  var i = Factory.i;

  i.registerLazySingleton<EnvironmentInfo>(() => env);
  i.registerLazySingleton<GitConnectionInfo>(() => GitConnectionInfo(i()));
  i.registerLazySingleton<MyGitClientHeaders>(() => MyGitClientHeaders(i()));
  i.registerLazySingleton<CommitHistoryLabels>(() => CommitHistoryLabels());
  i.registerLazySingleton<NotSoSafeDecryptionUtil>(() => NotSoSafeDecryptionUtil());
  i.registerLazySingleton<AssetReader>(() => AssetReader());
  i.registerLazySingleton(() => http.Client());
  i.registerLazySingleton<CommitHistoryConvert>(() =>
      CommitHistoryConvertImpl());
  i.registerLazySingleton<UIErrorMessages>(() =>
      UIErrorMessages());
  i.registerLazySingleton<CommitHistoryErrorMessages>(() =>
      CommitHistoryErrorMessages());
  i.registerLazySingleton<CommitHistoryLoader>(() =>
      CommitHistoryLoader(
          messages: i(),
          repository: i()
      ));
  i.registerLazySingleton<Connectivity>(() => Connectivity());
  i.registerLazySingleton<DataConnectionChecker>(() => DataConnectionChecker());
  i.registerLazySingleton<NetworkConnection>(() =>
      InternetConnectionUtils(
          connectivity: i(),
          connectionChecker: i()
      ));
  i.registerLazySingleton<GitClient>(
          () => GitClient(connectionInfo: i(), client: i(), header: i()));
  i.registerLazySingleton<CommitHistoryRepository>(
          () =>
          CommitHistoryRepositoryImpl(
              client: i(),
              converter: i(),
              networkConnection: i()
          ));
  i.registerFactory(()=>CommitHistoryBloc(
    uiErrorMessages: i(),
    loader: i()
  ));
}
