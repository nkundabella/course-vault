<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>CourseVault | Timeline</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/index.css">
            <link rel="preconnect" href="https://fonts.googleapis.com">
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
            <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&display=swap"
                rel="stylesheet">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            <style>
                .timeline-container {
                    max-width: 800px;
                    margin-top: 2rem;
                    position: relative;
                }

                .timeline-container::before {
                    content: '';
                    position: absolute;
                    left: 25px;
                    top: 0;
                    bottom: 0;
                    width: 2px;
                    background: #F3F4F6;
                }

                .timeline-event {
                    position: relative;
                    padding-left: 70px;
                    margin-bottom: 3rem;
                }

                .event-dot {
                    position: absolute;
                    left: 17px;
                    top: 10px;
                    width: 18px;
                    height: 18px;
                    background: white;
                    border: 4px solid #F8C697;
                    border-radius: 50%;
                    z-index: 2;
                }

                .event-card {
                    background: white;
                    padding: 1.5rem;
                    border-radius: 20px;
                    border: 1px solid #F3F4F6;
                    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.02);
                    transition: transform 0.3s;
                }

                .event-card:hover {
                    transform: translateX(10px);
                    border-color: #F8C697;
                }

                .event-header {
                    display: flex;
                    justify-content: space-between;
                    margin-bottom: 0.8rem;
                }

                .event-type {
                    font-size: 0.75rem;
                    font-weight: 700;
                    color: #A68B5B;
                    text-transform: uppercase;
                }

                .event-card h3 {
                    margin: 0;
                    font-size: 1.1rem;
                    font-weight: 700;
                    color: #333;
                }

                .event-card p {
                    margin: 0.4rem 0 1rem 0;
                    font-size: 0.9rem;
                    color: #6B7280;
                }

                .event-footer {
                    display: flex;
                    align-items: center;
                    gap: 1rem;
                }

                .btn-event {
                    text-decoration: none;
                    font-size: 0.85rem;
                    font-weight: 600;
                    color: #A68B5B;
                    display: flex;
                    align-items: center;
                    gap: 0.4rem;
                }

                .btn-event:hover {
                    text-decoration: underline;
                }
            </style>
        </head>

        <body>
            <%@ include file="/WEB-INF/jspf/sidebar.jspf" %>

                <main class="main-viewport">
                    <header class="section-header" style="margin-bottom: 2rem;">
                        <h1 style="font-weight: 800; margin: 0;">Timeline</h1>
                        <p style="color: #6B7280; margin-top: 0.3rem;">Stay updated with the latest uploads and course
                            announcements.</p>
                    </header>

                    <div class="timeline-container">
                        <c:choose>
                            <c:when test="${not empty recentResources}">
                                <c:forEach items="${recentResources}" var="res">
                                    <div class="timeline-event animate__animated animate__fadeInLeft">
                                        <div class="event-dot"></div>
                                        <div class="event-card">
                                            <div class="event-header">
                                                <span class="event-type">New ${res.type} Added</span>
                                            </div>
                                            <h3>${res.title}</h3>
                                            <p>New materials have been released for
                                                <strong>${res.subject.name}</strong>. Access them now to stay ahead of
                                                your course work.</p>
                                            <div class="event-footer">
                                                <a href="${pageContext.request.contextPath}/subjects/view?id=${res.subject.id}"
                                                    class="btn-event">
                                                    <i class="fas fa-eye"></i> View Subject
                                                </a>
                                                <a href="${pageContext.request.contextPath}/download/${res.filePath}"
                                                    class="btn-event">
                                                    <i class="fas fa-download"></i> Quick Download
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div
                                    style="text-align: center; padding: 5rem; background: rgba(255,255,255,0.5); border-radius: 30px; border: 2px dashed #E5E7EB;">
                                    <i class="fas fa-clock"
                                        style="font-size: 3.5rem; color: #E5E7EB; margin-bottom: 1.5rem;"></i>
                                    <h2 style="color: #374151;">Quiet on the front...</h2>
                                    <p style="color: #6B7280;">No recent activities found. Check back later for new
                                        resources!</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </main>
        </body>

        </html>