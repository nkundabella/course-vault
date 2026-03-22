package com.coursevault.services;

import com.coursevault.hibernate.HibernateUtil;
import com.coursevault.model.User;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import java.util.List;

public class UserService {
    private static final UserService instance = new UserService();

    public static UserService getInstance() {
        return instance;
    }

    private UserService() {}

    private SessionFactory getSfb() {
        return HibernateUtil.getSessionFactory();
    }

    public void addUser(User user) {
        try (Session sesh = getSfb().openSession()) {
            sesh.beginTransaction();
            sesh.persist(user);
            sesh.getTransaction().commit();
        }
    }

    public User getUserByEmail(String email) {
        try (Session sesh = getSfb().openSession()) {
            return sesh.createQuery("from User where email = :email", User.class)
                    .setParameter("email", email)
                    .uniqueResult();
        }
    }

    public User getUserById(long id) {
        try (Session sesh = getSfb().openSession()) {
            return sesh.get(User.class, id);
        }
    }

    public List<User> getUsersByRole(String role) {
        try (Session sesh = getSfb().openSession()) {
            return sesh.createQuery("from User where role = :role", User.class)
                    .setParameter("role", role)
                    .list();
        }
    }

    public long getUserCount() {
        try (Session sesh = getSfb().openSession()) {
            return sesh.createQuery("select count(u) from User u", Long.class).uniqueResult();
        }
    }

    public void updateUser(User user) {
        try (Session sesh = getSfb().openSession()) {
            sesh.beginTransaction();
            sesh.merge(user);
            sesh.getTransaction().commit();
        }
    }

    public void updateUserRole(long userId, String newRole) {
        try (Session sesh = getSfb().openSession()) {
            sesh.beginTransaction();
            User user = sesh.get(User.class, userId);
            if (user != null) {
                user.setRole(newRole);
                sesh.merge(user);
            }
            sesh.getTransaction().commit();
        }
    }
}
