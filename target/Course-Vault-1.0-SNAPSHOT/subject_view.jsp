<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>CourseVault | ${subject.name}</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/index.css">
            <link rel="preconnect" href="https://fonts.googleapis.com">
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
            <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&display=swap"
                rel="stylesheet">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            <style>
                .resource-list {
                    display: flex;
                    flex-direction: column;
                    gap: 1.5rem;
                    margin-top: 2rem;
                }

                .resource-item {
                    background: white;
                    padding: 1.5rem;
                    border-radius: 20px;
                    display: flex;
                    align-items: center;
                    justify-content: space-between;
                    border: 1px solid #F3F4F6;
                    transition: transform 0.3s, box-shadow 0.3s;
                }

                .resource-item:hover {
                    transform: translateX(10px);
                    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.05);
                    border-color: #F8C697;
                }

                .resource-info {
                    display: flex;
                    align-items: center;
                    gap: 1.5rem;
                }

                .resource-icon {
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

                .resource-meta h3 {
                    margin: 0;
                    font-size: 1.1rem;
                    font-weight: 700;
                    color: #333;
                }

                .resource-meta p {
                    margin: 0.2rem 0 0 0;
                    font-size: 0.85rem;
                    color: #6B7280;
                }

                .btn-download {
                    padding: 0.7rem 1.5rem;
                    background: #F8C697;
                    color: #333;
                    border-radius: 12px;
                    text-decoration: none;
                    font-weight: 700;
                    font-size: 0.9rem;
                    transition: 0.3s;
                    display: flex;
                    align-items: center;
                    gap: 0.5rem;
                }

                .btn-download:hover {
                    background: #f6b579;
                    transform: scale(1.05);
                }

                .back-link {
                    display: inline-flex;
                    align-items: center;
                    gap: 0.5rem;
                    text-decoration: none;
                    color: #6B7280;
                    font-weight: 600;
                    margin-bottom: 2rem;
                    transition: 0.3s;
                }

                .back-link:hover {
                    color: #333;
                    transform: translateX(-5px);
                }

                .type-badge {
                    padding: 0.3rem 0.8rem;
                    background: #F3F4F6;
                    border-radius: 20px;
                    font-size: 0.75rem;
                    font-weight: 700;
                    text-transform: uppercase;
                    color: #374151;
                }

                .bookmark-toggle {
                    color: #D1D5DB;
                    font-size: 1.2rem;
                    cursor: pointer;
                    transition: all 0.3s ease;
                }

                .bookmark-toggle:hover {
                    color: #F8C697;
                    transform: scale(1.1);
                }

                .bookmark-toggle.active {
                    color: #F8C697;
                }
            </style>
        </head>

        <body>
            <%@ include file="/WEB-INF/jspf/sidebar.jspf" %>
            <input type="hidden" id="contextPath" value="${pageContext.request.contextPath}">

                <main class="main-viewport">
                    <a href="${pageContext.request.contextPath}/subjects/" class="back-link">
                        <i class="fas fa-arrow-left"></i>
                        Back to Subjects
                    </a>

                    <div class="subject-header"
                        style="display: flex; align-items: center; gap: 1.5rem; margin-bottom: 3rem;">
                        <div class="card-icon" style="width: 70px; height: 70px; font-size: 2rem;">
                            <i class="${not empty subject.iconClass ? subject.iconClass : 'fas fa-book'}"></i>
                        </div>
                        <div>
                            <h1 style="font-weight: 800; margin: 0;">${subject.name}</h1>
                            <p style="color: #6B7280; margin: 0.3rem 0 0 0;">${subject.description}</p>
                        </div>
                    </div>

                    <div class="resource-list">
                        <c:choose>
                            <c:when test="${not empty subject.resources}">
                                <c:forEach items="${subject.resources}" var="res">
                                    <div class="resource-item animate__animated animate__fadeInUp">
                                        <div class="resource-info">
                                            <div class="resource-icon">
                                                <i
                                                    class="${res.type eq 'NOTES' ? 'fas fa-file-alt' : 'fas fa-file-contract'}"></i>
                                            </div>
                                            <div class="resource-meta">
                                                <div style="display: flex; align-items: center; gap: 0.8rem;">
                                                    <h3>${res.title}</h3>
                                                    <c:if test="${user.role ne 'ADMIN'}">
                                                        <c:set var="isBookmarked" value="false" />
                                                        <c:forEach items="${userBookmarks}" var="ub">
                                                            <c:if test="${ub.resource.id eq res.id}">
                                                                <c:set var="isBookmarked" value="true" />
                                                            </c:if>
                                                        </c:forEach>
                                                        <div class="bookmark-toggle ${isBookmarked ? 'active' : ''} js-bookmark-toggle" 
                                                             data-resource-id="${res.id}"
                                                             title="${isBookmarked ? 'Remove from My Materials' : 'Add to My Materials'}">
                                                            <i class="${isBookmarked ? 'fas' : 'far'} fa-bookmark"></i>
                                                        </div>
                                                    </c:if>
                                                </div>
                                                <p>Year ${res.year} | Term ${res.term} | <span
                                                        class="type-badge">${res.type}</span></p>
                                            </div>
                                        </div>
                                        <div class="resource-actions" style="display: flex; gap: 0.8rem;">
                                            <button class="btn-download js-preview-btn" 
                                                    data-url="${pageContext.request.contextPath}/download/${res.filePath}?mode=view"
                                                    data-title="${res.title}"
                                                    style="background: #F3F4F6; color: #374151; border:none; cursor:pointer;">
                                                <i class="fas fa-eye"></i>
                                                View
                                            </button>
                                            <a href="${pageContext.request.contextPath}/download/${res.filePath}"
                                                class="btn-download">
                                                <i class="fas fa-download"></i>
                                                Download
                                            </a>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div
                                    style="text-align: center; padding: 4rem; background: rgba(255,255,255,0.5); border-radius: 20px; border: 2px dashed #A68B5B;">
                                    <i class="fas fa-ghost"
                                        style="font-size: 3rem; color: #A68B5B; margin-bottom: 1rem;"></i>
                                    <p>No resources have been uploaded for this subject yet.</p>
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
                    function toggleStar(el, resourceId) {
                        const contextPath = document.getElementById('contextPath').value;
                        fetch(contextPath + '/materials/toggle-bookmark?resourceId=' + resourceId, {
                            headers: { 'X-Requested-With': 'XMLHttpRequest' }
                        }).then(res => {
                            if (res.ok) {
                                el.classList.toggle('active');
                                const icon = el.querySelector('i');
                                if (el.classList.contains('active')) {
                                    icon.className = 'fas fa-bookmark';
                                } else {
                                    icon.className = 'far fa-bookmark';
                                }
                            }
                        });
                    }

                    // Attach listeners to avoid inline onclick lint errors
                    document.addEventListener('DOMContentLoaded', () => {
                        document.querySelectorAll('.js-bookmark-toggle').forEach(btn => {
                            btn.addEventListener('click', function() {
                                toggleStar(this, this.dataset.resourceId);
                            });
                        });
                        document.querySelectorAll('.js-preview-btn').forEach(btn => {
                            btn.addEventListener('click', function() {
                                previewResource(this.dataset.url, this.dataset.title);
                            });
                        });
                    });
                </script>
        </body>

        </html>