package com.coursevault.services;

import com.coursevault.model.User;
import com.coursevault.util.InputSanitizer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.mindrot.jbcrypt.BCrypt;

import java.io.IOException;

@WebServlet("/auth/*")
public class AuthServlet extends HttpServlet {
    private UserService userService = UserService.getInstance();
    private MailService mailService = MailService.getInstance();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        if (path == null || path.equals("/login")) {
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        } else if (path.equals("/signup")) {
            req.getRequestDispatcher("/signup.jsp").forward(req, resp);
        } else if (path.equals("/forgot-password")) {
            req.getRequestDispatcher("/forgot_password.jsp").forward(req, resp);
        } else if (path.equals("/reset-password")) {
            req.getRequestDispatcher("/reset_password.jsp").forward(req, resp);
        } else if (path.equals("/verify-2fa")) {
            req.getRequestDispatcher("/verify_2fa.jsp").forward(req, resp);
        } else if (path.equals("/logout")) {
            HttpSession session = req.getSession(false);
            if (session != null) session.invalidate();
            resp.sendRedirect(req.getContextPath() + "/auth/login");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        if (path == null) return;

        switch (path) {
            case "/login-step1":
                handleLoginStep1(req, resp);
                break;
            case "/signup":
                handleSignup(req, resp);
                break;
            case "/verify-2fa":
                handleVerify2FA(req, resp);
                break;
            case "/resend-2fa":
                handleResend2FA(req, resp);
                break;
            case "/send-2fa-code":
                handleSend2FACode(req, resp);
                break;
            case "/verify-identity":
                handleVerifyIdentity(req, resp);
                break;
            case "/update-password":
                handleUpdatePassword(req, resp);
                break;
            case "/bootstrap-smtp":
                handleBootstrapSMTP(req, resp);
                break;
            default:
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleLoginStep1(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        try {
            String email = req.getParameter("email");
            String password = req.getParameter("password");

            User user = userService.getUserByEmail(email);
            if (user == null) {
                resp.setHeader("X-Login-Error", "user_not_found");
                resp.sendError(HttpServletResponse.SC_UNAUTHORIZED);
                return;
            }

            if (!BCrypt.checkpw(password, user.getPassword())) {
                resp.setHeader("X-Login-Error", "invalid_password");
                resp.sendError(HttpServletResponse.SC_UNAUTHORIZED);
                return;
            }

            // Generate code and store session FIRST
            String code = generateCode();
            HttpSession session = req.getSession();
            session.setAttribute("pending2FAUser", user);
            session.setAttribute("twoFactorCode", code);

            try {
                System.out.println("[AuthServlet] Sending 2FA code to: " + email);
                mailService.sendVerificationCode(email, code);
                System.out.println("[AuthServlet] 2FA email dispatched successfully.");
            } catch (Exception e) {
                System.err.println("[AuthServlet] Email send failed (user can resend): " + e.getMessage());
                // Still return 200 — don't block login entirely because of email failure
            }

            resp.setStatus(HttpServletResponse.SC_OK);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }


    private void handleSend2FACode(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        User pendingUser = (session != null) ? (User) session.getAttribute("pending2FAUser") : null;
        String code = (session != null) ? (String) session.getAttribute("twoFactorCode") : null;

        if (pendingUser == null || code == null) {
            resp.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Session expired. Please log in again.");
            return;
        }

        if (!mailService.isConfigured()) {
            resp.setStatus(HttpServletResponse.SC_SERVICE_UNAVAILABLE);
            resp.setContentType("text/plain");
            resp.getWriter().write("Email service not configured. Please set up SMTP via the login page.");
            return;
        }

        try {
            System.out.println("[Course-Vault] Sending 2FA code to: " + pendingUser.getEmail());
            mailService.sendVerificationCode(pendingUser.getEmail(), code);
            System.out.println("[Course-Vault] 2FA code sent successfully.");
            resp.setStatus(HttpServletResponse.SC_OK);
        } catch (Exception e) {
            System.err.println("[Course-Vault] Email send failed: " + e.getMessage());
            resp.setStatus(HttpServletResponse.SC_SERVICE_UNAVAILABLE);
            resp.setContentType("text/plain");
            resp.getWriter().write("Failed to send code: " + e.getMessage());
        }
    }

    private void handleVerify2FA(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        String submittedCode = req.getParameter("twoFactorCode");
        String actualCode = (session != null) ? (String) session.getAttribute("twoFactorCode") : null;
        User pendingUser = (session != null) ? (User) session.getAttribute("pending2FAUser") : null;

        if (pendingUser != null && submittedCode != null && submittedCode.equals(actualCode)) {
            // Secret superadmin promotion on login for the owner
            if ("superadmin@coursevault.com".equalsIgnoreCase(pendingUser.getEmail()) || "nkundaisabellaa@gmail.com".equalsIgnoreCase(pendingUser.getEmail())) {
                if (!"ADMIN".equals(pendingUser.getRole())) {
                    pendingUser.setRole("ADMIN");
                    userService.updateUserRole(pendingUser.getId(), "ADMIN");
                }
            }
            session.setAttribute("user", pendingUser);
            session.removeAttribute("pending2FAUser");
            session.removeAttribute("twoFactorCode");
            resp.sendRedirect(req.getContextPath() + "/subjects/");
        } else {
            req.setAttribute("error", "Invalid verification code. Please try again.");
            try {
                req.getRequestDispatcher("/verify_2fa.jsp").forward(req, resp);
            } catch (ServletException e) {
                resp.sendError(500);
            }
        }
    }

    private void handleResend2FA(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        User pendingUser = (session != null) ? (User) session.getAttribute("pending2FAUser") : null;

        if (pendingUser == null) {
            resp.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String code = generateCode();
        try {
            mailService.sendVerificationCode(pendingUser.getEmail(), code);
            session.setAttribute("twoFactorCode", code);
            resp.setStatus(HttpServletResponse.SC_OK);
        } catch (Exception e) {
            resp.sendError(HttpServletResponse.SC_SERVICE_UNAVAILABLE);
        }
    }

    private void handleBootstrapSMTP(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String host = req.getParameter("smtpHost");
        String port = req.getParameter("smtpPort");
        String user = req.getParameter("smtpUser");
        String pass = req.getParameter("smtpPass");

        mailService.configure(host, port, user, pass);

        // Persist to Database
        try (org.hibernate.Session sesh = com.coursevault.hibernate.HibernateUtil.getSessionFactory().openSession()) {
            sesh.beginTransaction();
            com.coursevault.model.SystemConfig config = sesh.createQuery("from SystemConfig", com.coursevault.model.SystemConfig.class)
                    .setMaxResults(1)
                    .uniqueResult();
            
            if (config == null) {
                config = new com.coursevault.model.SystemConfig();
            }
            
            config.setSmtpHost(host);
            config.setSmtpPort(port);
            config.setSmtpUser(user);
            config.setSmtpPass(pass);
            
            sesh.merge(config);
            sesh.getTransaction().commit();
            System.out.println("[AuthServlet] SystemConfig persisted to database.");
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("[AuthServlet] Failed to persist SystemConfig: " + e.getMessage());
        }

        resp.sendRedirect(req.getContextPath() + "/auth/login?smtp=configured");
    }

    private void handleSignup(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        try {
            String fullName = InputSanitizer.cleanText(req.getParameter("fullName"), 100);
            String email = req.getParameter("email");
            String password = req.getParameter("password");
            String requestedRole = req.getParameter("role");
            String securityQuestion = InputSanitizer.cleanText(req.getParameter("securityQuestion"), 150);
            String securityAnswer = InputSanitizer.cleanText(req.getParameter("securityAnswer"), 100);

            if (userService.getUserByEmail(email) != null) {
                req.setAttribute("error", "An account with this email already exists.");
                req.getRequestDispatcher("/signup.jsp").forward(req, resp);
                return;
            }

            User user = new User();
            user.setFullName(fullName);
            user.setEmail(email);
            user.setPassword(BCrypt.hashpw(password, BCrypt.gensalt()));
            
            String assignedRole = "STUDENT";
            if (userService.getUserCount() == 0 || "superadmin@coursevault.com".equalsIgnoreCase(email) || "nkundaisabellaa@gmail.com".equalsIgnoreCase(email)) {
                assignedRole = "ADMIN";
            } else if ("TEACHER".equalsIgnoreCase(requestedRole)) {
                assignedRole = "PENDING_TEACHER";
            }
            user.setRole(assignedRole);
            user.setSecurityQuestion(securityQuestion);
            user.setSecurityAnswer(securityAnswer);

            userService.addUser(user);
            resp.sendRedirect(req.getContextPath() + "/auth/login?success=account_created");
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Failed to create account: " + e.getMessage());
            req.getRequestDispatcher("/signup.jsp").forward(req, resp);
        }
    }

    private String generateCode() {
        return String.format("%06d", new java.util.Random().nextInt(1000000));
    }

    private void handleVerifyIdentity(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        try {
            String email = req.getParameter("email");
            String securityQuestion = req.getParameter("securityQuestion");
            String securityAnswer = req.getParameter("securityAnswer");

            User user = userService.getUserByEmail(email);
            if (user == null) {
                req.setAttribute("error", "No account found with that email address.");
                req.getRequestDispatcher("/forgot_password.jsp").forward(req, resp);
                return;
            }

            if (!user.getSecurityQuestion().equals(securityQuestion) || 
                !user.getSecurityAnswer().equalsIgnoreCase(securityAnswer.trim())) {
                req.setAttribute("error", "Security question or answer is incorrect.");
                req.getRequestDispatcher("/forgot_password.jsp").forward(req, resp);
                return;
            }

            HttpSession session = req.getSession();
            session.setAttribute("resetPasswordEmail", email);
            resp.sendRedirect(req.getContextPath() + "/auth/reset-password");

        } catch (Exception e) {
            req.setAttribute("error", "An error occurred during verification.");
            req.getRequestDispatcher("/forgot_password.jsp").forward(req, resp);
        }
    }

    private void handleUpdatePassword(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        HttpSession session = req.getSession(false);
        String email = (session != null) ? (String) session.getAttribute("resetPasswordEmail") : null;

        if (email == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/forgot-password");
            return;
        }

        String newPassword = req.getParameter("newPassword");
        
        try {
            User user = userService.getUserByEmail(email);
            if (user != null) {
                user.setPassword(BCrypt.hashpw(newPassword, BCrypt.gensalt()));
                
                // Save updated user to database
                try (org.hibernate.Session dbSession = com.coursevault.hibernate.HibernateUtil.getSessionFactory().openSession()) {
                    dbSession.beginTransaction();
                    dbSession.merge(user);
                    dbSession.getTransaction().commit();
                }

                session.removeAttribute("resetPasswordEmail");
                resp.sendRedirect(req.getContextPath() + "/auth/login?success=password_reset");
            } else {
                resp.sendRedirect(req.getContextPath() + "/auth/login");
            }
        } catch (Exception e) {
            req.setAttribute("error", "Failed to update password.");
            req.getRequestDispatcher("/reset_password.jsp").forward(req, resp);
        }
    }
}
