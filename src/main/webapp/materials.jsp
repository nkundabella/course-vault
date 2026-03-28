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
            <script src="https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.11.174/pdf.min.js"></script>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/mammoth/1.6.0/mammoth.browser.min.js"></script>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>
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

                /* Filter Bar Styles */
                .filter-bar {
                    background: white;
                    padding: 1.2rem;
                    border-radius: 20px;
                    display: flex;
                    flex-wrap: wrap;
                    gap: 1rem;
                    align-items: center;
                    margin-bottom: 2rem;
                    border: 1px solid #F3F4F6;
                    box-shadow: 0 4px 15px rgba(0,0,0,0.02);
                }

                .filter-group {
                    display: flex;
                    align-items: center;
                    gap: 0.8rem;
                    flex: 1;
                    min-width: 180px;
                }

                .filter-group label {
                    font-weight: 700;
                    font-size: 0.8rem;
                    color: #374151;
                    white-space: nowrap;
                    text-transform: uppercase;
                    letter-spacing: 0.5px;
                }

                .filter-control {
                    width: 100%;
                    padding: 0.6rem 0.8rem;
                    border: 1px solid #E5E7EB;
                    border-radius: 10px;
                    outline: none;
                    font-family: 'Outfit', sans-serif;
                    font-size: 0.85rem;
                    transition: 0.3s;
                    background: #F9FAFB;
                }

                .filter-control:focus {
                    border-color: #F8C697;
                    background: white;
                }

                .filter-results-info {
                    margin-bottom: 1rem;
                    font-size: 0.85rem;
                    color: #6B7280;
                    display: flex;
                    justify-content: space-between;
                    align-items: center;
                }
            </style>
        </head>

        <body>
            <%@ include file="/WEB-INF/jspf/sidebar.jspf" %>
                <main class="main-viewport">
                    <input type="hidden" id="contextPath" value="${pageContext.request.contextPath}">
                    <header class="header-top">
                        <div style="flex: 1;"></div>
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

                    <!-- Filter Bar -->
                    <div class="filter-bar animate__animated animate__fadeIn">
                        <div class="filter-group" style="flex: 1.5;">
                            <label><i class="fas fa-search"></i></label>
                            <input type="text" id="searchInput" class="filter-control" placeholder="Search by title...">
                        </div>
                        <div class="filter-group">
                            <label>Subject</label>
                            <select id="subjectFilter" class="filter-control">
                                <option value="all">All Subjects</option>
                            </select>
                        </div>
                        <div class="filter-group">
                            <label>Year</label>
                            <select id="yearFilter" class="filter-control">
                                <option value="all">All Years</option>
                                <option value="1">Year 1</option>
                                <option value="2">Year 2</option>
                                <option value="3">Year 3</option>
                            </select>
                        </div>
                        <div class="filter-group">
                            <label>Type</label>
                            <select id="typeFilter" class="filter-control">
                                <option value="all">All Types</option>
                                <option value="NOTES">Lecture Note</option>
                                <option value="PAST_PAPER">Past Paper</option>
                                <option value="GROUP_PRESENTATION">Group Presentation</option>
                                <option value="OTHER">Other</option>
                            </select>
                        </div>
                    </div>

                    <div class="filter-results-info">
                        <span id="resultsCount">Loading materials...</span>
                        <button onclick="resetFilters()" style="background:none; border:none; color:#A68B5B; cursor:pointer; font-weight:700; font-size:0.8rem;">
                            <i class="fas fa-undo"></i> Reset Filters
                        </button>
                    </div>

                    <div class="materials-grid">
                        <c:choose>
                            <c:when test="${(user.role.toUpperCase().trim() eq 'ADMIN' or user.role.toUpperCase().trim() eq 'TEACHER') && not empty resources}">
                                <c:forEach items="${resources}" var="r">
                                    <div class="material-card animate__animated animate__fadeInUp"
                                         data-title="${fn:toLowerCase(r.title)}" 
                                         data-subject="${r.subject.name}" 
                                         data-year="${r.year}" 
                                         data-type="${fn:toUpperCase(r.type)}">
                                        <div class="card-header">
                                            <span class="subject-tag">${r.subject.name}</span>
                                        </div>
                                        <h3>${r.title}</h3>
                                        <p>Year ${r.year} | ${r.type}</p>
                                        <div class="card-actions">
                                            <c:set var="lowPath" value="${fn:toLowerCase(r.filePath)}" />
                                            <c:if test="${fn:endsWith(lowPath, '.pdf') || fn:endsWith(lowPath, '.docx') || fn:endsWith(lowPath, '.doc') || fn:endsWith(lowPath, '.txt') || fn:endsWith(lowPath, '.png') || fn:endsWith(lowPath, '.jpg') || fn:endsWith(lowPath, '.jpeg') || fn:endsWith(lowPath, '.xlsx') || fn:endsWith(lowPath, '.xls') || fn:endsWith(lowPath, '.csv') || fn:endsWith(lowPath, '.pptx')}">
                                                <button class="btn-action btn-view js-preview-btn" 
                                                        data-url="${pageContext.request.contextPath}/download/${r.filePath}?mode=view"
                                                        data-title="${r.title}"
                                                        data-filename="${r.filePath}">View</button>
                                            </c:if>
                                             <c:if test="${r.uploader.id eq user.id}">
                                                <button class="btn-action" onclick="openEditModal('${r.id}', '${r.title}', '${r.year}', '${r.term}', '${r.type}')" 
                                                        style="background: #FFF7ED; color: #EA580C; border:none; cursor:pointer;">Edit</button>
                                             </c:if>
                                             <a href="${pageContext.request.contextPath}/download/${r.filePath}"
                                                 class="btn-action btn-dl">Download</a>
                                             <c:if test="${r.uploader.id eq user.id}">
                                                <a href="${pageContext.request.contextPath}/subjects/resource/delete?id=${r.id}"
                                                    class="btn-action" style="background: #FEF2F2; color: #DC2626; border-color: #FECACA;" 
                                                    onclick="return confirm('Are you sure you want to delete this resource permanently?');">Delete</a>
                                             </c:if>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:when test="${(user.role.toUpperCase().trim() ne 'ADMIN' and user.role.toUpperCase().trim() ne 'TEACHER') && not empty bookmarks}">
                                <c:forEach items="${bookmarks}" var="b">
                                    <div class="material-card animate__animated animate__fadeInUp"
                                         data-title="${fn:toLowerCase(b.resource.title)}" 
                                         data-subject="${b.resource.subject.name}" 
                                         data-year="${b.resource.year}" 
                                         data-type="${fn:toUpperCase(b.resource.type)}">
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
                                            <c:if test="${fn:endsWith(lowPath, '.pdf') || fn:endsWith(lowPath, '.docx') || fn:endsWith(lowPath, '.doc') || fn:endsWith(lowPath, '.txt') || fn:endsWith(lowPath, '.png') || fn:endsWith(lowPath, '.jpg') || fn:endsWith(lowPath, '.jpeg') || fn:endsWith(lowPath, '.xlsx') || fn:endsWith(lowPath, '.xls') || fn:endsWith(lowPath, '.csv') || fn:endsWith(lowPath, '.pptx')}">
                                                <button class="btn-action btn-view js-preview-btn" 
                                                        data-url="${pageContext.request.contextPath}/download/${b.resource.filePath}?mode=view"
                                                        data-title="${b.resource.title}"
                                                        data-filename="${b.resource.filePath}">View</button>
                                            </c:if>
                                             <c:if test="${b.resource.uploader.id eq user.id}">
                                                 <button class="btn-action" onclick="openEditModal('${b.resource.id}', '${b.resource.title}', '${b.resource.year}', '${b.resource.term}', '${b.resource.type}')" 
                                                         style="background: #FFF7ED; color: #EA580C; border:none; cursor:pointer;">Edit</button>
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
                        <div class="modal-body" id="previewBody">
                            <iframe id="previewFrame" src="" frameborder="0" style="display:none;"></iframe>
                            <div id="pdfViewer" style="display:none; height:100%; overflow:auto; background:#525659; padding:20px; display: flex; flex-direction: column; align-items: center; gap: 20px;"></div>
                            <div id="docxViewer" style="display:none; height:100%; overflow:auto; background:white; padding:40px;"></div>
                            <div id="xlsxViewer" style="display:none; height:100%; overflow:auto; background:white; padding:20px;"></div>
                        </div>
                    </div>
                </div>

                <!-- Edit Resource Modal -->
                <div id="editModal" class="preview-modal" style="display: none;">
                    <div class="modal-content" style="width: 450px; height: auto; max-height: 90vh;">
                        <div class="modal-header">
                            <h2>Edit Resource</h2>
                            <button onclick="closeEditModal()" class="close-btn">&times;</button>
                        </div>
                        <div class="modal-body" style="padding: 2rem;">
                            <form action="${pageContext.request.contextPath}/subjects/resource/edit" method="POST">
                                <input type="hidden" id="editResourceId" name="resourceId">
                                <div class="form-group" style="margin-bottom: 1.5rem;">
                                    <label style="display:block; margin-bottom:0.5rem; font-weight:600;">Resource Title</label>
                                    <input type="text" id="editTitle" name="title" required 
                                           style="width:100%; padding:0.8rem; border:1px solid #E5E7EB; border-radius:12px;">
                                </div>
                                <div style="display:grid; grid-template-columns:1fr 1fr; gap:1rem; margin-bottom:1.5rem;">
                                    <div class="form-group">
                                        <label style="display:block; margin-bottom:0.5rem; font-weight:600;">Year</label>
                                        <select id="editYear" name="year" required 
                                               style="width:100%; padding:0.8rem; border:1px solid #E5E7EB; border-radius:12px;">
                                            <option value="1">Year 1</option>
                                            <option value="2">Year 2</option>
                                            <option value="3">Year 3</option>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label style="display:block; margin-bottom:0.5rem; font-weight:600;">Term</label>
                                        <select id="editTerm" name="term" required 
                                                style="width:100%; padding:0.8rem; border:1px solid #E5E7EB; border-radius:12px;">
                                            <option value="1">Term 1</option>
                                            <option value="2">Term 2</option>
                                            <option value="3">Term 3</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="form-group" style="margin-bottom: 2rem;">
                                    <label style="display:block; margin-bottom:0.5rem; font-weight:600;">Resource Type</label>
                                    <select id="editType" name="type" required 
                                            style="width:100%; padding:0.8rem; border:1px solid #E5E7EB; border-radius:12px;">
                                        <option value="NOTES">Lecture Note</option>
                                        <option value="PAST_PAPER">Past Paper</option>
                                        <option value="GROUP_PRESENTATION">Group Presentation</option>
                                        <option value="OTHER">Other</option>
                                    </select>
                                </div>
                                <div style="display:flex; gap:1rem;">
                                    <button type="button" onclick="closeEditModal()" 
                                            style="flex:1; padding:1rem; border:1px solid #E5E7EB; border-radius:12px; background:white; cursor:pointer; font-weight:600;">Cancel</button>
                                    <button type="submit" 
                                            style="flex:2; padding:1rem; border:none; border-radius:12px; background:#A68B5B; color:white; cursor:pointer; font-weight:700;">Save Changes</button>
                                </div>
                            </form>
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
                    .modal-body { flex-grow: 1; overflow: hidden; position: relative; }
                    #previewFrame { width: 100%; height: 100%; }

                    /* Premium Viewer Styles */
                    #docxViewer, #xlsxViewer {
                        font-family: 'Outfit', sans-serif;
                        line-height: 1.6;
                        color: #374151;
                    }
                    #xlsxViewer table {
                        border-collapse: separate;
                        border-spacing: 0;
                        width: 100%;
                        border: 1px solid #F3F4F6;
                        border-radius: 12px;
                        overflow: hidden;
                        margin-top: 10px;
                    }
                    #xlsxViewer th {
                        background: #FAF9F6;
                        padding: 12px 15px;
                        font-weight: 700;
                        color: #A68B5B;
                        border-bottom: 2px solid #F3F4F6;
                    }
                    #xlsxViewer td {
                        padding: 10px 15px;
                        border-bottom: 1px solid #F9FAFB;
                        background: white;
                    }
                    #xlsxViewer tr:last-child td { border-bottom: none; }
                    
                    .tab-btn.active {
                        background: #A68B5B !important;
                        color: white !important;
                        box-shadow: 0 4px 12px rgba(166, 139, 91, 0.2);
                    }
                </style>

                <script>
                    function openEditModal(id, title, year, term, type) {
                        document.getElementById('editResourceId').value = id;
                        document.getElementById('editTitle').value = title;
                        document.getElementById('editYear').value = year;
                        document.getElementById('editTerm').value = term;
                        document.getElementById('editType').value = type;
                        document.getElementById('editModal').style.display = 'flex';
                        document.body.style.overflow = 'hidden';
                    }

                    function closeEditModal() {
                        document.getElementById('editModal').style.display = 'none';
                        document.body.style.overflow = 'auto';
                    }

                    // Filtering Logic
                    const searchInput = document.getElementById('searchInput');
                    const subjectFilter = document.getElementById('subjectFilter');
                    const yearFilter = document.getElementById('yearFilter');
                    const typeFilter = document.getElementById('typeFilter');
                    const materialCards = document.querySelectorAll('.material-card');
                    const resultsCount = document.getElementById('resultsCount');

                    // Populate Subjects from cards
                    function populateSubjects() {
                        const subjects = new Set();
                        materialCards.forEach(card => {
                            subjects.add(card.getAttribute('data-subject'));
                        });
                        
                        const sortedSubjects = Array.from(subjects).sort();
                        sortedSubjects.forEach(subject => {
                            const option = document.createElement('option');
                            option.value = subject;
                            option.textContent = subject;
                            subjectFilter.appendChild(option);
                        });
                    }

                    function filterMaterials() {
                        const searchTerm = searchInput.value.toLowerCase();
                        const subject = subjectFilter.value;
                        const year = yearFilter.value;
                        const type = typeFilter.value;

                        let visibleCount = 0;

                        materialCards.forEach(card => {
                            const cardTitle = card.getAttribute('data-title');
                            const cardSubject = card.getAttribute('data-subject');
                            const cardYear = card.getAttribute('data-year');
                            const cardType = card.getAttribute('data-type');

                            const matchesSearch = cardTitle.includes(searchTerm);
                            const matchesSubject = subject === 'all' || cardSubject === subject;
                            const matchesYear = year === 'all' || cardYear === year;
                            const matchesType = type === 'all' || cardType === type;

                            if (matchesSearch && matchesSubject && matchesYear && matchesType) {
                                card.style.display = 'flex';
                                visibleCount++;
                            } else {
                                card.style.display = 'none';
                            }
                        });

                        resultsCount.textContent = `Showing ${visibleCount} of ${materialCards.length} matching resources`;
                    }

                    function resetFilters() {
                        searchInput.value = '';
                        subjectFilter.value = 'all';
                        yearFilter.value = 'all';
                        typeFilter.value = 'all';
                        filterMaterials();
                    }

                    searchInput.addEventListener('input', filterMaterials);
                    subjectFilter.addEventListener('change', filterMaterials);
                    yearFilter.addEventListener('change', filterMaterials);
                    typeFilter.addEventListener('change', filterMaterials);

                    // Initialize
                    populateSubjects();
                    filterMaterials();

                    function previewResource(url, title, filename) {
                        document.getElementById('previewTitle').textContent = title;
                        const ext = filename.split('.').pop().toLowerCase();
                        
                        // Hide all viewers
                        const viewers = ['previewFrame', 'pdfViewer', 'docxViewer', 'xlsxViewer'];
                        viewers.forEach(v => document.getElementById(v).style.display = 'none');
                        document.getElementById('pdfViewer').innerHTML = '';
                        document.getElementById('docxViewer').innerHTML = '';
                        document.getElementById('xlsxViewer').innerHTML = '';

                        if (ext === 'pdf') {
                            showPdf(url);
                        } else if (ext === 'docx' || ext === 'doc') {
                            showDocx(url);
                        } else if (['xlsx', 'xls', 'csv'].includes(ext)) {
                            showXlsx(url);
                        } else if (ext === 'pptx') {
                            showPptx(url);
                        } else if (['jpg', 'jpeg', 'png', 'gif'].includes(ext)) {
                            const frame = document.getElementById('previewFrame');
                            frame.src = url;
                            frame.style.display = 'block';
                        } else {
                            // Default to iframe
                            const frame = document.getElementById('previewFrame');
                            frame.src = url;
                            frame.style.display = 'block';
                        }

                        document.getElementById('previewModal').style.display = 'flex';
                        document.body.style.overflow = 'hidden';
                    }

                    async function showXlsx(url) {
                        const viewer = document.getElementById('xlsxViewer');
                        viewer.style.display = 'block';
                        viewer.innerHTML = 'Loading spreadsheet...';

                        try {
                            const response = await fetch(url);
                            const arrayBuffer = await response.arrayBuffer();
                            const data = new Uint8Array(arrayBuffer);
                            const workbook = XLSX.read(data, { type: 'array' });
                            
                            let html = '<div class="sheet-tabs" style="margin-bottom:15px; display:flex; gap:10px; overflow-x:auto; padding-bottom:10px;">';
                            workbook.SheetNames.forEach((name, i) => {
                                html += `<button onclick="switchSheet('${i}')" class="tab-btn ${i===0?'active':''}" style="padding:6px 15px; border-radius:15px; border:1px solid #ddd; background:white; color:#333; cursor:pointer; font-weight:600; font-size:0.85rem; transition:0.3s; white-space:nowrap;">${name}</button>`;
                            });
                            html += '</div>';

                            workbook.SheetNames.forEach((name, i) => {
                                const sheet = workbook.Sheets[name];
                                const sheetHtml = XLSX.utils.sheet_to_html(sheet);
                                html += `<div id="sheet-${i}" class="sheet-content" style="display:${i===0?'block':'none'}; overflow:auto; max-width:100%; border-radius:12px;"><style>table{border-collapse:collapse; width:100%;} th,td{border:1px solid #eee; padding:8px; text-align:left;}</style>${sheetHtml}</div>`;
                            });
                            
                            viewer.innerHTML = html;
                            window.switchSheet = (index) => {
                                document.querySelectorAll('.sheet-content').forEach(s => s.style.display = 'none');
                                document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
                                document.getElementById('sheet-'+index).style.display = 'block';
                                document.querySelectorAll('.tab-btn')[index].classList.add('active');
                            };
                        } catch (err) {
                            viewer.innerHTML = '<div style="color:red;">Error loading spreadsheet: ' + err.message + '</div>';
                        }
                    }

                    function showPptx(url) {
                        const viewer = document.getElementById('docxViewer'); // Reuse docx for now
                        viewer.style.display = 'block';
                        viewer.innerHTML = `
                            <div style="text-align:center; padding:50px;">
                                <i class="fas fa-file-powerpoint" style="font-size:4rem; color:#D24726; margin-bottom:20px;"></i>
                                <h3>PowerPoint Preview</h3>
                                <p>For the best experience with PowerPoint files, please download the resource.</p>
                                <a href="${url.replace('mode=view', 'mode=download')}" class="btn-download" style="display:inline-block; margin-top:20px; padding: 10px 20px; background: #F8C697; color: #333; text-decoration: none; border-radius: 12px; font-weight: 700;">Download PPTX</a>
                            </div>
                        `;
                    }

                    async function showPdf(url) {
                        const viewer = document.getElementById('pdfViewer');
                        viewer.style.display = 'flex';
                        viewer.innerHTML = '<div style="color:white;">Loading PDF...</div>';
                        
                        try {
                            const pdfjsLib = window['pdfjs-dist/build/pdf'];
                            pdfjsLib.GlobalWorkerOptions.workerSrc = 'https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.11.174/pdf.worker.min.js';
                            
                            const loadingTask = pdfjsLib.getDocument(url);
                            const pdf = await loadingTask.promise;
                            viewer.innerHTML = '';

                            for (let i = 1; i <= pdf.numPages; i++) {
                                const page = await pdf.getPage(i);
                                const canvas = document.createElement('canvas');
                                canvas.style.marginBottom = '20px';
                                canvas.style.boxShadow = '0 0 10px rgba(0,0,0,0.5)';
                                viewer.appendChild(canvas);

                                const viewport = page.getViewport({ scale: 1.5 });
                                const context = canvas.getContext('2d');
                                canvas.height = viewport.height;
                                canvas.width = viewport.width;

                                await page.render({
                                    canvasContext: context,
                                    viewport: viewport
                                }).promise;
                            }
                        } catch (err) {
                            viewer.innerHTML = '<div style="color:red; padding:20px;">Error loading PDF: ' + err.message + '</div>';
                        }
                    }

                    async function showDocx(url) {
                        const viewer = document.getElementById('docxViewer');
                        viewer.style.display = 'block';
                        viewer.innerHTML = 'Loading document...';

                        try {
                            const response = await fetch(url);
                            const arrayBuffer = await response.arrayBuffer();
                            const result = await mammoth.convertToHtml({ arrayBuffer: arrayBuffer });
                            viewer.innerHTML = result.value;
                        } catch (err) {
                            viewer.innerHTML = '<div style="color:red;">Error loading document: ' + err.message + '</div>';
                        }
                    }

                    function closePreview() {
                        document.getElementById('previewModal').style.display = 'none';
                        document.getElementById('previewFrame').src = '';
                        document.getElementById('pdfViewer').innerHTML = '';
                        document.getElementById('docxViewer').innerHTML = '';
                        document.getElementById('xlsxViewer').innerHTML = '';
                        document.body.style.overflow = 'auto';
                    }

                    // Attach listeners to avoid inline onclick lint errors
                    document.addEventListener('DOMContentLoaded', () => {
                        document.querySelectorAll('.js-preview-btn').forEach(btn => {
                            btn.addEventListener('click', function() {
                                previewResource(this.dataset.url, this.dataset.title, this.dataset.filename);
                            });
                        });
                    });
                </script>
        </body>

        </html>