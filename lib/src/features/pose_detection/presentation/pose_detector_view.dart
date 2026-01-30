import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:permission_handler/permission_handler.dart';

import '../data/pose_detection_service.dart';
import 'pose_painter.dart';

class PoseDetectorView extends StatefulWidget {
  const PoseDetectorView({super.key});

  @override
  State<PoseDetectorView> createState() => _PoseDetectorViewState();
}

class _PoseDetectorViewState extends State<PoseDetectorView> {
  final PoseDetectionService _poseService = PoseDetectionService();
  CameraController? _cameraController;
  bool _isDetecting = false;
  
  // State for UI
  Map<PoseLandmarkType, PoseLandmark>? _landmarks;
  Map<PoseLandmarkType, PoseLandmark> _landmarkMap = {};
  bool _isLaying = false;
  bool _isWalking = false;
  String _statusText = "Initializing...";

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final status = await Permission.camera.request();
    if (status != PermissionStatus.granted) {
      setState(() => _statusText = "Camera permission denied");
      return;
    }

    final cameras = await availableCameras();
    if (cameras.isEmpty) {
       setState(() => _statusText = "No camera found");
       return;
    }

    // Default to front camera for selfie/fitness use-case if available, else back
    final camera = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      camera,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid 
          ? ImageFormatGroup.nv21 
          : ImageFormatGroup.bgra8888,
    );

    try {
      await _cameraController!.initialize();
      await _cameraController!.startImageStream(_processCameraImage);
      setState(() => _statusText = "Camera Ready");
    } catch (e) {
      setState(() => _statusText = "Camera error: $e");
    }
  }

  void _processCameraImage(CameraImage image) async {
    if (_isDetecting) return;
    _isDetecting = true;

    try {
      final inputImage = _inputImageFromCameraImage(image);
      if (inputImage == null) return;

      final landmarks = await _poseService.detect(inputImage);
      
      if (mounted) {
        setState(() {
          _landmarks = landmarks;
          if (landmarks != null) {
            _landmarkMap = landmarks;
            
            _isLaying = _poseService.isLaying(_landmarkMap);
            // _isStanding = _poseService.isStanding(_landmarkMap);
            _isWalking = _poseService.isWalking(_landmarkMap);
            
            if (_isLaying) {
              _statusText = "Laying / Fallen!";
            } else if (_isWalking) {
              _statusText = "Walking / Active";
            } else {
              _statusText = "Standing";
            }
          } else {
             _statusText = "No Pose Detected";
          }
        });
      }
    } catch (e) {
      debugPrint("Detection error: $e");
    } finally {
      if (mounted) {
        _isDetecting = false;
      }
    }
  }

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    if (_cameraController == null) return null;

    final camera = _cameraController!.description;
    final sensorOrientation = camera.sensorOrientation;
    
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());

    InputImageRotation imageRotation = InputImageRotation.rotation0deg;
    switch (sensorOrientation) {
      case 90: imageRotation = InputImageRotation.rotation90deg; break;
      case 180: imageRotation = InputImageRotation.rotation180deg; break;
      case 270: imageRotation = InputImageRotation.rotation270deg; break;
      default: imageRotation = InputImageRotation.rotation0deg; break;
    }

    // Default to nv21 for Android, bgra8888 for iOS
    final inputImageFormat = Platform.isAndroid ? InputImageFormat.nv21 : InputImageFormat.bgra8888;

    final metadata = InputImageMetadata(
      size: imageSize,
      rotation: imageRotation,
      format: inputImageFormat,
      bytesPerRow: image.planes[0].bytesPerRow,
    );

    return InputImage.fromBytes(bytes: bytes, metadata: metadata);
  }

  @override
  void dispose() {
    _cameraController?.stopImageStream();
    _cameraController?.dispose();
    _poseService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Scaffold(
        body: Center(child: Text(_statusText)),
      );
    }

    final size = MediaQuery.of(context).size;
    // Scale camera preview to cover screen
    var scale = size.aspectRatio * _cameraController!.value.aspectRatio;
    if (scale < 1) scale = 1 / scale;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Transform.scale(
            scale: scale,
            child: Center(
              child: CameraPreview(_cameraController!),
            ),
          ),
          if (_landmarks != null)
            CustomPaint(
              painter: PosePainter(
                _landmarkMap,
                isLaying: _isLaying,
                isWalking: _isWalking,
              ),
              child: Container(),
            ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black54,
              padding: const EdgeInsets.all(16),
              child: Text(
                _statusText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }
}
