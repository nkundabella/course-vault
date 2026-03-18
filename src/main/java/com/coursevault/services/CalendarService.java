package com.coursevault.services;

import com.coursevault.hibernate.HibernateUtil;
import com.coursevault.model.CalendarEvent;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import java.util.List;

public class CalendarService {
    private static final CalendarService instance = new CalendarService();

    public static CalendarService getInstance() {
        return instance;
    }

    private CalendarService() {}

    private SessionFactory getSfb() {
        return HibernateUtil.getSessionFactory();
    }

    public void addEvent(CalendarEvent event) {
        try (Session sesh = getSfb().openSession()) {
            sesh.beginTransaction();
            sesh.persist(event);
            sesh.getTransaction().commit();
        }
    }

    public void deleteEvent(long id) {
        try (Session sesh = getSfb().openSession()) {
            sesh.beginTransaction();
            CalendarEvent e = sesh.get(CalendarEvent.class, id);
            if (e != null) {
                sesh.remove(e);
            }
            sesh.getTransaction().commit();
        }
    }

    public List<CalendarEvent> getAllEvents() {
        try (Session sesh = getSfb().openSession()) {
            return sesh.createQuery("from CalendarEvent order by date asc", CalendarEvent.class).list();
        }
    }
}
