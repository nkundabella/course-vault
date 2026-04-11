package com.coursevault;

import com.coursevault.model.User;
import java.util.List;

public class DbCheck {
    public static void main(String[] args) {
        try {
            System.out.println("Checking User Database...");
            // Use Hibernate to fetch all users (assuming we have a way or just use a query)
            try (org.hibernate.Session session = com.coursevault.hibernate.HibernateUtil.getSessionFactory().openSession()) {
                List<User> users = session.createQuery("from User", User.class).list();
                System.out.println("Total Users: " + users.size());
                for (User u : users) {
                    System.out.println("- " + u.getEmail() + " | Role: " + u.getRole());
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        System.exit(0);
    }
}
