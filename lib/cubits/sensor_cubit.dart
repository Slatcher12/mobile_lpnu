import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/models/sensor_reading.dart';
import '../core/services/mqtt_service.dart';

class SensorState {
  final Map<String, String> values;
  final bool connected;
  const SensorState({this.values = const {}, this.connected = false});
  SensorState copyWith({Map<String, String>? values, bool? connected}) =>
      SensorState(
        values: values ?? this.values,
        connected: connected ?? this.connected,
      );
}

class SensorCubit extends Cubit<SensorState> {
  final MqttService _service;
  StreamSubscription<SensorReading>? _sub;
  VoidCallback? _connListener;

  SensorCubit(this._service) : super(const SensorState());

  void connect() {
    if (_sub != null) return;
    _connListener = () =>
        emit(state.copyWith(connected: _service.connected.value));
    _service.connected.addListener(_connListener!);
    _sub = _service.readings.listen((r) {
      emit(state.copyWith(values: Map.of(state.values)..[r.topic] = r.value));
    });
    _service.connect();
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    if (_connListener != null) {
      _service.connected.removeListener(_connListener!);
    }
    return super.close();
  }
}
