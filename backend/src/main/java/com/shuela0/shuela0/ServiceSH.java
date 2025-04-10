package com.shuela0.shuela0;

import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.*;
import com.google.firebase.cloud.FirestoreClient;
import org.springframework.stereotype.Service;
import java.util.concurrent.ExecutionException;

@Service
public class ServiceSH {

    private static final String COLLECTION_NAME = "User"; // Change collection name as needed

    /**
     * Create a new document in Firestore
     */
    public String createData(String documentId, DATA data) throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        DocumentReference docRef = db.collection(COLLECTION_NAME).document(documentId);
        ApiFuture<WriteResult> writeResult = docRef.set(data);
        return "Document created at: " + writeResult.get().getUpdateTime();
    }

    /**
     * Read a document by ID from Firestore
     */
    public DATA getData(String documentId) throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        DocumentReference docRef = db.collection(COLLECTION_NAME).document(documentId);
        ApiFuture<DocumentSnapshot> future = docRef.get();
        DocumentSnapshot document = future.get();

        if (document.exists()) {
            return document.toObject(DATA.class); // يقوم بتحويل الوثيقة إلى كائن DATA
        } else {
            return null; // أو يمكن رمي استثناء إذا لم يتم العثور على الوثيقة
        }
    }



    public String updateData(String documentId, Object updatedData) throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        DocumentReference docRef = db.collection(COLLECTION_NAME).document(documentId);
        ApiFuture<WriteResult> writeResult = docRef.set(updatedData, SetOptions.merge());
        return "Document updated at: " + writeResult.get().getUpdateTime();
    }

    public String deleteData(String documentId) throws ExecutionException, InterruptedException {
        Firestore db = FirestoreClient.getFirestore();
        DocumentReference docRef = db.collection(COLLECTION_NAME).document(documentId);
        ApiFuture<WriteResult> writeResult = docRef.delete();
        return "Document deleted at: " + writeResult.get().getUpdateTime();
    }
}