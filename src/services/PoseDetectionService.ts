import {
    PoseLandmarker,
    FilesetResolver
} from "@mediapipe/tasks-vision";

// Types
export interface PoseLandmark {
    x: number;
    y: number;
    z: number;
    visibility: number;
}

export class PoseDetectionService {
    private poseLandmarker: PoseLandmarker | null = null;
    private runningMode: "IMAGE" | "VIDEO" = "VIDEO";

    // Initialize the model
    async initialize() {
        if (this.poseLandmarker) return; // Already initialized

        const vision = await FilesetResolver.forVisionTasks(
            "https://cdn.jsdelivr.net/npm/@mediapipe/tasks-vision@0.10.0/wasm"
        );

        this.poseLandmarker = await PoseLandmarker.createFromOptions(vision, {
            baseOptions: {
                modelAssetPath: `https://storage.googleapis.com/mediapipe-models/pose_landmarker/pose_landmarker_lite/float16/1/pose_landmarker_lite.task`,
                delegate: "GPU"
            },
            runningMode: this.runningMode,
            numPoses: 1
        });

        console.log("PoseLandmarker initialized!");
    }

    // Detect landmarks for a video frame
    detectForVideo(video: HTMLVideoElement, startTimeMs: number) {
        if (!this.poseLandmarker) return null;

        const result = this.poseLandmarker.detectForVideo(video, startTimeMs);
        return result.landmarks[0] ?? null; // Return first person detected or null
    }

    // --- LOGIC: Fall Detection ---
    // Simple heuristic: 
    // 1. Nose Y vs Hip Y. Normal standing: Nose Y (0.1) < Hip Y (0.5).
    // 2. Fallen: Nose Y approx same as Hip Y (within threshold).
    // 3. Or Velocity (but simple static check first for proto).
    private getTorsoAngle(landmarks: PoseLandmark[]): number {
        // Landmarks: 11=Left Shoulder, 12=Right Shoulder, 23=Left Hip, 24=Right Hip
        const leftShoulder = landmarks[11];
        const rightShoulder = landmarks[12];
        const leftHip = landmarks[23];
        const rightHip = landmarks[24];

        if (!leftShoulder || !rightShoulder || !leftHip || !rightHip) return 0;

        // Midpoints
        const midShoulderX = (leftShoulder.x + rightShoulder.x) / 2;
        const midShoulderY = (leftShoulder.y + rightShoulder.y) / 2;
        const midHipX = (leftHip.x + rightHip.x) / 2;
        const midHipY = (leftHip.y + rightHip.y) / 2;

        // Calculate Angle with Vertical Axis (Y-axis)
        // dx, dy from Hip to Shoulder (Upward vector)
        const dx = midShoulderX - midHipX;
        const dy = midShoulderY - midHipY; // dy should be negative if standing upright

        // Angle in degrees (0 = Upright, 90 = Horizontal)
        // atan2(dy, dx) gives angle from X axis.
        // We want deviation from Vertical.
        // Vertical vector is (0, -1). 
        // Simpler: just abs(atan(dx/dy))

        let angleRad = Math.atan2(Math.abs(dy), Math.abs(dx));
        // Note: This gives angle with Horizontal. 
        // if dy is large (upright), angleRad is close to 90 deg (PI/2).
        // if dx is large (lying), angleRad is close to 0.

        const angleDeg = angleRad * (180 / Math.PI);

        // Return "Verticality" where 90 is Upright, 0 is Flat.
        return angleDeg;
    }

    isFalling(landmarks: PoseLandmark[]): boolean {
        if (!landmarks || landmarks.length < 33) return false;

        const torsoAngle = this.getTorsoAngle(landmarks);

        // Aspect Ratio Check: If the bounding box is significantly WIDER than TALL, likely lying down.
        const xValues = landmarks.map(l => l.x);
        const yValues = landmarks.map(l => l.y);
        const width = Math.max(...xValues) - Math.min(...xValues);
        const height = Math.max(...yValues) - Math.min(...yValues);

        // Horizontal Check: Must be significantly flat. 
        // 1.25 ratio filters out "squarish" sitting postures but catches "starfish" lying.
        const isFlat = width > height * 1.25;

        // Threshold 45 degrees:
        // - < 45 catches most falls.
        // - prevents sitting lean (usually > 55-60) from triggering.
        // - isFlat (backup) catches diagonal falls where angle might be borderline.
        return torsoAngle < 45 || isFlat;
    }

    private getLegStraightness(landmarks: PoseLandmark[]): number {
        // Left: 23-25-27, Right: 24-26-28
        const lHip = landmarks[23];
        const lKnee = landmarks[25];
        const lAnkle = landmarks[27];

        const rHip = landmarks[24];
        const rKnee = landmarks[26];
        const rAnkle = landmarks[28];

        // Helper to get angle
        const getAngle = (a: PoseLandmark, b: PoseLandmark, c: PoseLandmark) => {
            if (!a || !b || !c) return 180; // High bend if missing
            const ab = { x: b.x - a.x, y: b.y - a.y };
            const bc = { x: c.x - b.x, y: c.y - b.y };
            const dot = ab.x * bc.x + ab.y * bc.y;
            const magAB = Math.sqrt(ab.x * ab.x + ab.y * ab.y);
            const magBC = Math.sqrt(bc.x * bc.x + bc.y * bc.y);
            if (magAB * magBC === 0) return 0;
            let cosine = dot / (magAB * magBC);
            cosine = Math.max(-1, Math.min(1, cosine));
            return Math.acos(cosine) * (180 / Math.PI);
        };

        const leftBend = getAngle(lHip, lKnee, lAnkle);
        const rightBend = getAngle(rHip, rKnee, rAnkle);

        // Return the STRAIGHTEST leg (min angle of bend)
        // 0 = perfectly straight
        return Math.min(leftBend, rightBend);
    }

    isStanding(landmarks: PoseLandmark[]): boolean {
        if (!landmarks || landmarks.length < 33) return false;

        const torsoAngle = this.getTorsoAngle(landmarks);

        // Must be upright
        if (torsoAngle < 60) return false;

        // Check Aspect Ratio
        const xValues = landmarks.map(l => l.x);
        const yValues = landmarks.map(l => l.y);
        const width = Math.max(...xValues) - Math.min(...xValues);
        const height = Math.max(...yValues) - Math.min(...yValues);
        const ratio = height / width;

        // Check Leg Straightness
        // Standing = Legs are mostly straight (Angle between Hip-Knee and Knee-Ankle is low, < 40 deg deviation)
        const legBend = this.getLegStraightness(landmarks);
        const isLegsStraight = legBend < 40;

        // Strategy: 
        // If Ratio is very tall (> 1.5), likely standing side/profile.
        // If Ratio is normal but Legs Straight, definitely standing.

        return ratio > 1.2 || isLegsStraight;
    }


}

export const poseDetectionService = new PoseDetectionService();
