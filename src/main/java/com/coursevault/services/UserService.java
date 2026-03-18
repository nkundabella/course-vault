package com.coursevault.services;

import com.coursevault.hibernate.HibernateUtil;
import com.coursevault.model.User;
import org.hibernate.Session;
import org.hibernate.SessionFactory;

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
}
