package com.coursevault.services;

import com.coursevault.model.Bookmark;
import com.coursevault.model.Resource;
import com.coursevault.model.Subject;
import com.coursevault.model.User;
import com.coursevault.util.InputSanitizer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;

@WebServlet("/subjects/*")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50   // 50MB
)
public class SubjectServlet extends HttpServlet {
    private SubjectService subjectService = SubjectService.getInstance();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        if (path == null || path.equals("/")) {
            List<Subject> subjects = subjectService.getAllSubjects();
            req.setAttribute("subjects", subjects);
            req.getRequestDispatcher("/subjects_list.jsp").forward(req, resp);
        } else if (path.equals("/view")) {
            handleView(req, resp);
        } else if (path.equals("/delete")) {
            if (user != null && ("ADMIN".equals(user.getRole()) || "TEACHER".equals(user.getRole()))) {
                handleDelete(req, resp);
            } else resp.sendRedirect(req.getContextPath() + "/auth/login");
        } else if (path.equals("/resource/delete")) {
            if (user != null && ("ADMIN".equals(user.getRole()) || "TEACHER".equals(user.getRole()))) {
                handleResourceDelete(req, resp, user);
            } else resp.sendRedirect(req.getContextPath() + "/auth/login");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("user");
        if (user == null || (!user.getRole().equals("ADMIN") && !user.getRole().equals("TEACHER"))) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        if (path != null && path.equals("/add")) {
            handleAdd(req, resp);
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleAdd(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        String name = InputSanitizer.cleanText(req.getParameter("name"), 120);
        String iconClass = InputSanitizer.cleanIconClass(req.getParameter("iconClass"));
        String description = InputSanitizer.cleanText(req.getParameter("description"), 500);

        String title = InputSanitizer.cleanText(req.getParameter("resourceTitle"), 200);
        int year = InputSanitizer.parseIntInRange(req.getParameter("year"), 1990, 2100, 2023);
        int term = InputSanitizer.parseIntInRange(req.getParameter("term"), 1, 3, 1);
        String type = InputSanitizer.cleanResourceType(req.getParameter("type"));

        Part filePart = req.getPart("file");
        if (filePart == null || filePart.getSize() <= 0) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "File upload is required.");
            return;
        }
        String originalFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String lowerCase= originalFileName.toLowerCase();
        
        if (!lowerCase.matches(".*\\.(pdf|png|jpg|jpeg|docx|doc|pptx|ppt|xlsx|xls|txt|csv)$")) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid file type. Only documents and images are allowed.");
            return;
        }

        String fileName = originalFileName.replaceAll("[^a-zA-Z0-9._-]", "_");

        String userHome = System.getProperty("user.home");
        String uploadPath = userHome + File.separator + "CourseVaultUploads";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        String savedFileName = System.currentTimeMillis() + "_" + fileName;
        String absoluteFilePath = uploadPath + File.separator + savedFileName;
        filePart.write(absoluteFilePath);

        // Reuse existing subject if one with the same name already exists
        Subject subject = subjectService.getSubjectByName(name);
        if (subject == null) {
            subject = new Subject();
            subject.setName(name);
            subject.setIconClass(iconClass);
            subject.setDescription(description);
            subjectService.addSubject(subject);
        }

        Resource resource = new Resource();
        resource.setTitle(title);
        resource.setFilePath(savedFileName);
        resource.setYear(year);
        resource.setTerm(term);
        resource.setType(type);
        resource.setSubject(subject);

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        resource.setUploader(user);

        ResourceService.getInstance().addResource(resource);

        resp.sendRedirect(req.getContextPath() + "/subjects/");
    }


    private void handleView(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idStr = req.getParameter("id");
        if (idStr == null) {
            resp.sendRedirect(req.getContextPath() + "/subjects/");
            return;
        }
        
        long id = Long.parseLong(idStr);
        Subject subject = subjectService.getSubjectById(id);
        
        if (subject == null) {
            resp.sendRedirect(req.getContextPath() + "/subjects/");
            return;
        }
        
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user != null) {
            List<Bookmark> bookmarks = ResourceService.getInstance().getBookmarksByUser(user.getId());
            req.setAttribute("userBookmarks", bookmarks);
        }

        req.setAttribute("subject", subject);
        req.getRequestDispatcher("/subject_view.jsp").forward(req, resp);
    }

    private void handleDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String idStr = req.getParameter("id");
        if (idStr != null) {
            subjectService.deleteSubject(Long.parseLong(idStr));
        }
        resp.sendRedirect(req.getContextPath() + "/subjects/");
    }

    private void handleResourceDelete(HttpServletRequest req, HttpServletResponse resp, User user) throws IOException {
        String idStr = req.getParameter("id");
        if (idStr != null) {
            long resourceId = Long.parseLong(idStr);
            Resource res = ResourceService.getInstance().getResourceById(resourceId);
            if (res != null) {
                // Ensure only ADMIN or the teacher who uploaded it can delete it. Admin can delete anything.
                if ("ADMIN".equals(user.getRole()) || (res.getUploadedBy() != null && res.getUploadedBy().getId() == user.getId())) {
                    ResourceService.getInstance().deleteResource(resourceId);
                }
            }
        }
        
        String referer = req.getHeader("Referer");
        if (referer != null && !referer.isEmpty()) {
            resp.sendRedirect(referer);
        } else {
            resp.sendRedirect(req.getContextPath() + "/subjects/");
        }
    }
}
