package com.shuela0.shuela0;

import ai.onnxruntime.*;
import org.opencv.core.*;
import org.opencv.imgproc.Imgproc;
import org.opencv.videoio.VideoCapture;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import java.io.File;
import java.nio.FloatBuffer;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

@RestController
@RequestMapping("/api")
public class DetectionController {

    static {
        try {
            System.loadLibrary(Core.NATIVE_LIBRARY_NAME); // يجب أن يكون opencv_java490.dll
            System.out.println("✅ OpenCV Loaded Successfully");
        } catch (UnsatisfiedLinkError e) {
            System.err.println("❌ OpenCV loading failed: " + e.getMessage());
        }
    }



    private OrtEnvironment env;
    private OrtSession session;
    private final String[] labelMap = {"ball", "goalkeeper", "player", "referee"};
    private final double pixelToMeter = 0.045;
    private final double possessionThreshold = 200;

    public DetectionController() throws OrtException {
        env = OrtEnvironment.getEnvironment();
        session = env.createSession("src/main/resources/best.onnx", new OrtSession.SessionOptions());
    }

    @PostMapping("/analyze-video")
    public ResponseEntity<Map<String, Object>> analyzeVideo(@RequestParam("video") MultipartFile file) {
        try {
            String uploadDir = System.getProperty("user.dir") + File.separator + "uploads";
            new File(uploadDir).mkdirs();

            String videoPath = uploadDir + File.separator + "temp_video_" + System.currentTimeMillis() + ".mp4";
            File videoFile = new File(videoPath);
            file.transferTo(videoFile);

            System.out.println("📁 Video Path: " + videoFile.getAbsolutePath());
            System.out.println("📁 Exists? " + videoFile.exists());
            System.out.println("📏 Size: " + videoFile.length());

            VideoCapture cap = new VideoCapture(videoFile.getAbsolutePath());
            if (!cap.isOpened()) {
                throw new RuntimeException("❌ Failed to open video: " + videoPath);
            }

            double fps = cap.get(5);
            Map<Integer, List<double[]>> playerPositions = new ConcurrentHashMap<>();
            List<double[]> ballPositions = new ArrayList<>();
            Map<Integer, Double> possession = new ConcurrentHashMap<>();
            List<Object[]> passes = new ArrayList<>();
            int frameCount = 0;
            int ballNotNearPlayerFrames = 0;

            Mat frame = new Mat();
            while (cap.read(frame)) {
                float[] imgData = preprocessFrame(frame);
                OnnxTensor inputTensor = OnnxTensor.createTensor(env, FloatBuffer.wrap(imgData), new long[]{1, 3, 640, 640});
                Map<String, OnnxTensor> inputs = new HashMap<>();
                inputs.put(session.getInputInfo().keySet().iterator().next(), inputTensor);
                OrtSession.Result result = session.run(inputs);
                float[][][] outputs = (float[][][]) result.get(0).getValue();

                List<Object[]> detections = postprocessDetections(outputs[0]);

                List<float[]> playerBoxes = new ArrayList<>();
                List<float[]> ballBoxes = new ArrayList<>();
                for (Object[] det : detections) {
                    float[] box = (float[]) det[0];
                    int cls = (int) det[2];
                    if (labelMap[cls].equals("player") || labelMap[cls].equals("goalkeeper")) {
                        playerBoxes.add(box);
                    } else if (labelMap[cls].equals("ball")) {
                        ballBoxes.add(box);
                    }
                }

                double[] ballCentroid = updateBallTracker(ballBoxes);
                if (ballCentroid != null) {
                    ballPositions.add(new double[]{frameCount, ballCentroid[0], ballCentroid[1]});
                }

                Map<Integer, double[]> playerObjects = updatePlayerTracker(playerBoxes, frameCount, playerPositions);

                boolean ballNearPlayer = false;
                if (ballCentroid != null) {
                    double minDist = Double.MAX_VALUE;
                    Integer closestPlayer = null;
                    for (Map.Entry<Integer, double[]> entry : playerObjects.entrySet()) {
                        double[] playerCentroid = entry.getValue();
                        double dist = Math.sqrt(Math.pow(ballCentroid[0] - playerCentroid[0], 2) + Math.pow(ballCentroid[1] - playerCentroid[1], 2));
                        if (dist < minDist && dist < possessionThreshold) {
                            minDist = dist;
                            closestPlayer = entry.getKey();
                        }
                    }
                    if (closestPlayer != null) {
                        possession.put(closestPlayer, possession.getOrDefault(closestPlayer, 0.0) + 1 / fps);
                        ballNearPlayer = true;
                    }
                }
                if (!ballNearPlayer) {
                    ballNotNearPlayerFrames++;
                }

                frameCount++;
            }
            cap.release();
            new File(videoPath).delete();

            Map<Integer, Double> speeds = calculateSpeeds(playerPositions, fps);

            Map<String, Integer> passingStats = calculatePassingAccuracy(ballPositions, playerPositions, possessionThreshold, fps);
            int totalPasses = passingStats.get("totalPasses");
            int successfulPasses = passingStats.get("successfulPasses");
            double passingAccuracy = totalPasses > 0 ? (double) successfulPasses / totalPasses : 0;

            Map<String, Object> response = new HashMap<>();
            response.put("playerSpeeds", speeds);
            response.put("passingAccuracy", passingAccuracy);
            response.put("ballPossessionTime", possession);
            response.put("debugInfo", Map.of(
                    "totalFrames", frameCount,
                    "ballDetections", ballPositions.size(),
                    "ballNotNearPlayerFrames", ballNotNearPlayerFrames
            ));
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            Map<String, Object> error = new HashMap<>();
            error.put("error", e.getMessage());
            return ResponseEntity.status(500).body(error);
        }
    }

