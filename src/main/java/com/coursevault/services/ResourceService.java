package com.coursevault.services;

import com.coursevault.hibernate.HibernateUtil;
import com.coursevault.model.Bookmark;
import com.coursevault.model.Resource;
import com.coursevault.model.User;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import java.util.List;

public class ResourceService {
    private static final ResourceService instance = new ResourceService();

    public static ResourceService getInstance() {
        return instance;
    }

    private ResourceService() {}

    private SessionFactory getSfb() {
        return HibernateUtil.getSessionFactory();
    }

    public void addResource(Resource resource) {
        try (Session sesh = getSfb().openSession()) {
            sesh.beginTransaction();
            sesh.persist(resource);
            sesh.getTransaction().commit();
        }
    }

    public void updateResource(Resource resource) {
        try (Session sesh = getSfb().openSession()) {
            sesh.beginTransaction();
            sesh.merge(resource);
            sesh.getTransaction().commit();
        }
    }

    public void deleteResource(long id) {
        try (Session sesh = getSfb().openSession()) {
            sesh.beginTransaction();
            Resource resource = sesh.get(Resource.class, id);
            if (resource != null) {
                // Delete associated bookmarks first
                sesh.createQuery("delete from Bookmark where resource.id = :rId")
                    .setParameter("rId", id)
                    .executeUpdate();

                // Delete the file from the filesystem correctly
                if (resource.getFilePath() != null) {
                    String userHome = System.getProperty("user.home");
                    String uploadPath = userHome + java.io.File.separator + "CourseVaultUploads";
                    java.io.File file = new java.io.File(uploadPath + java.io.File.separator + resource.getFilePath());
                    if (file.exists()) {
                        file.delete();
                    }
                }
                sesh.remove(resource);
            }
            sesh.getTransaction().commit();
        }
    }

    public List<Resource> getResourcesBySubject(long subjectId) {
        try (Session sesh = getSfb().openSession()) {
            return sesh.createQuery("from Resource where subject.id = :sId", Resource.class)
                    .setParameter("sId", subjectId)
                    .list();
        }
    }

    public Resource getResourceById(long id) {
        try (Session sesh = getSfb().openSession()) {
            return sesh.get(Resource.class, id);
        }
    }

    public List<Resource> getRecentResources(int limit) {
        try (Session sesh = getSfb().openSession()) {
            return sesh.createQuery("from Resource order by id desc", Resource.class)
                    .setMaxResults(limit)
                    .list();
        }
    }

    public List<Bookmark> getBookmarksByUser(long userId) {
        try (Session sesh = getSfb().openSession()) {
            return sesh.createQuery("from Bookmark where user.id = :uId", Bookmark.class)
                    .setParameter("uId", userId)
                    .list();
        }
    }

    public void toggleBookmark(long userId, long resourceId) {
        try (Session sesh = getSfb().openSession()) {
            sesh.beginTransaction();
            Bookmark existing = sesh.createQuery("from Bookmark where user.id = :uId and resource.id = :rId", Bookmark.class)
                    .setParameter("uId", userId)
                    .setParameter("rId", resourceId)
                    .uniqueResult();
            
            if (existing != null) {
                sesh.remove(existing);
            } else {
                Bookmark b = new Bookmark();
                b.setUser(sesh.get(User.class, userId));
                b.setResource(sesh.get(Resource.class, resourceId));
                sesh.persist(b);
            }
            sesh.getTransaction().commit();
        }
    }

    public List<Resource> getResourcesByUploader(long uploaderId) {
        try (Session sesh = getSfb().openSession()) {
            return sesh.createQuery("from Resource where uploader.id = :uId", Resource.class)
                    .setParameter("uId", uploaderId)
                    .list();
        }
    }

    public List<Resource> getAllResources() {
        try (Session sesh = getSfb().openSession()) {
            return sesh.createQuery("from Resource", Resource.class).list();
        }
    }
}
