package com.coursevault.hibernate;

import com.coursevault.model.*;
import org.hibernate.SessionFactory;
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;
import org.hibernate.cfg.Configuration;
import org.hibernate.service.ServiceRegistry;

public class HibernateUtil {
    private static SessionFactory sessionFactory;

    public static SessionFactory getSessionFactory() {
        if (sessionFactory == null) {
            Configuration configuration = new Configuration();
            
            // Database connection settings
            String dbUser = System.getenv("DB_USER") != null ? System.getenv("DB_USER") : "root";
            String dbPass = System.getenv("DB_PASSWORD") != null ? System.getenv("DB_PASSWORD") : "";
            
            configuration.setProperty("hibernate.connection.driver_class", "com.mysql.cj.jdbc.Driver");
            configuration.setProperty("hibernate.connection.url", "jdbc:mysql://localhost:3306/coursevault?useSSL=false&allowPublicKeyRetrieval=true");
            configuration.setProperty("hibernate.connection.username", dbUser);
            configuration.setProperty("hibernate.connection.password", dbPass);
            configuration.setProperty("hibernate.dialect", "org.hibernate.dialect.MySQLDialect");
            configuration.setProperty("hibernate.show_sql", "true");
            configuration.setProperty("hibernate.hbm2ddl.auto", "update");

            // Annotated classes
            configuration.addAnnotatedClass(User.class);
            configuration.addAnnotatedClass(Subject.class);
            configuration.addAnnotatedClass(Resource.class);
            configuration.addAnnotatedClass(Bookmark.class);
            configuration.addAnnotatedClass(CalendarEvent.class);
            configuration.addAnnotatedClass(SystemConfig.class);

            try {
                ServiceRegistry serviceRegistry = new StandardServiceRegistryBuilder()
                        .applySettings(configuration.getProperties()).build();

                sessionFactory = configuration.buildSessionFactory(serviceRegistry);
                System.out.println("[Course-Vault] Hibernate SessionFactory built successfully.");
            } catch (Exception e) {
                System.err.println("*******************************************************************");
                System.err.println("CRITICAL: HIBERNATE INITIALIZATION FAILED!");
                System.err.println("REASON: " + e.getMessage());
                
                Throwable root = e;
                while (root.getCause() != null) root = root.getCause();
                System.err.println("ROOT CAUSE: " + root.getClass().getName() + ": " + root.getMessage());
                
                if (root.getMessage().contains("Access denied")) {
                    System.err.println("ADVICE: Check your MySQL username/password in HibernateUtil.java");
                } else if (root.getMessage().contains("Communications link failure")) {
                    System.err.println("ADVICE: Is XAMPP/MySQL running? Ensure MySQL is started.");
                } else if (root.getMessage().contains("Unknown database")) {
                    System.err.println("ADVICE: Create the 'coursevault' database in phpMyAdmin.");
                }
                System.err.println("*******************************************************************");
                
                // Re-throw with more detail so it shows up in error.jsp
                throw new RuntimeException("Database Error: " + root.getMessage(), e);
            }
        }
        return sessionFactory;
    }
}
