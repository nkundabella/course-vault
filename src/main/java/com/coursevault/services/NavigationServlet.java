package com.coursevault.services;

import com.coursevault.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet({"/dashboard", "/settings", "/timeline/*"})
public class NavigationServlet extends HttpServlet {
    private SubjectService subjectService = SubjectService.getInstance();
    private ResourceService resourceService = ResourceService.getInstance();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        String servletPath = req.getServletPath();
        if (servletPath.equals("/dashboard")) {
            // Fetch Dashboard Data
            req.setAttribute("subjectCount", subjectService.getAllSubjects().size());
            req.setAttribute("resourceCount", resourceService.getAllResources().size());
            req.setAttribute("bookmarkCount", resourceService.getBookmarksByUser(user.getId()).size());
            req.setAttribute("recentResources", resourceService.getRecentResources(3)); // Get top 3
            
            req.getRequestDispatcher("/dashboard.jsp").forward(req, resp);
        } else if (servletPath.equals("/settings")) {
            req.getRequestDispatcher("/settings.jsp").forward(req, resp);
        } else if (servletPath.equals("/timeline")) {
            req.setAttribute("recentResources", resourceService.getRecentResources(10));
            req.setAttribute("upcomingEvents", CalendarService.getInstance().getAllEvents());
            req.getRequestDispatcher("/timeline.jsp").forward(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/");
        }
    }
}
