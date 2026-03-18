package com.coursevault.services;

import com.coursevault.model.User;
import com.coursevault.model.CalendarEvent;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/calendar/*")
public class CalendarServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        // Placeholder for calendar fetching logic
        req.getRequestDispatcher("/calendar.jsp").forward(req, resp);
    }
}
