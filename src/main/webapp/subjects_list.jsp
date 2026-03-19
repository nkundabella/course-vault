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
            <title>CourseVault | Subjects</title>
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
                            <span>${user.fullName} (${user.role eq 'PENDING_TEACHER' ? 'Pending Teacher' : user.role})</span>
                            <img src="https://ui-avatars.com/api/?name=${user.fullName}&background=A68B5B&color=fff"
                                alt="Profile">
                        </div>
                    </header>


                    <section class="subjects-section">
                        <div
                            style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem;">
                            <h2 style="font-weight: 700;">Explore Subjects</h2>
                            <c:if test="${user.role eq 'ADMIN' or user.role eq 'TEACHER'}">
                                <button class="header-action-wrapper" onclick="openModal()">
                                    <i class="fas fa-plus"></i>
                                    <span>Add Subject</span>
                                </button>
                            </c:if>
                        </div>

                        <div class="grid-container" id="subjects-grid">
                            <c:choose>
                                <c:when test="${not empty subjects}">
                                    <c:forEach items="${subjects}" var="s">
                                        <div class="subject-card animate__animated animate__fadeInUp"
                                            onclick="location.href='${pageContext.request.contextPath}/subjects/view?id=${s.id}'">
                                            <div class="card-folder-tag">SUBJECT</div>
                                            <div class="folder-icon">
                                                <i class="${not empty s.iconClass ? s.iconClass : 'fas fa-folder'}"></i>
                                            </div>
                                            <div class="folder-title">${s.name}</div>
                                            <div class="folder-desc">
                                                ${not empty s.description ? s.description : 'Explore curriculum
                                                resources, notes and past papers for this unit.'}
                                            </div>
                                            <div class="folder-footer">
                                                <span>View Content</span>
                                                <c:if test="${user.role eq 'ADMIN' or user.role eq 'TEACHER'}">
                                                    <a href="${pageContext.request.contextPath}/subjects/delete?id=${s.id}"
                                                        style="color: #ffbaba;" title="Delete"
                                                        onclick="event.stopPropagation()">
                                                        <i class="fas fa-trash-alt"></i>
                                                    </a>
                                                </c:if>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <div
                                        style="grid-column: 1 / -1; text-align: center; padding: 4rem; background: rgba(255,255,255,0.5); border-radius: 20px; border: 2px dashed #A68B5B;">
                                        <i class="fas fa-folder-open"
                                            style="font-size: 3rem; color: #A68B5B; margin-bottom: 1rem;"></i>
                                        <h3>No subjects found</h3>
                                        <p>${(user.role eq 'ADMIN' or user.role eq 'TEACHER') ? 'Start by creating your first subject above!' :
                                            'Come
                                            back later when the admins have uploaded resources.'}</p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </section>
                </main>

                <!-- Add Subject Modal -->
                <div class="modal-overlay" id="addSubjectModal">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h3>Create New Subject</h3>
                        </div>
                        <form action="${pageContext.request.contextPath}/subjects/add" method="POST"
                            enctype="multipart/form-data">
                            <div style="display: flex; gap: 1rem;">
                                <div class="form-group" style="flex: 1;">
                                    <label>Subject Name</label>
                                    <input type="text" id="subjectNameInput" name="name" list="subjectSuggestions"
                                        placeholder="Start typing subject..." required autocomplete="off">
                                    <datalist id="subjectSuggestions">
                                        <option value="Data Structures & Algorithms">
                                        <option value="JAVA">
                                        <option value="Applied Physics">
                                        <option value="English">
                                        <option value="Applied Mathematics">
                                        <option value="Embedded Systems">
                                        <option value="Advanced Database">
                                        <option value="3D Models">
                                        <option value="Advanced Networking">
                                        <option value="Web3 Applications Development">
                                        <option value="Software Engineering">
                                        <option value="Ikinyarwanda">
                                        <option value="Entrepreneurship">
                                        <option value="Citizenship">
                                    </datalist>
                                </div>
                                <div class="form-group" style="flex: 1;">
                                    <label>Icon Class</label>
                                    <input type="text" id="iconClassInput" name="iconClass" placeholder="fas fa-book"
                                        value="fas fa-book">
                                </div>
                            </div>

                            <div class="form-group">
                                <label>Description</label>
                                <textarea name="description" rows="2" placeholder="Brief course overview..."></textarea>
                            </div>

                            <hr style="border: 0; border-top: 1px solid #eee; margin: 1.5rem 0;">
                            <div class="modal-header" style="margin-bottom: 1rem;">
                                <h3 style="font-size: 1.2rem;">Initial Resource</h3>
                            </div>

                            <div class="form-group">
                                <label>Resource Title</label>
                                <input type="text" name="resourceTitle" placeholder="Fallacies" required>
                            </div>

                            <div style="display: flex; gap: 1rem;">
                                <div class="form-group" style="flex: 1;">
                                    <label>Year</label>
                                    <input type="number" name="year" value="2023" required>
                                </div>
                                <div class="form-group" style="flex: 1;">
                                    <label>Term</label>
                                    <select name="term" required>
                                        <option value="1">Term 1</option>
                                        <option value="2">Term 2</option>
                                        <option value="3">Term 3</option>
                                    </select>
                                </div>
                                <div class="form-group" style="flex: 1;">
                                    <label>Type</label>
                                    <select name="type" required>
                                        <option value="NOTES">Notes</option>
                                        <option value="PAST_PAPER">Past Paper</option>
                                    </select>
                                </div>
                            </div>

                            <div class="form-group">
                                <label>Upload File</label>
                                <input type="file" name="file" required>
                            </div>

                            <div class="modal-footer">
                                <button type="button" class="btn-cancel" onclick="closeModal()">Cancel</button>
                                <button type="submit" class="btn-save">Save All</button>
                            </div>
                        </form>
                    </div>
                </div>

                <script>
                    function openModal() {
                        document.getElementById('addSubjectModal').style.display = 'flex';
                    }
                    function closeModal() {
                        document.getElementById('addSubjectModal').style.display = 'none';
                    }
                    // Close modal when clicking outside
                    window.onclick = function (event) {
                        let modal = document.getElementById('addSubjectModal');
                        if (event.target == modal) {
                            closeModal();
                        }
                    }

                    // Smart Icon Mapping
                    const iconMap = {
                        "Data Structures & Algorithms": "fas fa-sitemap",
                        "JAVA": "fab fa-java",
                        "Applied Physics": "fas fa-atom",
                        "English": "fas fa-language",
                        "Applied Mathematics": "fas fa-square-root-variable",
                        "Embedded Systems": "fas fa-microchip",
                        "Advanced Database": "fas fa-database",
                        "3D Models": "fas fa-cubes",
                        "Advanced Networking": "fas fa-network-wired",
                        "Web3 Applications Development": "fas fa-link",
                        "Software Engineering": "fas fa-laptop-code",
                        "Ikinyarwanda": "fas fa-comments",
                        "Entrepreneurship": "fas fa-lightbulb",
                        "Citizenship": "fas fa-hands-holding-child"
                    };

                    document.getElementById('subjectNameInput').addEventListener('input', function (e) {
                        const val = e.target.value;
                        if (iconMap[val]) {
                            document.getElementById('iconClassInput').value = iconMap[val];
                        }
                    });
                </script>
        </body>

        </html>