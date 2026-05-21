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
            java.util.Properties props = new java.util.Properties();
            try (java.io.InputStream is = HibernateUtil.class.getClassLoader().getResourceAsStream("db.properties")) {
                if (is != null) {
                    props.load(is);
                    LoggingUtil.info("[Course-Vault] Loaded DB configuration from db.properties");
                }
            } catch (Exception e) {
                LoggingUtil.error("Note: Could not load db.properties: " + e.getMessage());
            }

            String dbUser = System.getenv("DB_USER");
            if (dbUser == null) dbUser = props.getProperty("db.user", "root");

            String dbPass = System.getenv("DB_PASSWORD");
            if (dbPass == null) dbPass = props.getProperty("db.password", "");
            
            String dbName = props.getProperty("db.name", "course_vault");

            configuration.setProperty("hibernate.connection.driver_class", "com.mysql.cj.jdbc.Driver");
            configuration.setProperty("hibernate.connection.url", "jdbc:mysql://localhost:3306/" + dbName + "?useSSL=false&allowPublicKeyRetrieval=true");
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
                LoggingUtil.info("[Course-Vault] Hibernate SessionFactory built successfully.");
            } catch (Exception e) {
                LoggingUtil.error("*******************************************************************");
                LoggingUtil.error("CRITICAL: HIBERNATE INITIALIZATION FAILED!");
                LoggingUtil.error("REASON: " + e.getMessage());
                LoggingUtil.error("ROOT CAUSE: " + (e.getCause() != null ? e.getCause().getClass().getName() : e.getClass().getName()) + ": " + e.getMessage());
                
                if (e.getMessage().contains("Access denied")) {
                    LoggingUtil.error("Check your MySQL username/password in HibernateUtil.java");
                } else if (e.getMessage().contains("Communications link failure")) {
                    LoggingUtil.error("Is XAMPP/MySQL running? Ensure MySQL is started.");
                } else if (e.getMessage().contains("Unknown database")) {
                    LoggingUtil.error("Create the 'course_vault' database in MySQL");
                }
                LoggingUtil.error("*******************************************************************");

                throw new RuntimeException("Database Error: " + e.getMessage(), e);
            }
        }
        return sessionFactory;
    }
}
