<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>CourseVault | My Materials</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/index.css">
            <link rel="preconnect" href="https://fonts.googleapis.com">
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
            <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&display=swap"
                rel="stylesheet">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            <style>
                .materials-grid {
                    display: grid;
                    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
                    gap: 1.5rem;
                    margin-top: 2rem;
                }

                .material-card {
                    background: white;
                    padding: 1.5rem;
                    border-radius: 20px;
                    border: 1px solid #F3F4F6;
                    display: flex;
                    flex-direction: column;
                    gap: 1rem;
                    transition: transform 0.3s, box-shadow 0.3s;
                    position: relative;
                }

                .material-card:hover {
                    transform: translateY(-5px);
                    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.05);
                    border-color: #F8C697;
                }

                .card-header {
                    display: flex;
                    justify-content: space-between;
                    align-items: flex-start;
                }

                .subject-tag {
                    font-size: 0.7rem;
                    font-weight: 700;
                    color: #A68B5B;
                    text-transform: uppercase;
                    background: #FFF9F2;
                    padding: 0.3rem 0.6rem;
                    border-radius: 8px;
                }

                .btn-unbookmark {
                    color: #F8C697;
                    cursor: pointer;
                    font-size: 1.2rem;
                    transition: 0.3s;
                }

                .btn-unbookmark:hover {
                    color: #f6b579;
                    transform: scale(1.2);
                }

                .material-card h3 {
                    margin: 0;
                    font-size: 1.1rem;
                    font-weight: 700;
                    color: #333;
                }

                .material-card p {
                    margin: 0;
                    font-size: 0.85rem;
                    color: #6B7280;
                }

                .card-actions {
                    margin-top: auto;
                    display: flex;
                    gap: 1rem;
                }

                .btn-action {
                    flex: 1;
                    padding: 0.7rem;
                    text-align: center;
                    border-radius: 12px;
                    text-decoration: none;
                    font-weight: 700;
                    font-size: 0.8rem;
                    transition: 0.3s;
                }

                .btn-view {
                    background: #F3F4F6;
                    color: #374151;
                }

                .btn-dl {
                    background: #F8C697;
                    color: #333;
                }
            </style>
        </head>

        <body>
            <%@ include file="/WEB-INF/jspf/sidebar.jspf" %>
                <main class="main-viewport">
                    <input type="hidden" id="contextPath" value="${pageContext.request.contextPath}">
                    <header class="header-top">
                        <div class="search-bar">
                            <i class="fas fa-search"></i>
                            <input type="text" placeholder="Search your materials...">
                        </div>
                        <div class="user-profile">
                            <span>${user.fullName} (${user.role eq 'PENDING_TEACHER' ? 'Pending Teacher' : user.role})</span>
                            <img src="https://ui-avatars.com/api/?name=${user.fullName}&background=A68B5B&color=fff"
                                alt="Profile">
                        </div>
                    </header>

                    <header class="section-header" style="margin-bottom: 2rem; margin-top: 1rem;">
                        <h1 style="font-weight: 800; margin: 0;">${(user.role.toUpperCase().trim() eq 'ADMIN' or user.role.toUpperCase().trim() eq 'TEACHER') ? 'My
                            Uploaded Resources' : 'My Materials'}</h1>
                        <p style="color: #6B7280; margin-top: 0.3rem;">
                            ${(user.role.toUpperCase().trim() eq 'ADMIN' or user.role.toUpperCase().trim() eq 'TEACHER') ? 'Manage the content you have contributed to
                            Course-Vault.' : 'Your personal bookmarks and saved resources.'}
                        </p>
                    </header>

                    <div class="materials-grid">
                        <c:choose>
                            <c:when test="${(user.role.toUpperCase().trim() eq 'ADMIN' or user.role.toUpperCase().trim() eq 'TEACHER') && not empty resources}">
                                <c:forEach items="${resources}" var="r">
                                    <div class="material-card animate__animated animate__fadeInUp">
                                        <div class="card-header">
                                            <span class="subject-tag">${r.subject.name}</span>
                                        </div>
                                        <h3>${r.title}</h3>
                                        <p>Year ${r.year} | ${r.type}</p>
                                        <div class="card-actions">
                                            <c:set var="lowPath" value="${fn:toLowerCase(r.filePath)}" />
                                            <c:if test="${fn:endsWith(lowPath, '.pdf') || fn:endsWith(lowPath, '.png') || fn:endsWith(lowPath, '.jpg') || fn:endsWith(lowPath, '.jpeg')}">
                                                <button class="btn-action btn-view js-preview-btn" 
                                                        data-url="${pageContext.request.contextPath}/download/${r.filePath}?mode=view"
                                                        data-title="${r.title}">View</button>
                                            </c:if>
                                            <a href="${pageContext.request.contextPath}/download/${r.filePath}"
                                                class="btn-action btn-dl">Download</a>
                                            <a href="${pageContext.request.contextPath}/subjects/resource/delete?id=${r.id}"
                                                class="btn-action" style="background: #FEF2F2; color: #DC2626; border-color: #FECACA;" 
                                                onclick="return confirm('Delete this resource permanently?');">Delete</a>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:when test="${(user.role.toUpperCase().trim() ne 'ADMIN' and user.role.toUpperCase().trim() ne 'TEACHER') && not empty bookmarks}">
                                <c:forEach items="${bookmarks}" var="b">
                                    <div class="material-card animate__animated animate__fadeInUp">
                                        <div class="card-header">
                                            <span class="subject-tag">${b.resource.subject.name}</span>
                                            <a href="${pageContext.request.contextPath}/materials/toggle-bookmark?resourceId=${b.resource.id}"
                                                class="btn-unbookmark">
                                                <i class="fas fa-bookmark"></i>
                                            </a>
                                        </div>
                                        <h3>${b.resource.title}</h3>
                                        <p>Year ${b.resource.year} | ${b.resource.type}</p>
                                        <div class="card-actions">
                                            <c:set var="lowPath" value="${fn:toLowerCase(b.resource.filePath)}" />
                                            <c:if test="${fn:endsWith(lowPath, '.pdf') || fn:endsWith(lowPath, '.png') || fn:endsWith(lowPath, '.jpg') || fn:endsWith(lowPath, '.jpeg')}">
                                                <button class="btn-action btn-view js-preview-btn" 
                                                        data-url="${pageContext.request.contextPath}/download/${b.resource.filePath}?mode=view"
                                                        data-title="${b.resource.title}">View</button>
                                            </c:if>
                                            <a href="${pageContext.request.contextPath}/download/${b.resource.filePath}"
                                                class="btn-action btn-dl">Download</a>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div
                                    style="grid-column: 1 / -1; text-align: center; padding: 5rem; background: rgba(255,255,255,0.5); border-radius: 30px; border: 2px dashed #E5E7EB;">
                                    <i class="fas ${(user.role eq 'ADMIN' or user.role eq 'TEACHER') ? 'fa-upload' : 'fa-bookmark'}"
                                        style="font-size: 3.5rem; color: #E5E7EB; margin-bottom: 1.5rem;"></i>
                                    <h2 style="color: #374151;">${(user.role eq 'ADMIN' or user.role eq 'TEACHER') ? "You haven't uploaded anything"
                                        : "No bookmarks yet"}</h2>
                                    <p style="color: #6B7280; max-width: 400px; margin: 0.5rem auto;">
                                        ${(user.role eq 'ADMIN' or user.role eq 'TEACHER') ? 'Contribute to the vault by adding resources in the
                                        Subjects section!' : 'Explore subjects and bookmark the notes you want to keep
                                        handy!'}
                                    </p>
                                    <a href="${pageContext.request.contextPath}/subjects/" class="btn-dl"
                                        style="display: inline-block; width: auto; padding: 0.8rem 2rem; margin-top: 2rem; border-radius: 12px; font-weight: 700; text-decoration: none;">Explore
                                        Subjects</a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </main>

                <!-- Preview Modal -->
                <div id="previewModal" class="modal-overlay" style="display:none;">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h2 id="previewTitle">Resource Preview</h2>
                            <button onclick="closePreview()" class="close-btn">&times;</button>
                        </div>
                        <div class="modal-body">
                            <iframe id="previewFrame" src="" frameborder="0"></iframe>
                        </div>
                    </div>
                </div>

                <style>
                    .modal-overlay {
                        position: fixed;
                        top: 0;
                        left: 0;
                        width: 100%;
                        height: 100%;
                        background: rgba(0,0,0,0.6);
                        backdrop-filter: blur(5px);
                        display: flex;
                        align-items: center;
                        justify-content: center;
                        z-index: 1000;
                        padding: 2rem;
                    }
                    .modal-content {
                        background: white;
                        width: 100%;
                        max-width: 1000px;
                        height: 90vh;
                        border-radius: 20px;
                        display: flex;
                        flex-direction: column;
                        overflow: hidden;
                    }
                    .modal-header {
                        padding: 1.5rem 2rem;
                        background: #FAF9F6;
                        border-bottom: 1px solid #eee;
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                    }
                    .close-btn { background: none; border: none; font-size: 2rem; cursor: pointer; color: #666; }
                    .modal-body { flex-grow: 1; }
                    #previewFrame { width: 100%; height: 100%; }
                </style>

                <script>
                    function previewResource(url, title) {
                        document.getElementById('previewTitle').textContent = title;
                        document.getElementById('previewFrame').src = url;
                        document.getElementById('previewModal').style.display = 'flex';
                        document.body.style.overflow = 'hidden';
                    }
                    function closePreview() {
                        document.getElementById('previewModal').style.display = 'none';
                        document.getElementById('previewFrame').src = '';
                        document.body.style.overflow = 'auto';
                    }

                    // Attach listeners to avoid inline onclick lint errors
                    document.addEventListener('DOMContentLoaded', () => {
                        document.querySelectorAll('.js-preview-btn').forEach(btn => {
                            btn.addEventListener('click', function() {
                                previewResource(this.dataset.url, this.dataset.title);
                            });
                        });
                    });
                </script>
        </body>

        </html>