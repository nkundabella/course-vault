package com.coursevault.services;

import com.coursevault.model.Bookmark;
import com.coursevault.model.Resource;
import com.coursevault.model.Subject;
import com.coursevault.model.SystemConfig;
import com.coursevault.model.User;
import com.coursevault.util.InputSanitizer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;
import java.util.List;

@WebServlet({"/dashboard", "/settings", "/timeline/*"})
public class NavigationServlet extends HttpServlet {
    private SubjectService subjectService = SubjectService.getInstance();
    private ResourceService resourceService = ResourceService.getInstance();
    private UserService userService = UserService.getInstance();
    private ConfigService configService = ConfigService.getInstance();

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
            req.setAttribute("config", configService.getConfig());
            req.setAttribute("totalUsers", userService.getUserCount());
            req.setAttribute("adminCount", userService.getUsersByRole("ADMIN").size());
            req.getRequestDispatcher("/settings.jsp").forward(req, resp);
        } else if (servletPath.equals("/timeline")) {
            req.setAttribute("recentResources", resourceService.getRecentResources(10));
            req.setAttribute("upcomingEvents", CalendarService.getInstance().getAllEvents());
            req.getRequestDispatcher("/timeline.jsp").forward(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        String action = req.getParameter("action");
        if (action == null) {
            resp.sendRedirect(req.getContextPath() + "/settings");
            return;
        }

        try {
            switch (action) {
                case "updateProfile":
                    handleUpdateProfile(req, resp, user);
                    break;
                case "changePassword":
                    handleChangePassword(req, resp, user);
                    break;
                case "updateSecurity":
                    handleUpdateSecurity(req, resp, user);
                    break;
                case "updateSmtp":
                    handleUpdateSmtp(req, resp, user);
                    break;
                default:
                    resp.sendRedirect(req.getContextPath() + "/settings");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/settings?error=1");
        }
    }

    private void handleUpdateProfile(HttpServletRequest req, HttpServletResponse resp, User user) throws IOException {
        String fullName = InputSanitizer.cleanText(req.getParameter("fullName"), 100);
        user.setFullName(fullName);
        userService.updateUser(user);
        req.getSession().setAttribute("user", user);
        resp.sendRedirect(req.getContextPath() + "/settings?success=profile");
    }

    private void handleChangePassword(HttpServletRequest req, HttpServletResponse resp, User user) throws IOException {
        String newPass = req.getParameter("newPassword");
        String confirmPass = req.getParameter("confirmPassword");

        if (newPass != null && !newPass.isEmpty() && newPass.equals(confirmPass)) {
            user.setPassword(BCrypt.hashpw(newPass, BCrypt.gensalt()));
            userService.updateUser(user);
            resp.sendRedirect(req.getContextPath() + "/settings?success=password");
        } else {
            resp.sendRedirect(req.getContextPath() + "/settings?error=password_mismatch");
        }
    }

    private void handleUpdateSecurity(HttpServletRequest req, HttpServletResponse resp, User user) throws IOException {
        String question = InputSanitizer.cleanText(req.getParameter("securityQuestion"), 150);
        String answer = InputSanitizer.cleanText(req.getParameter("securityAnswer"), 100);

        if (question != null && !question.isEmpty()) {
            user.setSecurityQuestion(question);
        }
        if (answer != null && !answer.isEmpty()) {
            user.setSecurityAnswer(answer);
        }
        
        userService.updateUser(user);
        req.getSession().setAttribute("user", user);
        resp.sendRedirect(req.getContextPath() + "/settings?success=security");
    }

    private void handleUpdateSmtp(HttpServletRequest req, HttpServletResponse resp, User user) throws IOException {
        if (!"ADMIN".equals(user.getRole())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        SystemConfig config = configService.getConfig();
        config.setSmtpHost(req.getParameter("smtpHost"));
        config.setSmtpPort(req.getParameter("smtpPort"));
        config.setSmtpUser(req.getParameter("smtpUser"));
        
        String pass = req.getParameter("smtpPass");
        if (pass != null && !pass.isEmpty()) {
            config.setSmtpPass(pass);
        }

        configService.updateConfig(config);

        MailService.getInstance().configure(config.getSmtpHost(), config.getSmtpPort(), config.getSmtpUser(), config.getSmtpPass());
        
        resp.sendRedirect(req.getContextPath() + "/settings?success=smtp");
    }
}
