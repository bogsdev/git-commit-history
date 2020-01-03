import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:git_commit_history/utils/connection.dart';
import 'package:mockito/mockito.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

class MockConnectivity extends Mock implements Connectivity {}

main() {
  test(
      'Test InternetConnectionUtils happy path tests - Not Connected to Wifi/Cellular Network',
      () async {
    DataConnectionChecker mockDataConnectionChecker =
        MockDataConnectionChecker();
    Connectivity mockConnectivity = MockConnectivity();
    InternetConnectionUtils internetConnectionUtils = InternetConnectionUtils(
        connectionChecker: mockDataConnectionChecker,
        connectivity: mockConnectivity);

    when(mockConnectivity.checkConnectivity())
        .thenAnswer((_) async => ConnectivityResult.none);
    bool connected = await internetConnectionUtils.isConnected;
    expect(connected, false);
  });

  test(
      'Test InternetConnectionUtils happy path tests - Connected to Wifi/Cellular Network but not stable',
      () async {
    DataConnectionChecker mockDataConnectionChecker =
        MockDataConnectionChecker();
    Connectivity mockConnectivity = MockConnectivity();
    InternetConnectionUtils internetConnectionUtils = InternetConnectionUtils(
        connectionChecker: mockDataConnectionChecker,
        connectivity: mockConnectivity);

    when(mockConnectivity.checkConnectivity())
        .thenAnswer((_) async => ConnectivityResult.wifi);
    when(mockDataConnectionChecker.hasConnection)
        .thenAnswer((_) async => false);
    bool connected = await internetConnectionUtils.isConnected;
    expect(connected, false);

    when(mockConnectivity.checkConnectivity())
        .thenAnswer((_) async => ConnectivityResult.mobile);
    when(mockDataConnectionChecker.hasConnection)
        .thenAnswer((_) async => false);
    connected = await internetConnectionUtils.isConnected;
    expect(connected, false);
  });

  test(
      'Test InternetConnectionUtils happy path tests - Connected to Wifi/Cellular Network',
      () async {
    DataConnectionChecker mockDataConnectionChecker =
        MockDataConnectionChecker();
    Connectivity mockConnectivity = MockConnectivity();
    InternetConnectionUtils internetConnectionUtils = InternetConnectionUtils(
        connectionChecker: mockDataConnectionChecker,
        connectivity: mockConnectivity);

    when(mockConnectivity.checkConnectivity())
        .thenAnswer((_) async => ConnectivityResult.mobile);
    when(mockDataConnectionChecker.hasConnection).thenAnswer((_) async => true);
    bool connected = await internetConnectionUtils.isConnected;
    expect(connected, true);

    when(mockConnectivity.checkConnectivity())
        .thenAnswer((_) async => ConnectivityResult.mobile);
    when(mockDataConnectionChecker.hasConnection).thenAnswer((_) async => true);
    connected = await internetConnectionUtils.isConnected;
    expect(connected, true);
  });

  test(
      'Test InternetConnectionUtils negative tests - Connectivity throws Exception',
      () async {
    DataConnectionChecker mockDataConnectionChecker =
        MockDataConnectionChecker();
    Connectivity mockConnectivity = MockConnectivity();
    InternetConnectionUtils internetConnectionUtils = InternetConnectionUtils(
        connectionChecker: mockDataConnectionChecker,
        connectivity: mockConnectivity);

    when(mockConnectivity.checkConnectivity())
        .thenThrow(Exception('Random Connection Exception'));

    Exception exception;
    try {
      bool connected = await internetConnectionUtils.isConnected;
    } catch (e) {
      exception = e;
    }
    expect(exception.toString(), 'Exception: Random Connection Exception');
  });

  test(
      'Test InternetConnectionUtils negative tests - DataConnectionChecker throws Exception',
      () async {
    DataConnectionChecker mockDataConnectionChecker =
        MockDataConnectionChecker();
    Connectivity mockConnectivity = MockConnectivity();
    InternetConnectionUtils internetConnectionUtils = InternetConnectionUtils(
        connectionChecker: mockDataConnectionChecker,
        connectivity: mockConnectivity);
    when(mockConnectivity.checkConnectivity())
        .thenAnswer((_) async => ConnectivityResult.mobile);
    when(mockDataConnectionChecker.hasConnection)
        .thenThrow(Exception('Random Data Connection Exception'));
    Exception exception;
    try {
      bool connected = await internetConnectionUtils.isConnected;
    } catch (e) {
      exception = e;
    }
    expect(exception.toString(), 'Exception: Random Data Connection Exception');
  });
}
