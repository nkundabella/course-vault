package com.coursevault;

import com.coursevault.model.User;
import com.coursevault.services.UserService;

public class PromoteUser {
    public static void main(String[] args) {
        try {
            String email = "nkundaisabellaa@gmail.com";
            System.out.println("Promoting " + email + " to ADMIN...");
            User user = UserService.getInstance().getUserByEmail(email);
            if (user != null) {
                UserService.getInstance().updateUserRole(user.getId(), "ADMIN");
                System.out.println("SUCCESS: User promoted to ADMIN.");
            } else {
                System.out.println("User not found. They will get ADMIN status automatically when they sign up.");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        System.exit(0);
    }
}
