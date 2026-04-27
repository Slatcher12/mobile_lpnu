abstract class ConnectivityService {
  Future<bool> hasConnection();
  Stream<bool> get statusStream;
}
