import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  ConnectivityService([Connectivity? connectivity])
      : _connectivity = connectivity ?? Connectivity() {
    _connectivity.onConnectivityChanged.listen(_onChange);
    unawaited(_init());
  }

  final Connectivity _connectivity;
  final _controller = StreamController<bool>.broadcast();
  bool _isOnline = false;

  bool get isOnline => _isOnline;
  Stream<bool> get onStatusChanged => _controller.stream;

  Future<void> _init() async {
    final result = await _connectivity.checkConnectivity();
    _onChange(result);
  }

  void _onChange(List<ConnectivityResult> result) {
    final online = result.any(
      (r) =>
          r != ConnectivityResult.none &&
          r != ConnectivityResult.bluetooth,
    );
    if (online != _isOnline) {
      _isOnline = online;
      _controller.add(online);
    }
  }

  Future<void> dispose() async {
    await _controller.close();
  }
}
