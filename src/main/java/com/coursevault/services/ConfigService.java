package com.coursevault.services;

import com.coursevault.hibernate.HibernateUtil;
import com.coursevault.model.SystemConfig;
import org.hibernate.Session;
import org.hibernate.SessionFactory;

public class ConfigService {
    private static final ConfigService instance = new ConfigService();

    public static ConfigService getInstance() {
        return instance;
    }

    private ConfigService() {}

    private SessionFactory getSfb() {
        return HibernateUtil.getSessionFactory();
    }

    public SystemConfig getConfig() {
        try (Session sesh = getSfb().openSession()) {
            SystemConfig config = sesh.createQuery("from SystemConfig", SystemConfig.class)
                    .setMaxResults(1)
                    .uniqueResult();
            if (config == null) {
                config = new SystemConfig();
            }
            return config;
        }
    }

    public void updateConfig(SystemConfig config) {
        try (Session sesh = getSfb().openSession()) {
            sesh.beginTransaction();
            sesh.merge(config);
            sesh.getTransaction().commit();
        }
    }
}
