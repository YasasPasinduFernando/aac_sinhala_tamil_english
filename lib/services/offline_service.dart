import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class OfflineService {
  static final OfflineService _instance = OfflineService._internal();
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool _isOnline = true;

  factory OfflineService() {
    return _instance;
  }

  OfflineService._internal();

  bool get isOnline => _isOnline;
  bool get isOffline => !_isOnline;

  Future<void> initialize() async {
    // Check initial connectivity
    final result = await _connectivity.checkConnectivity();
    _isOnline = result != ConnectivityResult.none;

    // Listen to connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (ConnectivityResult result) {
        _isOnline = result != ConnectivityResult.none;
      },
    );
  }

  void dispose() {
    _connectivitySubscription.cancel();
  }

  /// Check if device is currently online
  Future<bool> checkConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    _isOnline = result != ConnectivityResult.none;
    return _isOnline;
  }

  /// Get connectivity status as a stream for real-time updates
  Stream<bool> getConnectivityStream() {
    return _connectivity.onConnectivityChanged.map(
      (result) => result != ConnectivityResult.none,
    );
  }
}
