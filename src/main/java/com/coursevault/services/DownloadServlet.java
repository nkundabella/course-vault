package com.coursevault.services;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet("/download/*")
public class DownloadServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Authenticate user
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String pathInfo = req.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        String decodedPath = java.net.URLDecoder.decode(pathInfo, "UTF-8");
        String normalizedPath = decodedPath.replace("\\", "/");
        while (normalizedPath.startsWith("/")) {
            normalizedPath = normalizedPath.substring(1);
        }

        // Handle legacy paths (if database still has "uploads/xxx.pdf")
        if (normalizedPath.startsWith("uploads/")) {
             normalizedPath = normalizedPath.substring(8); // remove "uploads/"
        }

        // Get permanent upload directory
        String userHome = System.getProperty("user.home");
        String uploadPath = userHome + File.separator + "CourseVaultUploads";
        
        String systemPath = normalizedPath.replace("/", File.separator);
        String fullPath = uploadPath + File.separator + systemPath;
        
        System.out.println("DEBUG: DownloadServlet - Requested File: " + normalizedPath);
        System.out.println("DEBUG: DownloadServlet - fullPath to search: " + fullPath);

        File file = new File(fullPath);
        if (!file.exists()) {
            System.err.println("ERROR: File not found at: " + fullPath);
            resp.sendError(HttpServletResponse.SC_NOT_FOUND, "The requested resource could not be found. Looked in: " + fullPath);
            return;
        }

        String fileName = file.getName();
        if (fileName.contains("_")) {
            fileName = fileName.substring(fileName.indexOf("_") + 1);
        }

        String mimeType = getServletContext().getMimeType(fullPath);
        if (mimeType == null) {
            String lowercaseName = fileName.toLowerCase();
            if (lowercaseName.endsWith(".pdf")) mimeType = "application/pdf";
            else if (lowercaseName.endsWith(".jpg") || lowercaseName.endsWith(".jpeg")) mimeType = "image/jpeg";
            else if (lowercaseName.endsWith(".png")) mimeType = "image/png";
            else mimeType = "application/octet-stream";
        }

        resp.setContentType(mimeType);
        resp.setContentLength((int) file.length());

        String mode = req.getParameter("mode");
        if ("view".equalsIgnoreCase(mode)) {
            resp.setHeader("Content-Disposition", "inline; filename=\"" + fileName + "\"");
        } else {
            String encodedFileName = URLEncoder.encode(fileName, StandardCharsets.UTF_8).replace("+", "%20");
            resp.setHeader("Content-Disposition", "attachment; filename*=UTF-8''" + encodedFileName);
        }

        try (FileInputStream inStream = new FileInputStream(file);
             OutputStream outStream = resp.getOutputStream()) {
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = inStream.read(buffer)) != -1) {
                outStream.write(buffer, 0, bytesRead);
            }
        }
    }
}
