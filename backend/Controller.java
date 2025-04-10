package com.shuela0.shuela0;

import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseToken;
import org.springframework.web.bind.annotation.*;

import java.util.concurrent.ExecutionException;

import jakarta.servlet.http.HttpServletRequest;

@RestController
@RequestMapping("/api")
public class Controller {

    public ServiceSH service;

    public Controller(ServiceSH service) {
        this.service = service;
    }

    // ✅ ميثود للتحقق من التوكن واستخراج UID المستخدم
    private String verifyTokenAndGetUID(HttpServletRequest request) throws Exception {
        String authHeader = request.getHeader("Authorization");

        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            throw new Exception("Missing or invalid Authorization header.");
        }

        String idToken = authHeader.substring(7);
        FirebaseToken decodedToken = FirebaseAuth.getInstance().verifyIdToken(idToken);
        return decodedToken.getUid(); // تستخدمه إذا تبغى تعرف من المستخدم
    }

    @PostMapping("/create")
    public String createdata(@RequestBody DATA data, HttpServletRequest request) throws Exception {
        verifyTokenAndGetUID(request); // 🔐 تحقق من التوكن
        return service.createData(data.getID(), data);
    }

    @GetMapping("/get")
    public DATA getdata(@RequestParam String ID, HttpServletRequest request) throws Exception {
        verifyTokenAndGetUID(request); // 🔐 تحقق من التوكن
        return service.getData(ID);
    }

    @PutMapping("/update")
    public String updatedata(@RequestBody DATA data, HttpServletRequest request) throws Exception {
        verifyTokenAndGetUID(request); // 🔐 تحقق من التوكن
        return service.updateData(data.getID(), data);
    }

    @DeleteMapping("/delete")
    public String deletedata(@RequestParam String ID, HttpServletRequest request) throws Exception {
        verifyTokenAndGetUID(request); // 🔐 تحقق من التوكن
        return service.deleteData(ID);
    }
}
