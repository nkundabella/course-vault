package com.coursevault.services;

import com.coursevault.model.User;
import com.coursevault.model.CalendarEvent;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;

@WebServlet("/calendar/*")
public class CalendarServlet extends HttpServlet {
    private CalendarService calendarService = CalendarService.getInstance();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        if (path == null || path.equals("/")) {
            List<CalendarEvent> events = calendarService.getAllEvents();
            req.setAttribute("events", events);
            req.getRequestDispatcher("/calendar.jsp").forward(req, resp);
        } else if (path.equals("/delete")) {
            if ("ADMIN".equals(user.getRole()) || "TEACHER".equals(user.getRole())) {
                String idStr = req.getParameter("id");
                if (idStr != null) {
                    calendarService.deleteEvent(Long.parseLong(idStr));
                }
            }
            resp.sendRedirect(req.getContextPath() + "/calendar/");
        } else {
            resp.sendRedirect(req.getContextPath() + "/calendar/");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || (!"ADMIN".equals(user.getRole()) && !"TEACHER".equals(user.getRole()))) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        if (path != null && path.equals("/add")) {
            try {
                String title = com.coursevault.util.InputSanitizer.cleanText(req.getParameter("title"), 150);
                LocalDate date = LocalDate.parse(req.getParameter("date"));
                int term = Integer.parseInt(req.getParameter("term"));
                String category = req.getParameter("category");
                boolean major = req.getParameter("major") != null;
                String description = com.coursevault.util.InputSanitizer.cleanText(req.getParameter("description"), 500);

                CalendarEvent event = new CalendarEvent();
                event.setTitle(title);
                event.setDate(date);
                event.setTerm(term);
                event.setCategory(category);
                event.setMajor(major);
                event.setDescription(description);
                event.setUser(user);

                calendarService.addEvent(event);
            } catch (Exception e) {
                e.printStackTrace();
            }
            resp.sendRedirect(req.getContextPath() + "/calendar/");
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}
