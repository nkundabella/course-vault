<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <c:set var="user" value="${sessionScope.user}" />
        <c:if test="${empty user}">
            <c:redirect url="/auth/login" />
        </c:if>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>CourseVault | Dashboard</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/index.css">
            <link rel="preconnect" href="https://fonts.googleapis.com">
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
            <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&display=swap"
                rel="stylesheet">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            <script src="https://unpkg.com/@dotlottie/player-component@2.7.12/dist/dotlottie-player.mjs"
                type="module"></script>
            <style>
                .modal-overlay {
                    position: fixed;
                    top: 0;
                    left: 0;
                    width: 100%;
                    height: 100%;
                    background: rgba(0, 0, 0, 0.4);
                    backdrop-filter: blur(5px);
                    display: none;
                    align-items: center;
                    justify-content: center;
                    z-index: 1000;
                }

                .modal-content {
                    background: white;
                    padding: 2.5rem;
                    border-radius: 25px;
                    width: 450px;
                    box-shadow: 0 20px 50px rgba(0, 0, 0, 0.1);
                    animation: slideUp 0.4s ease-out;
                }

                @keyframes slideUp {
                    from {
                        opacity: 0;
                        transform: translateY(30px);
                    }

                    to {
                        opacity: 1;
                        transform: translateY(0);
                    }
                }

                .modal-header h3 {
                    margin: 0 0 1.5rem 0;
                    font-size: 1.5rem;
                    font-weight: 700;
                    color: #333;
                }

                .form-group {
                    margin-bottom: 1.2rem;
                }

                .form-group label {
                    display: block;
                    margin-bottom: 0.5rem;
                    font-weight: 600;
                    font-size: 0.9rem;
                }

                .form-group input,
                .form-group textarea {
                    width: 100%;
                    padding: 0.8rem;
                    border: 1px solid #E5E7EB;
                    border-radius: 12px;
                    outline: none;
                    transition: 0.3s;
                }

                .form-group input:focus {
                    border-color: #F8C697;
                }

                .modal-footer {
                    display: flex;
                    gap: 1rem;
                    margin-top: 2rem;
                }

                .btn-cancel {
                    flex: 1;
                    padding: 0.8rem;
                    border: 1px solid #E5E7EB;
                    border-radius: 12px;
                    font-weight: 600;
                    cursor: pointer;
                    background: #F9FAFB;
                }

                .btn-save {
                    flex: 1;
                    padding: 0.8rem;
                    background: #F8C697;
                    color: #333;
                    border: none;
                    border-radius: 12px;
                    font-weight: 700;
                    cursor: pointer;
                }

                /* Subject Card Style */
                .subject-card {
                    background: white;
                    padding: 1.5rem;
                    border-radius: 20px;
                    transition: transform 0.3s, box-shadow 0.3s;
                    cursor: pointer;
                    border: 1px solid #F3F4F6;
                    display: flex;
                    flex-direction: column;
                    gap: 0.8rem;
                }

                .subject-card:hover {
                    transform: translateY(-5px);
                    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.05);
                    border-color: #F8C697;
                }

                .card-icon {
                    width: 50px;
                    height: 50px;
                    background: #FFF9F2;
                    color: #A68B5B;
                    border-radius: 12px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-size: 1.5rem;
                }

                .card-title {
                    font-weight: 700;
                    font-size: 1.1rem;
                    color: #333;
                }

                .card-desc {
                    color: #6B7280;
                    font-size: 0.85rem;
                    line-height: 1.4;
                    height: 40px;
                    overflow: hidden;
                }

                /* Adjusted layout for Header Add button */
                .header-action-wrapper {
                    background: #F8C697;
                    padding: 0.6rem 1.2rem;
                    border-radius: 12px;
                    display: flex;
                    align-items: center;
                    gap: 0.8rem;
                    cursor: pointer;
                    transition: 0.3s;
                    color: #333;
                    font-weight: 700;
                    border: none;
                }

                .header-action-wrapper:hover {
                    background: #f6b579;
                    transform: scale(1.02);
                }
            </style>
        </head>

        <body>
            <%@ include file="/WEB-INF/jspf/sidebar.jspf" %>

                <main class="main-viewport">
                    <header class="header-top">
                        <div class="search-bar">
                            <i class="fas fa-search"></i>
                            <input type="text" placeholder="Search subjects, years, or terms...">
                        </div>
                        <div class="user-profile">
                            <span>${user.fullName} (${user.role})</span>
                            <img src="https://ui-avatars.com/api/?name=${user.fullName}&background=A68B5B&color=fff"
                                alt="Profile">
                        </div>
                    </header>

                    <section class="hero-card">
                        <div class="hero-text">
                            <c:choose>
                                <c:when test="${user.role eq 'ADMIN'}">
                                    <h2>Master Dashboard</h2>
                                    <p>Managing the future of education, one resource at a time.</p>
                                </c:when>
                                <c:otherwise>
                                    <h2>Hello ${user.fullName}</h2>
                                    <p>Ready to level up your skills today?</p>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="hero-animation">
                            <dotlottie-player
                                src="https://lottie.host/b4eed0cc-9e97-4523-8aa5-200e16dbb71a/P9xki3TI09.lottie"
                                style="width: 250px;height: 250px" autoplay loop></dotlottie-player>
                        </div>
                    </section>

                    <section class="subjects-section">
                        <h2 style="font-weight:700; margin-bottom:1.5rem;">Quick Access</h2>
                        <div class="grid-container" style="grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));">

                            <div class="subject-card" onclick="location.href='${pageContext.request.contextPath}/subjects/'" style="cursor:pointer;">
                                <div class="card-folder-tag">EXPLORE</div>
                                <div class="folder-icon"><i class="fas fa-book-open"></i></div>
                                <div class="folder-title">Subjects</div>
                                <div class="folder-desc">Browse all course subjects and their resources.</div>
                                <div class="folder-footer"><span>View Subjects &rarr;</span></div>
                            </div>

                            <div class="subject-card" onclick="location.href='${pageContext.request.contextPath}/materials/'" style="cursor:pointer;">
                                <div class="card-folder-tag">LIBRARY</div>
                                <div class="folder-icon"><i class="fas fa-file-alt"></i></div>
                                <div class="folder-title">Materials</div>
                                <div class="folder-desc">Access your notes, past papers and bookmarks.</div>
                                <div class="folder-footer"><span>View Materials &rarr;</span></div>
                            </div>

                            <div class="subject-card" onclick="location.href='${pageContext.request.contextPath}/timeline'" style="cursor:pointer;">
                                <div class="card-folder-tag">SCHEDULE</div>
                                <div class="folder-icon"><i class="fas fa-calendar-alt"></i></div>
                                <div class="folder-title">Timeline</div>
                                <div class="folder-desc">See your study timeline and upcoming deadlines.</div>
                                <div class="folder-footer"><span>View Timeline &rarr;</span></div>
                            </div>

                        </div>
                    </section>
                </main>


        </body>
        </html>