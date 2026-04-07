package com.coursevault.services;

import com.coursevault.hibernate.HibernateUtil;
import com.coursevault.model.Subject;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import java.util.List;

public class SubjectService {
    private static final SubjectService instance = new SubjectService();

    public static SubjectService getInstance() {
        return instance;
    }

    private SubjectService() {}

    private SessionFactory getSfb() {
        return HibernateUtil.getSessionFactory();
    }

    public void addSubject(Subject subject) {
        try (Session sesh = getSfb().openSession()) {
            sesh.beginTransaction();
            sesh.persist(subject);
            sesh.getTransaction().commit();
        }
    }

    public void updateSubject(Subject subject) {
        try (Session sesh = getSfb().openSession()) {
            sesh.beginTransaction();
            sesh.merge(subject);
            sesh.getTransaction().commit();
        }
    }

    public void deleteSubject(long id) {
        try (Session sesh = getSfb().openSession()) {
            sesh.beginTransaction();
            Subject subject = sesh.get(Subject.class, id);
            if (subject != null) {
                // Delete physical files for all resources in this subject
                if (subject.getResources() != null) {
                    String userHome = System.getProperty("user.home");
                    String uploadPath = userHome + java.io.File.separator + "CourseVaultUploads";
                    for (com.coursevault.model.Resource res : subject.getResources()) {
                        if (res.getFilePath() != null) {
                            java.io.File file = new java.io.File(uploadPath + java.io.File.separator + res.getFilePath());
                            if (file.exists()) {
                                file.delete();
                            }
                        }
                    }
                }
                sesh.remove(subject);
            }
            sesh.getTransaction().commit();
        }
    }

    public List<Subject> getAllSubjects() {
        try (Session sesh = getSfb().openSession()) {
            return sesh.createQuery("from Subject", Subject.class).list();
        }
    }

    public Subject getSubjectById(long id) {
        try (Session sesh = getSfb().openSession()) {
            return sesh.get(Subject.class, id);
        }
    }

    public Subject getSubjectByName(String name) {
        try (Session sesh = getSfb().openSession()) {
            return sesh.createQuery("from Subject where lower(name) = lower(:name)", Subject.class)
                    .setParameter("name", name)
                    .setMaxResults(1)
                    .uniqueResult();
        }
    }
}