    private float[] preprocessFrame(Mat frame) {
        Mat rgb = new Mat();
        Imgproc.cvtColor(frame, rgb, Imgproc.COLOR_BGR2RGB);
        Mat resized = new Mat();
        Imgproc.resize(rgb, resized, new Size(640, 640));
        float[] imgData = new float[1 * 3 * 640 * 640];
        int idx = 0;
        for (int y = 0; y < 640; y++) {
            for (int x = 0; x < 640; x++) {
                double[] rgbValues = resized.get(y, x);
                imgData[idx++] = (float) (rgbValues[0] / 255.0);
                imgData[idx++] = (float) (rgbValues[1] / 255.0);
                imgData[idx++] = (float) (rgbValues[2] / 255.0);
            }
        }
        return imgData;
    }

    private List<Object[]> postprocessDetections(float[][] detections) {
        List<Object[]> results = new ArrayList<>();
        float confThres = 0.1f;
        float iouThres = 0.45f;
        List<float[]> boxes = new ArrayList<>();
        List<Float> scores = new ArrayList<>();
        List<Integer> classes = new ArrayList<>();

        for (float[] det : detections) {
            float conf = det[4];
            if (conf > confThres) {
                float maxClassScore = 0;
                int classId = -1;
                for (int i = 5; i < det.length; i++) {
                    if (det[i] > maxClassScore) {
                        maxClassScore = det[i];
                        classId = i - 5;
                    }
                }
                float score = conf * maxClassScore;
                if (score > confThres) {
                    float x = det[0], y = det[1], w = det[2], h = det[3];
                    boxes.add(new float[]{x - w/2, y - h/2, x + w/2, y + h/2});
                    scores.add(score);
                    classes.add(classId);
                }
            }
        }

        List<Integer> indices = applyNMS(boxes, scores, iouThres);
        for (int i : indices) {
            results.add(new Object[]{boxes.get(i), scores.get(i), classes.get(i)});
        }
        return results;
    }

    private double[] updateBallTracker(List<float[]> ballBoxes) {
        if (ballBoxes.isEmpty()) return null;
        float[] box = ballBoxes.get(0);
        return new double[]{(box[0] + box[2]) / 2, (box[1] + box[3]) / 2};
    }

    private Map<Integer, double[]> updatePlayerTracker(List<float[]> playerBoxes, int frameCount, Map<Integer, List<double[]>> playerPositions) {
        Map<Integer, double[]> currentPlayers = new HashMap<>();
        int id = 0;
        for (float[] box : playerBoxes) {
            double[] centroid = new double[]{(box[0] + box[2]) / 2, (box[1] + box[3]) / 2};
            currentPlayers.put(id, centroid);
            playerPositions.computeIfAbsent(id, k -> new ArrayList<>()).add(new double[]{frameCount, centroid[0], centroid[1]});
            id++;
        }
        return currentPlayers;
    }

