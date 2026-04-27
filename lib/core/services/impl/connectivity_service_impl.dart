import 'package:connectivity_plus/connectivity_plus.dart';

import '../connectivity_service.dart';

class ConnectivityServiceImpl implements ConnectivityService {
  final _connectivity = Connectivity();

  @override
  Future<bool> hasConnection() async {
    final results = await _connectivity.checkConnectivity();
    return results.any((r) => r != ConnectivityResult.none);
  }

  @override
  Stream<bool> get statusStream => _connectivity.onConnectivityChanged.map(
    (results) => results.any((r) => r != ConnectivityResult.none),
  );
}
