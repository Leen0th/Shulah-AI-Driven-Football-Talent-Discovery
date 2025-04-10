package com.shuela0;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Objects;


import ai.onnxruntime.OrtEnvironment;
import ai.onnxruntime.OrtSession;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseAuthException;
import com.google.firebase.auth.FirebaseToken;
import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import org.springframework.context.annotation.ComponentScan;

@ComponentScan(basePackages = "com.shuela0.shuela0") // تأكد أن هذا السطر موجود

@SpringBootApplication
public class Shuela0Application {
	public static void main(String[] args) throws IOException {
		ClassLoader classLoader = Shuela0Application.class.getClassLoader();

		File file = new File(Objects.requireNonNull(classLoader.getResource("SERVESkey.json")).getFile());
		FileInputStream serviceAccount = new FileInputStream(file.getAbsolutePath());
		FirebaseOptions options = new FirebaseOptions.Builder()
				.setCredentials(GoogleCredentials.fromStream(serviceAccount))
				.setDatabaseUrl("https://fir-crud-main-default-rtdb.asia-southeast1.firebasedatabase.app")
				.setStorageBucket("shuela-3ccac.appspot.com") // ✅ مهم لتفعيل Firebase Storage
				.build();

		FirebaseApp.initializeApp(options);
		try {
			OrtEnvironment env = OrtEnvironment.getEnvironment();
			OrtSession.SessionOptions sessionOptions = new OrtSession.SessionOptions();
			OrtSession session = env.createSession("src/main/resources/best.onnx", sessionOptions);


			System.out.println("✅ ONNX Model Loaded Successfully");
			System.out.println("Inputs:");
			session.getInputInfo().forEach((k, v) -> System.out.println(" - " + k + ": " + v.toString()));
		} catch (Exception e) {
			System.err.println("❌ Failed to load ONNX model: " + e.getMessage());
		}

		SpringApplication.run(Shuela0Application.class, args);
	}


}