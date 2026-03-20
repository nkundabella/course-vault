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
            List<CalendarEvent> events = sesh.createQuery("from CalendarEvent order by date asc", CalendarEvent.class).list();
            if (events.isEmpty()) {
                seedDefaults();
                return sesh.createQuery("from CalendarEvent order by date asc", CalendarEvent.class).list();
            }
            return events;
        }
    }

    private void seedDefaults() {
        System.out.println("[CalendarService] No events found. Seeding academic defaults…");
        try (Session sesh = getSfb().openSession()) {
            sesh.beginTransaction();
            
            String[][] defaults = {
                {"Orientation Week", "2025-09-01", "1", "General", "true", "Welcome to the new academic year!"},
                {"Mid-Term Assessments", "2025-10-20", "1", "Exam", "true", "First major assessment block for Term 1."},
                {"End of Term 1 Exams", "2025-12-12", "1", "Finals", "true", "Concluding exams for the first term."},
                {"Start of Term 2", "2026-01-12", "2", "General", "false", "Resuming classes for the second half of the year."},
                {"Easter Break Begins", "2026-04-03", "2", "Holiday", "false", "Spring break for all students and staff."},
                {"Final Year Project Submission", "2026-05-15", "3", "Major", "true", "Deadline for all final year undergraduate projects."},
                {"Promotional Exams", "2026-06-22", "3", "Finals", "true", "Year-end promotional examinations."}
            };

            for (String[] d : defaults) {
                CalendarEvent e = new CalendarEvent();
                e.setTitle(d[0]);
                e.setDate(java.time.LocalDate.parse(d[1]));
                e.setTerm(Integer.parseInt(d[2]));
                e.setCategory(d[3]);
                e.setMajor(Boolean.parseBoolean(d[4]));
                e.setDescription(d[5]);
                sesh.persist(e);
            }
            sesh.getTransaction().commit();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
