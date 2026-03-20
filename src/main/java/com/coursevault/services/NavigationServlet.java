package com.coursevault.services;

import com.coursevault.model.Bookmark;
import com.coursevault.model.Resource;
import com.coursevault.model.Subject;
import com.coursevault.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

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
        System.out.println("[NavigationServlet] Path: " + servletPath + ", User: " + (user != null ? user.getEmail() : "null"));

        if (servletPath.equals("/dashboard")) {
            // Fetch Dashboard Data
            try {
                System.out.println("[NavigationServlet] Fetching stats...");
                List<Subject> subjects = subjectService.getAllSubjects();
                List<Resource> resources = resourceService.getAllResources();
                List<Bookmark> bookmarks = resourceService.getBookmarksByUser(user.getId());
                
                req.setAttribute("subjectCount", subjects.size());
                req.setAttribute("resourceCount", resources.size());
                req.setAttribute("bookmarkCount", bookmarks.size());
                req.setAttribute("recentResources", resourceService.getRecentResources(3));
                
                System.out.println("[NavigationServlet] Forwarding to dashboard.jsp");
                req.getRequestDispatcher("/dashboard.jsp").forward(req, resp);
            } catch (Exception e) {
                System.err.println("[NavigationServlet] Dashboard Error: " + e.getMessage());
                e.printStackTrace();
                throw new ServletException(e);
            }
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
