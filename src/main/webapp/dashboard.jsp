<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CourseVault | Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/index.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .dashboard-grid {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 2rem;
            margin-top: 1rem;
        }

        .welcome-banner {
            background: linear-gradient(135deg, #F8C697 0%, #A68B5B 100%);
            padding: 3rem;
            border-radius: 30px;
            color: #333;
            position: relative;
            overflow: hidden;
            box-shadow: 0 15px 35px rgba(166, 139, 91, 0.2);
            margin-bottom: 2rem;
        }

        .welcome-banner h1 {
            font-size: 2.5rem;
            font-weight: 800;
            margin: 0;
            color: #fff;
            text-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .welcome-banner p {
            font-size: 1.1rem;
            opacity: 0.9;
            margin-top: 0.5rem;
            color: #fff;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: white;
            padding: 2rem;
            border-radius: 25px;
            text-align: center;
            border: 1px solid #F3F4F6;
            transition: transform 0.3s;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            border-color: #F8C697;
        }

        .stat-card i {
            font-size: 2rem;
            color: #A68B5B;
            margin-bottom: 1rem;
        }

        .stat-card h3 {
            font-size: 2.2rem;
            font-weight: 800;
            margin: 0;
            color: #333;
        }

        .stat-card p {
            color: #6B7280;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.75rem;
            letter-spacing: 1px;
            margin-top: 0.3rem;
        }

        .recent-activity {
            background: white;
            padding: 2rem;
            border-radius: 25px;
            border: 1px solid #F3F4F6;
        }

        .recent-activity h2 {
            font-size: 1.3rem;
            font-weight: 700;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.8rem;
        }

        .activity-item {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 1rem 0;
            border-bottom: 1px solid #F9FAFB;
        }

        .activity-item:last-child { border-bottom: none; }

        .activity-icon {
            width: 45px;
            height: 45px;
            background: #FFF7ED;
            color: #F97316;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
        }

        .activity-details h4 {
            margin: 0;
            font-size: 0.95rem;
            color: #374151;
        }

        .activity-details p {
            margin: 0;
            font-size: 0.8rem;
            color: #9CA3AF;
        }

        .quick-actions {
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }

        .action-btn {
            background: white;
            padding: 1.2rem;
            border-radius: 20px;
            border: 1px solid #F3F4F6;
            display: flex;
            align-items: center;
            gap: 1rem;
            text-decoration: none;
            color: #374151;
            font-weight: 600;
            transition: all 0.3s;
        }

        .action-btn:hover {
            background: #F9FAFB;
            border-color: #A68B5B;
            transform: translateX(5px);
        }

        .action-btn i {
            width: 35px;
            height: 35px;
            background: #F3F4F6;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #A68B5B;
        }
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/jspf/sidebar.jspf" %>
    
    <main class="main-viewport">
        <div class="welcome-banner">
            <div style="position: relative; z-index: 2;">
                <h1>Hello, ${user.fullName}!</h1>
                <p>Welcome back to your academic vault. Here's what's happening today.</p>
            </div>
            <i class="fas fa-graduation-cap" style="position:absolute; right: -20px; bottom: -20px; font-size: 15rem; color: rgba(255,255,255,0.1); transform: rotate(-15deg);"></i>
        </div>

        <div class="stats-grid">
            <div class="stat-card">
                <i class="fas fa-book"></i>
                <h3>${subjectCount}</h3>
                <p>Subjects</p>
            </div>
            <div class="stat-card">
                <i class="fas fa-file-alt"></i>
                <h3>${resourceCount}</h3>
                <p>Resources</p>
            </div>
            <div class="stat-card">
                <i class="fas fa-star"></i>
                <h3>${bookmarkCount}</h3>
                <p>Bookmarks</p>
            </div>
        </div>

        <div class="dashboard-grid">
            <div class="recent-activity">
                <h2><i class="fas fa-bolt"></i> Recent Uploads</h2>
                <c:choose>
                    <c:when test="${not empty recentResources}">
                        <c:forEach items="${recentResources}" var="res">
                            <div class="activity-item">
                                <div class="activity-icon">
                                    <i class="fas fa-file-pdf"></i>
                                </div>
                                <div class="activity-details">
                                    <h4>${res.title}</h4>
                                    <p>Added to <strong>${res.subject.name}</strong></p>
                                </div>
                                <div style="margin-left:auto;">
                                    <a href="${pageContext.request.contextPath}/subjects/view?id=${res.subject.id}" class="btn-event" style="color: #A68B5B; font-size: 0.8rem; text-decoration: none; font-weight: 700;">VIEW</a>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <p style="color: #9CA3AF; text-align: center; padding: 2rem;">No recent materials yet.</p>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="quick-actions">
                <h2 style="font-size: 1.3rem; font-weight: 700; margin-bottom: 0.5rem;">Quick Access</h2>
                <a href="${pageContext.request.contextPath}/subjects/" class="action-btn">
                    <i class="fas fa-layer-group"></i> Explore Subjects
                </a>
                <a href="${pageContext.request.contextPath}/materials" class="action-btn">
                    <i class="fas fa-bookmarks"></i> My Materials
                </a>
                <a href="${pageContext.request.contextPath}/calendar/" class="action-btn">
                    <i class="fas fa-calendar-alt"></i> Academic Calendar
                </a>
                <a href="${pageContext.request.contextPath}/settings" class="action-btn">
                    <i class="fas fa-cog"></i> Account Settings
                </a>
            </div>
        </div>
    </main>
</body>
</html>
