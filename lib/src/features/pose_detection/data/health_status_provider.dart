import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../statistics/domain/simulation_event.dart';

enum HealthStatus { normal, warning, emergency, none }

class HealthState {
  final int score;
  final HealthStatus status;
  final String currentActivity; // 'standing', 'walking', 'sitting', 'laying', 'falling'
  final List<SimulationEvent> events;

  HealthState({
    required this.score,
    required this.status,
    required this.currentActivity,
    required this.events,
  });

  factory HealthState.initial() {
    return HealthState(
      score: 1000,
      status: HealthStatus.none,
      currentActivity: 'standing',
      events: [],
    );
  }

  HealthState copyWith({
    int? score,
    HealthStatus? status,
    String? currentActivity,
    List<SimulationEvent>? events,
  }) {
    return HealthState(
      score: score ?? this.score,
      status: status ?? this.status,
      currentActivity: currentActivity ?? this.currentActivity,
      events: events ?? this.events,
    );
  }
}

class HealthStatusNotifier extends StateNotifier<HealthState> {
  Timer? _timer;

  HealthStatusNotifier() : super(HealthState.initial()) {
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.status == HealthStatus.none) return; // Only score if active
      _updateScoreBasedOnActivity();
    });
  }

  void startMonitoring() {
    state = state.copyWith(status: HealthStatus.normal);
  }

  void stopMonitoring() {
    state = state.copyWith(status: HealthStatus.none);
  }

  void updateActivity(String activity) {
    if (state.currentActivity == activity) return;

    final now = DateTime.now();
    final timestamp = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    
    // Create new event
    final newEvent = SimulationEvent(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: activity,
      timestamp: timestamp,
      date: "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}",
      isCritical: activity == 'falling',
    );

    final updatedEvents = [newEvent, ...state.events];

    if (activity == 'falling' || activity == 'near_fall') {
      final penalty = activity == 'falling' ? 600 : 200;
      final newScore = (state.score - penalty).clamp(0, 1000);
      state = state.copyWith(
        score: newScore,
        currentActivity: activity,
        status: _getStatus(newScore),
        events: updatedEvents,
      );
    } else {
      state = state.copyWith(
        currentActivity: activity,
        events: updatedEvents,
        status: state.status == HealthStatus.none ? HealthStatus.normal : state.status,
      );
    }
  }

  void _updateScoreBasedOnActivity() {
    double change = 0;
    
    switch (state.currentActivity) {
      case 'sitting':
        change = -50 / 3600; 
        break;
      case 'slouching':
        change = -150 / 3600; // Worse for posture/spine
        break;
      case 'laying':
        change = -75 / 3600;
        break;
      case 'walking':
        change = 25 / 3600;
        break;
      case 'standing':
        change = 5 / 3600;
        break;
      case 'exercise':
        change = 500 / 3600; // Direct health benefit
        break;
    }

    int newScore = (state.score + change).round().clamp(0, 1000);
    
    if (newScore != state.score) {
      state = state.copyWith(
        score: newScore,
        status: _getStatus(newScore),
      );
    }
  }

  HealthStatus _getStatus(int score) {
    if (score < 500) return HealthStatus.emergency;
    if (score < 800) return HealthStatus.warning;
    return HealthStatus.normal;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final healthStatusProvider = StateNotifierProvider<HealthStatusNotifier, HealthState>((ref) {
  return HealthStatusNotifier();
});
