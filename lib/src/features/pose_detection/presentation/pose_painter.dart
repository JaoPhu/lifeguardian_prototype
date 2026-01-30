import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

class PosePainter extends CustomPainter {
  PosePainter(this.landmarks, {required this.isLaying, required this.isWalking});

  final Map<PoseLandmarkType, PoseLandmark> landmarks;
  final bool isLaying;
  final bool isWalking;

  @override
  void paint(Canvas canvas, Size size) {
    // Basic paint configuration
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..color = isLaying ? Colors.red : (isWalking ? Colors.orange : Colors.green);

    final leftPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.blueAccent;

    final rightPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.orangeAccent;

    // Draw connections (skeleton)
    void paintLine(PoseLandmarkType type1, PoseLandmarkType type2, Paint paintType) {
      final p1 = landmarks[type1];
      final p2 = landmarks[type2];
      if (p1 == null || p2 == null) return;
      
      // Coordinate translation might be needed if the image size differs from canvas size
      // For now assume they match or are scaled by the parent widget (CustomPaint)
      canvas.drawLine(Offset(p1.x, p1.y), Offset(p2.x, p2.y), paintType);
    }

    // Torso
    paintLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.rightShoulder, paint);
    paintLine(PoseLandmarkType.leftHip, PoseLandmarkType.rightHip, paint);
    paintLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftHip, paint);
    paintLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightHip, paint);

    // Arms
    paintLine(PoseLandmarkType.leftShoulder, PoseLandmarkType.leftElbow, leftPaint);
    paintLine(PoseLandmarkType.leftElbow, PoseLandmarkType.leftWrist, leftPaint);
    paintLine(PoseLandmarkType.rightShoulder, PoseLandmarkType.rightElbow, rightPaint);
    paintLine(PoseLandmarkType.rightElbow, PoseLandmarkType.rightWrist, rightPaint);

    // Legs
    paintLine(PoseLandmarkType.leftHip, PoseLandmarkType.leftKnee, leftPaint);
    paintLine(PoseLandmarkType.leftKnee, PoseLandmarkType.leftAnkle, leftPaint);
    paintLine(PoseLandmarkType.rightHip, PoseLandmarkType.rightKnee, rightPaint);
    paintLine(PoseLandmarkType.rightKnee, PoseLandmarkType.rightAnkle, rightPaint);

    // Draw joints
    for (final landmark in landmarks.values) {
       canvas.drawCircle(Offset(landmark.x, landmark.y), 5, paint..style = PaintingStyle.fill);
    }
  }

  @override
  bool shouldRepaint(covariant PosePainter oldDelegate) {
    return oldDelegate.landmarks != landmarks ||
           oldDelegate.isLaying != isLaying ||
           oldDelegate.isWalking != isWalking;
  }
}