    private Map<Integer, Double> calculateSpeeds(Map<Integer, List<double[]>> playerPositions, double fps) {
        Map<Integer, Double> speeds = new HashMap<>();
        for (Map.Entry<Integer, List<double[]>> entry : playerPositions.entrySet()) {
            List<double[]> positions = entry.getValue();
            if (positions.size() < 2) continue;
            double totalDistance = 0;
            for (int i = 1; i < positions.size(); i++) {
                double[] pos1 = positions.get(i - 1);
                double[] pos2 = positions.get(i);
                double distPixels = Math.sqrt(Math.pow(pos2[1] - pos1[1], 2) + Math.pow(pos2[2] - pos1[2], 2));
                totalDistance += distPixels * pixelToMeter;
            }
            double timeSeconds = (positions.get(positions.size() - 1)[0] - positions.get(0)[0]) / fps;
            if (timeSeconds > 0) {
                double speed = totalDistance / timeSeconds;
                if (speed <= 12) speeds.put(entry.getKey(), speed);
            }
        }
        return speeds;
    }

    private Map<String, Integer> calculatePassingAccuracy(List<double[]> ballPositions, Map<Integer, List<double[]>> playerPositions, double possessionThreshold, double fps) {
        List<Object[]> passes = new ArrayList<>();
        Integer lastPlayer = null;
        int lastFrame = -10;
        int ballNotNearCount = 0;

        for (double[] ballPos : ballPositions) {
            int frame = (int) ballPos[0];
            double minDist = Double.MAX_VALUE;
            Integer closestPlayer = null;
            for (Map.Entry<Integer, List<double[]>> entry : playerPositions.entrySet()) {
                for (double[] pos : entry.getValue()) {
                    if ((int) pos[0] <= frame) {
                        double dist = Math.sqrt(Math.pow(ballPos[1] - pos[1], 2) + Math.pow(ballPos[2] - pos[2], 2));
                        if (dist < minDist && dist < possessionThreshold) {
                            minDist = dist;
                            closestPlayer = entry.getKey();
                        }
                        break;
                    }
                }
            }
            if (closestPlayer != null) {
                if (lastPlayer != null && !lastPlayer.equals(closestPlayer) && frame - lastFrame > 5) {
                    boolean successful = ballNotNearCount < 10;
                    passes.add(new Object[]{lastPlayer, closestPlayer, frame, successful});
                }
                lastPlayer = closestPlayer;
                lastFrame = frame;
                ballNotNearCount = 0;
            } else {
                ballNotNearCount++;
            }
        }

        int totalPasses = passes.size();
        int successfulPasses = (int) passes.stream().filter(p -> (boolean) p[3]).count();
        return Map.of("totalPasses", totalPasses, "successfulPasses", successfulPasses);
    }

    private List<Integer> applyNMS(List<float[]> boxes, List<Float> scores, float iouThres) {
        List<Integer> indices = new ArrayList<>();
        for (int i = 0; i < scores.size(); i++) {
            boolean keep = true;
            for (int j : indices) {
                float iou = calculateIoU(boxes.get(i), boxes.get(j));
                if (iou > iouThres) {
                    keep = false;
                    break;
                }
            }
            if (keep) indices.add(i);
        }
        return indices;
    }

    private float calculateIoU(float[] box1, float[] box2) {
        float x1 = Math.max(box1[0], box2[0]);
        float y1 = Math.max(box1[1], box2[1]);
        float x2 = Math.min(box1[2], box2[2]);
        float y2 = Math.min(box1[3], box2[3]);
        float intersection = Math.max(0, x2 - x1) * Math.max(0, y2 - y1);
        float area1 = (box1[2] - box1[0]) * (box1[3] - box1[1]);
        float area2 = (box2[2] - box2[0]) * (box2[3] - box2[1]);
        return intersection / (area1 + area2 - intersection);
    }
}