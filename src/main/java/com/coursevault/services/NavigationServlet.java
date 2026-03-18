package com.coursevault.services;

import com.coursevault.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet({"/settings", "/timeline/*"})
public class NavigationServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        String servletPath = req.getServletPath();
        if (servletPath.equals("/settings")) {
            req.getRequestDispatcher("/settings.jsp").forward(req, resp);
        } else if (servletPath.equals("/timeline")) {
            req.getRequestDispatcher("/timeline.jsp").forward(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/");
        }
    }
}
