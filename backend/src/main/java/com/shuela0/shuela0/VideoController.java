package com.shuela0.shuela0;// package com.shuela0.shuela0;

import com.google.cloud.firestore.DocumentReference;
import com.google.cloud.firestore.FieldValue;
import com.google.cloud.firestore.Firestore;
import com.google.firebase.cloud.FirestoreClient;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.util.StringUtils;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api")
public class VideoController {

    private final String uploadDir = "uploads";

    public VideoController() throws IOException {
        // Ensure upload folder exists
        Path uploadPath = Paths.get(uploadDir);
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }
    }

    @PostMapping("/uploadVideo")
    public ResponseEntity<?> uploadVideo(@RequestParam("file") MultipartFile file) {
        Map<String, Object> response = new HashMap<>();

        try {
            if (file.isEmpty()) {
                response.put("error", "File is empty");
                return ResponseEntity.badRequest().body(response);
            }

            // Normalize filename
            String fileName = StringUtils.cleanPath(file.getOriginalFilename());
            Path targetLocation = Paths.get(uploadDir).resolve(fileName);
            Files.copy(file.getInputStream(), targetLocation, StandardCopyOption.REPLACE_EXISTING);

            // Simulate sending video to AI (we can implement later)
            String fakeAIResult = analyzeVideo(fileName);

            // Return response with video path and AI result
            response.put("message", "Video uploaded successfully");
            response.put("fileName", fileName);
            response.put("path", targetLocation.toString());
            response.put("aiResult", fakeAIResult);
            return ResponseEntity.ok(response);

        } catch (IOException e) {
            response.put("error", "Could not store video: " + e.getMessage());
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    // Temporary fake AI logic (replace later with real logic or API call)
    private String analyzeVideo(String fileName) {
        // افتراضًا إن عندك uid المستخدم
        String userId = "user_1"; // ممكن تجيبينه من التوكن مثلاً
        String videoName = fileName; // مثل: vid1.mp4

// تحدثي قائمة الفيديوهات في Firestore
        Firestore db = FirestoreClient.getFirestore();
        DocumentReference userRef = db.collection("User").document(userId);

        userRef.update("videoID", FieldValue.arrayUnion(videoName));

        // Example: Return a mock result
        return "AI processed video: " + fileName + " and detected: Player Running";
    }
}
