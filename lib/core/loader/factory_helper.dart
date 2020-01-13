import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:git_commit_history/core/encryption/encryption_util.dart';
import 'package:git_commit_history/core/environments/environments.dart';
import 'package:git_commit_history/core/reader/asset_reader.dart';
import 'package:git_commit_history/data/client/git_client.dart';
import 'package:git_commit_history/data/client/git_client_service.dart';
import 'package:git_commit_history/data/client/git_connection_info.dart';
import 'package:git_commit_history/data/converters/commit_details/commit_details_converter.dart';
import 'package:git_commit_history/data/converters/commit_history/commit_history_converter.dart';
import 'package:git_commit_history/data/repositories/commit_details_repository.dart';
import 'package:git_commit_history/data/repositories/commit_history_repository.dart';
import 'package:git_commit_history/domain/converters/commit_details/commit_details_converter.dart';
import 'package:git_commit_history/domain/converters/commit_history/commit_history_converter.dart';
import 'package:git_commit_history/domain/repositories/commit_details_repository.dart';
import 'package:git_commit_history/domain/repositories/commit_history_repository.dart';
import 'package:git_commit_history/presentation/commit_details/bloc/commit_details_bloc.dart';
import 'package:git_commit_history/presentation/commit_details/data_interface/commit_details_loader.dart';
import 'package:git_commit_history/presentation/commit_details/messages/commit_details_labels.dart';
import 'package:git_commit_history/presentation/commit_details/messages/commit_details_ui_errors.dart';
import 'package:git_commit_history/presentation/commit_history/bloc/commit_history_bloc.dart';
import 'package:git_commit_history/presentation/commit_history/data_interface/commit_history_loader.dart';
import 'package:git_commit_history/presentation/commit_history/messages/commit_history_labels.dart';
import 'package:git_commit_history/presentation/commit_history/messages/commit_history_ui_errors.dart';
import 'package:git_commit_history/presentation/errors/ui_error_messages.dart';
import 'package:git_commit_history/presentation/navigation/navigation.dart';
import 'package:git_commit_history/presentation/navigation/navigation_routes.dart';
import 'package:git_commit_history/presentation/transformers/date_transformer.dart';
import 'package:git_commit_history/utils/connection.dart';
import 'package:http/http.dart' as http;
import 'factory.dart';

Future<void> initializeFactory(EnvironmentInfo env) async {
  var i = Factory.i;

  i.registerLazySingleton<EnvironmentInfo>(() => env);
  i.registerLazySingleton<Navigation>(() => Navigation());
  i.registerLazySingleton<NavigationRoutes>(() => NavigationRoutes());
  i.registerLazySingleton<GitConnectionInfo>(() => GitConnectionInfo(i()));
  i.registerLazySingleton<MyGitClientHeaders>(() => MyGitClientHeaders(i()));
  i.registerLazySingleton<CommitHistoryLabels>(() => CommitHistoryLabels());
  i.registerLazySingleton<CommitDetailsLabels>(() => CommitDetailsLabels());
  i.registerLazySingleton<NotSoSafeDecryptionUtil>(
      () => NotSoSafeDecryptionUtil());
  i.registerLazySingleton<AssetReader>(() => AssetReader());
  i.registerLazySingleton(() => http.Client());
  i.registerLazySingleton<CommitHistoryConvert>(
      () => CommitHistoryConvertImpl());
  i.registerLazySingleton<CommitDetailsConverter>(
      () => CommitDetailsConverterImpl());
  i.registerLazySingleton<UIErrorMessages>(() => UIErrorMessages());
  i.registerLazySingleton<CommitHistoryErrorMessages>(
      () => CommitHistoryErrorMessages());
  i.registerLazySingleton<CommitDetailsErrorMessages>(
      () => CommitDetailsErrorMessages());
  i.registerLazySingleton<CommitHistoryLoader>(
      () => CommitHistoryLoader(messages: i(), repository: i()));
  i.registerLazySingleton<CommitDetailsLoader>(
      () => CommitDetailsLoader(messages: i(), repository: i()));
  i.registerLazySingleton<Connectivity>(() => Connectivity());
  i.registerLazySingleton<DataConnectionChecker>(() => DataConnectionChecker());
  i.registerLazySingleton<NetworkConnection>(
      () => InternetConnectionUtils(connectivity: i(), connectionChecker: i()));
  i.registerLazySingleton<GitClient>(
      () => GitClient(connectionInfo: i(), client: i(), header: i()));
  i.registerLazySingleton<GitClientService>(
          () => GitClientService.create(i()));
  i.registerLazySingleton<CommitHistoryRepository>(() =>
      CommitHistoryRepositoryImpl(
          service: i(), converter: i(), networkConnection: i()));
  i.registerLazySingleton<CommitDetailsRepository>(() =>
      CommitDetailsRepositoryImpl(
          service: i(), converter: i(), networkConnection: i()));
  i.registerFactory<CommitHistoryBloc>(
      () => CommitHistoryBloc(uiErrorMessages: i(), loader: i()));
  i.registerFactory<CommitDetailsBloc>(
      () => CommitDetailsBloc(uiErrorMessages: i(), loader: i()));
  i.registerLazySingleton<DateTransformer>(() => DateTransformer());
}
