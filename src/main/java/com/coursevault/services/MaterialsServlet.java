package com.coursevault.services;

import com.coursevault.model.Bookmark;
import com.coursevault.model.Resource;
import com.coursevault.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/materials/*")
public class MaterialsServlet extends HttpServlet {
    private ResourceService resourceService = ResourceService.getInstance();

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
            if ("ADMIN".equals(user.getRole())) {
                List<Resource> resources = resourceService.getAllResources();
                req.setAttribute("resources", resources);
            } else {
                List<Bookmark> bookmarks = resourceService.getBookmarksByUser(user.getId());
                req.setAttribute("bookmarks", bookmarks);
            }
            req.getRequestDispatcher("/materials.jsp").forward(req, resp);
        } else if (path.equals("/toggle-bookmark")) {
            try {
                long resourceId = Long.parseLong(req.getParameter("resourceId"));
                resourceService.toggleBookmark(user.getId(), resourceId);
                
                String requestedWith = req.getHeader("X-Requested-With");
                if ("XMLHttpRequest".equals(requestedWith)) {
                    resp.setContentType("text/plain");
                    resp.getWriter().write("success");
                } else {
                    String referer = req.getHeader("referer");
                    resp.sendRedirect(referer != null ? referer : req.getContextPath() + "/subjects/");
                }
            } catch (Exception e) {
                e.printStackTrace();
                resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                resp.getWriter().write(e.getMessage());
            }
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
}
