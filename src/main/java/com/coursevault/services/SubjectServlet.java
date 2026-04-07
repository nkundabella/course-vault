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
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) {
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
            if (user != null && ("TEACHER".equals(user.getRole()) || "ADMIN".equals(user.getRole()))) {
                handleResourceDelete(req, resp, user);
            } else resp.sendRedirect(req.getContextPath() + "/auth/login");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getPathInfo();
        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("user");
        if (user == null || (!user.getRole().equals("ADMIN") && !user.getRole().equals("TEACHER") && !user.getRole().equals("STUDENT"))) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        if (path != null && path.equals("/add")) {
            if (!user.getRole().equals("ADMIN") && !user.getRole().equals("TEACHER")) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Only teachers can create subjects.");
                return;
            }
            handleAdd(req, resp);
        } else if (path != null && path.equals("/resource/add")) {
            handleResourceAdd(req, resp, user);
        } else if (path != null && path.equals("/resource/edit")) {
            if (!user.getRole().equals("ADMIN") && !user.getRole().equals("TEACHER")) {
                 // Students might edit their own group presentations? 
                 // User said "editing is only done by the one that uploaded it".
                 // So we can let them edit if they are the uploader.
            }
            handleResourceEdit(req, resp, user);
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void handleAdd(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        String name = InputSanitizer.cleanText(req.getParameter("name"), 120);
        String iconClass = InputSanitizer.cleanIconClass(req.getParameter("iconClass"));
        String description = InputSanitizer.cleanText(req.getParameter("description"), 500);

        String title = InputSanitizer.cleanText(req.getParameter("resourceTitle"), 200);
        int year = InputSanitizer.parseIntInRange(req.getParameter("year"), 1, 3, 1);
        int term = InputSanitizer.parseIntInRange(req.getParameter("term"), 1, 3, 1);
        String type = InputSanitizer.cleanResourceType(req.getParameter("type"));
        
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        if (user == null) {
            resp.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        // Enforcement: Role-based Resource Type restrictions
        if ("STUDENT".equals(user.getRole())) {
            if (!"GROUP_PRESENTATION".equals(type) && !"OTHER".equals(type)) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Students can only upload Group Presentations or Other resources.");
                return;
            }
        } else if ("TEACHER".equals(user.getRole())) {
             if ("GROUP_PRESENTATION".equals(type)) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Teachers cannot upload Group Presentations. These are for students.");
                return;
             }
        }

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

        String fileHash = calculateFileHash(filePart);
        Resource existing = ResourceService.getInstance().getResourceByHash(fileHash);
        if (existing != null) {
            // Delete the file we just saved to save space
            new File(absoluteFilePath).delete();
            resp.sendError(HttpServletResponse.SC_CONFLICT, "This resource already exists in Course-Vault (Title: " + existing.getTitle() + " in " + existing.getSubject().getName() + "). Redundancy is not allowed!");
            return;
        }

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
        resource.setUploader(user);
        resource.setFileHash(fileHash);

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

    private void handleResourceEdit(HttpServletRequest req, HttpServletResponse resp, User user) throws IOException {
        String idStr = req.getParameter("resourceId");
        if (idStr == null) {
            resp.sendRedirect(req.getContextPath() + "/subjects/");
            return;
        }

        long resourceId = Long.parseLong(idStr);
        Resource res = ResourceService.getInstance().getResourceById(resourceId);
        if (res == null) {
            resp.sendRedirect(req.getContextPath() + "/subjects/");
            return;
        }

        if (res.getUploader() == null || res.getUploader().getId() != user.getId()) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "You can only edit resources you uploaded.");
            return;
        }

        String title = InputSanitizer.cleanText(req.getParameter("title"), 200);
        int year = InputSanitizer.parseIntInRange(req.getParameter("year"), 1, 3, 1);
        int term = InputSanitizer.parseIntInRange(req.getParameter("term"), 1, 3, 1);
        String type = InputSanitizer.cleanResourceType(req.getParameter("type"));

        res.setTitle(title);
        res.setYear(year);
        res.setTerm(term);
        res.setType(type);

        ResourceService.getInstance().updateResource(res);

        String referer = req.getHeader("Referer");
        if (referer != null && !referer.isEmpty()) {
            resp.sendRedirect(referer);
        } else {
            resp.sendRedirect(req.getContextPath() + "/subjects/");
        }
    }

    private void handleResourceDelete(HttpServletRequest req, HttpServletResponse resp, User user) throws IOException {
        String idStr = req.getParameter("id");
        if (idStr != null) {
            long resourceId = Long.parseLong(idStr);
            Resource res = ResourceService.getInstance().getResourceById(resourceId);
            if (res != null) {
                if (!"ADMIN".equals(user.getRole()) && (res.getUploader() == null || res.getUploader().getId() != user.getId())) {
                    resp.sendError(HttpServletResponse.SC_FORBIDDEN, "You can only delete resources you uploaded.");
                    return;
                }
                ResourceService.getInstance().deleteResource(resourceId);
            }
        }
        
        String referer = req.getHeader("Referer");
        if (referer != null && !referer.isEmpty()) {
            resp.sendRedirect(referer);
        } else {
            resp.sendRedirect(req.getContextPath() + "/subjects/");
        }
    }

    private void handleResourceAdd(HttpServletRequest req, HttpServletResponse resp, User user) throws IOException, ServletException {
        long subjectId = Long.parseLong(req.getParameter("subjectId"));
        Subject subject = subjectService.getSubjectById(subjectId);
        if (subject == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Subject not found.");
            return;
        }

        String title = InputSanitizer.cleanText(req.getParameter("title"), 200);
        int year = InputSanitizer.parseIntInRange(req.getParameter("year"), 1, 3, 1);
        int term = InputSanitizer.parseIntInRange(req.getParameter("term"), 1, 3, 1);
        String type = InputSanitizer.cleanResourceType(req.getParameter("type"));

        // Enforcement: Role-based Resource Type restrictions
        if ("STUDENT".equals(user.getRole())) {
            if (!"GROUP_PRESENTATION".equals(type) && !"OTHER".equals(type)) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Students can only upload Group Presentations or Other resources.");
                return;
            }
        } else if ("TEACHER".equals(user.getRole())) {
             if ("GROUP_PRESENTATION".equals(type)) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "Teachers cannot upload Group Presentations. These are for students.");
                return;
             }
        }

        Part filePart = req.getPart("file");
        if (filePart == null || filePart.getSize() <= 0) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "File is required.");
            return;
        }

        String originalFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String fileName = originalFileName.replaceAll("[^a-zA-Z0-9._-]", "_");
        String savedFileName = System.currentTimeMillis() + "_" + fileName;

        String userHome = System.getProperty("user.home");
        String uploadPath = userHome + File.separator + "CourseVaultUploads";
        String absoluteFilePath = uploadPath + File.separator + savedFileName;
        filePart.write(absoluteFilePath);

        String fileHash = calculateFileHash(filePart);
        Resource existing = ResourceService.getInstance().getResourceByHash(fileHash);
        if (existing != null) {
            new File(absoluteFilePath).delete();
            resp.sendError(HttpServletResponse.SC_CONFLICT, "This file already exists in Course-Vault.");
            return;
        }

        Resource res = new Resource();
        res.setTitle(title);
        res.setFilePath(savedFileName);
        res.setYear(year);
        res.setTerm(term);
        res.setType(type);
        res.setSubject(subject);
        res.setUploader(user);
        res.setFileHash(fileHash);

        ResourceService.getInstance().addResource(res);
        resp.sendRedirect(req.getContextPath() + "/subjects/view?id=" + subjectId);
    }

    private String calculateFileHash(Part filePart) throws IOException {
        try {
            java.security.MessageDigest digest = java.security.MessageDigest.getInstance("SHA-256");
            try (java.io.InputStream is = filePart.getInputStream()) {
                byte[] buffer = new byte[8192];
                int read;
                while ((read = is.read(buffer)) != -1) {
                    digest.update(buffer, 0, read);
                }
            }
            byte[] hashBytes = digest.digest();
            java.util.Formatter formatter = new java.util.Formatter();
            for (byte b : hashBytes) {
                formatter.format("%02x", b);
            }
            String result = formatter.toString();
            formatter.close();
            return result;
        } catch (java.security.NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }
    }
}
