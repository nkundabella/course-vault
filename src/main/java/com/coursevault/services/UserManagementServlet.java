package com.coursevault.services;

import com.coursevault.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/users/*")
public class UserManagementServlet extends HttpServlet {
    private UserService userService = UserService.getInstance();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"ADMIN".equals(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        List<User> pendingTeachers = userService.getUsersByRole("PENDING_TEACHER");
        req.setAttribute("pendingTeachers", pendingTeachers);
        req.getRequestDispatcher("/users.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null || !"ADMIN".equals(user.getRole())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String action = req.getParameter("action");
        String idStr = req.getParameter("userId");

        if (idStr != null && action != null) {
            long targetUserId = Long.parseLong(idStr);
            if ("approve".equals(action)) {
                userService.updateUserRole(targetUserId, "TEACHER");
            } else if ("decline".equals(action)) {
                userService.updateUserRole(targetUserId, "STUDENT");
            }
        }

        resp.sendRedirect(req.getContextPath() + "/users/");
    }
}
