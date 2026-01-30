import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/camera.dart';

class CameraNotifier extends StateNotifier<List<Camera>> {
  CameraNotifier() : super([
    const Camera(
      id: 'cam-01',
      name: 'Camera 1',
      status: CameraStatus.offline,
      source: CameraSource.camera,
      events: [],
    ),
  ]);

  void addCamera(Camera camera) {
    state = [camera, ...state];
  }

  void removeCamera(String id) {
    state = state.where((c) => c.id != id).toList();
  }

  void updateCameraStatus(String id, CameraStatus status) {
    state = state.map((c) => c.id == id ? c.copyWith(status: status) : c).toList();
  }
}

final cameraProvider = StateNotifierProvider<CameraNotifier, List<Camera>>((ref) {
  return CameraNotifier();
});
