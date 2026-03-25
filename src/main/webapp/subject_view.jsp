<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
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
            <script src="https://cdnjs.cloudflare.com/ajax/libs/pdf.js/3.11.174/pdf.min.js"></script>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/mammoth/1.6.0/mammoth.browser.min.js"></script>
            <script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.18.5/xlsx.full.min.js"></script>
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
                                                    <c:if test="${user.role ne 'ADMIN' and user.role ne 'TEACHER'}">
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
                                            <c:set var="lowPath" value="${fn:toLowerCase(res.filePath)}" />
                                             <c:if test="${fn:endsWith(lowPath, '.pdf') || fn:endsWith(lowPath, '.docx') || fn:endsWith(lowPath, '.doc') || fn:endsWith(lowPath, '.txt') || fn:endsWith(lowPath, '.png') || fn:endsWith(lowPath, '.jpg') || fn:endsWith(lowPath, '.jpeg') || fn:endsWith(lowPath, '.xlsx') || fn:endsWith(lowPath, '.xls') || fn:endsWith(lowPath, '.csv') || fn:endsWith(lowPath, '.pptx')}">
                                                <button class="btn-download js-preview-btn" 
                                                        data-url="${pageContext.request.contextPath}/download/${res.filePath}?mode=view"
                                                        data-title="${res.title}"
                                                        data-filename="${res.filePath}"
                                                        style="background: #F3F4F6; color: #374151; border:none; cursor:pointer;">
                                                    <i class="fas fa-eye"></i>
                                                    View
                                                </button>
                                            </c:if>
                                            <c:if test="${res.uploader.id eq user.id}">
                                                <button class="btn-download" 
                                                        onclick="openEditModal('${res.id}', '${res.title}', '${res.year}', '${res.term}', '${res.type}')"
                                                        style="background: #FFF7ED; color: #EA580C; border:none; cursor:pointer;">
                                                    <i class="fas fa-edit"></i>
                                                    Edit
                                                </button>
                                            </c:if>
                                            <a href="${pageContext.request.contextPath}/download/${res.filePath}"
                                                class="btn-download">
                                                <i class="fas fa-download"></i>
                                                Download
                                            </a>
                                            <c:if test="${res.uploader.id eq user.id}">
                                                <a href="${pageContext.request.contextPath}/subjects/resource/delete?id=${res.id}"
                                                    class="btn-download" style="background: #FEE2E2; color: #DC2626;"
                                                    onclick="return confirm('Are you sure you want to delete this resource? This action cannot be undone.')">
                                                    <i class="fas fa-trash-alt"></i>
                                                    Delete
                                                </a>
                                            </c:if>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
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
                                        <input type="number" id="editYear" name="year" required min="1" max="5" 
                                               style="width:100%; padding:0.8rem; border:1px solid #E5E7EB; border-radius:12px;">
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
                                        <option value="Lecture Note">Lecture Note</option>
                                        <option value="Assignment">Assignment</option>
                                        <option value="Past Paper">Past Paper</option>
                                        <option value="Textbook">Textbook</option>
                                        <option value="Reference">Reference</option>
                                        <option value="Video">Video</option>
                                        <option value="Other">Other</option>
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
                                <a href="${url.replace('mode=view', 'mode=download')}" class="btn-download" style="display:inline-block; margin-top:20px;">Download PPTX</a>
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
                                previewResource(this.dataset.url, this.dataset.title, this.dataset.filename);
                            });
                        });
                    });
                </script>
        </body>

        </html>