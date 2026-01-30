import 'package:flutter/foundation.dart';
import '../../statistics/domain/simulation_event.dart';

enum CameraSource { camera, demo }
enum CameraStatus { online, offline }

@immutable
class CameraConfig {
  final String? date;
  final String? originalDate;
  final String? startTime;
  final String? thumbnailUrl;
  final String? eventType;
  final String? durationText;

  const CameraConfig({
    this.date,
    this.originalDate,
    this.startTime,
    this.thumbnailUrl,
    this.eventType,
    this.durationText,
  });
}

@immutable
class Camera {
  final String id;
  final String name;
  final CameraStatus status;
  final CameraSource source;
  final List<SimulationEvent> events;
  final CameraConfig? config;

  const Camera({
    required this.id,
    required this.name,
    required this.status,
    required this.source,
    required this.events,
    this.config,
  });

  Camera copyWith({
    String? id,
    String? name,
    CameraStatus? status,
    CameraSource? source,
    List<SimulationEvent>? events,
    CameraConfig? config,
  }) {
    return Camera(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      source: source ?? this.source,
      events: events ?? this.events,
      config: config ?? this.config,
    );
  }
}
