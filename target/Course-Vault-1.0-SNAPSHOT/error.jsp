<%@ page contentType="text/html;charset=UTF-8" language="java" isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>CourseVault | System Error</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/index.css">
    <style>
        body { background: #f9fafb; padding: 2rem; font-family: sans-serif; }
        .error-card { background: white; padding: 2.5rem; border-radius: 20px; box-shadow: 0 10px 30px rgba(0,0,0,0.05); max-width: 900px; margin: 0 auto; }
        .error-header { color: #b91c1c; margin-bottom: 1rem; border-bottom: 2px solid #fee2e2; padding-bottom: 1rem; }
        .stack-trace { background: #fee2e2; color: #991b1b; padding: 1.5rem; border-radius: 12px; font-family: monospace; overflow-x: auto; font-size: 0.9rem; white-space: pre-wrap; }
        .btn-back { display: inline-block; margin-top: 2rem; padding: 0.8rem 1.5rem; background: #333; color: white; border-radius: 12px; text-decoration: none; font-weight: 700; }
    </style>
</head>
<body>
    <div class="error-card">
        <div class="error-header">
            <h1><i class="fas fa-exclamation-triangle"></i> System Error</h1>
            <p>An unexpected error occurred while processing your request.</p>
        </div>
        
        <h3>Error Details:</h3>
        <p><b>Message:</b> ${exception.message}</p>
        <p><b>Type:</b> ${exception.getClass().name}</p>
        
        <div class="stack-trace">
            <% 
                if (exception != null) {
                    exception.printStackTrace(new java.io.PrintWriter(out));
                } else if (request.getAttribute("jakarta.servlet.error.exception") != null) {
                    ((Throwable)request.getAttribute("jakarta.servlet.error.exception")).printStackTrace(new java.io.PrintWriter(out));
                } else {
                    out.print("No stack trace available. Check server logs.");
                }
            %>
        </div>
        
        <a href="${pageContext.request.contextPath}/auth/login" class="btn-back">Return to Login</a>
    </div>
</body>
</html>
