<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
            <c:set var="user" value="${sessionScope.user}" />
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <title>CourseVault | Academic Calendar</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/index.css">
                <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <style>
                    .calendar-container {
                        display: grid;
                        grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
                        gap: 2rem;
                        margin-top: 1rem;
                    }

                    .term-card {
                        background: var(--card-bg);
                        backdrop-filter: blur(15px);
                        border: 1px solid var(--glass-border);
                        border-radius: 25px;
                        padding: 1.5rem;
                        box-shadow: var(--shadow);
                        height: fit-content;
                    }

                    .term-card h3 {
                        color: var(--accent-gold);
                        margin-bottom: 1.2rem;
                        display: flex;
                        align-items: center;
                        gap: 0.8rem;
                        font-size: 1.3rem;
                    }

                    .event-list {
                        list-style: none;
                        display: flex;
                        flex-direction: column;
                        gap: 1rem;
                    }

                    .event-item {
                        display: flex;
                        gap: 1rem;
                        padding-bottom: 1rem;
                        border-bottom: 1px solid rgba(0, 0, 0, 0.05);
                        position: relative;
                    }

                    .event-item:last-child {
                        border-bottom: none;
                    }

                    .event-date {
                        min-width: 60px;
                        text-align: center;
                    }

                    .date-box {
                        background: #fff;
                        border-radius: 10px;
                        padding: 0.5rem;
                        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.03);
                    }

                    .date-day {
                        font-weight: 700;
                        color: #333;
                        font-size: 1.1rem;
                    }

                    .date-month {
                        font-size: 0.75rem;
                        color: #A68B5B;
                        text-transform: uppercase;
                        font-weight: 600;
                    }

                    .event-content {
                        flex-grow: 1;
                    }

                    .event-title {
                        font-weight: 600;
                        font-size: 1rem;
                        color: #333;
                        margin-bottom: 0.2rem;
                    }

                    .event-desc {
                        font-size: 0.85rem;
                        color: #666;
                        line-height: 1.4;
                    }

                    .major-badge {
                        background: #FEE2E2;
                        color: #EF4444;
                        padding: 0.2rem 0.5rem;
                        border-radius: 6px;
                        font-size: 0.65rem;
                        font-weight: 700;
                        text-transform: uppercase;
                        margin-left: 0.5rem;
                    }

                    .cat-badge {
                        background: #E0E7FF;
                        color: #4338CA;
                    }

                    .exam-badge {
                        background: #FEF3C7;
                        color: #D97706;
                    }

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
                        padding: 2rem;
                        border-radius: 20px;
                        width: 400px;
                        box-shadow: var(--shadow-premium);
                    }

                    .form-group {
                        margin-bottom: 1rem;
                    }

                    .form-group label {
                        display: block;
                        margin-bottom: 0.4rem;
                        font-weight: 600;
                        font-size: 0.85rem;
                    }

                    .form-group input,
                    .form-group select,
                    .form-group textarea {
                        width: 100%;
                        padding: 0.7rem;
                        border: 1px solid #eee;
                        border-radius: 10px;
                        outline: none;
                    }

                    .btn-premium {
                        background: var(--accent-gold);
                        color: white;
                        border: none;
                        padding: 0.8rem 1.5rem;
                        border-radius: 12px;
                        font-weight: 700;
                        cursor: pointer;
                        transition: var(--transition-smooth);
                    }

                    .btn-premium:hover {
                        background: var(--accent-gold-light);
                        transform: translateY(-2px);
                    }
                </style>
            </head>

            <body>
                <%@ include file="/WEB-INF/jspf/sidebar.jspf" %>
                    <main class="main-viewport">
                        <header class="header-top">
                            <h1 style="font-weight: 700;">Academic Calendar 2025/2026</h1>
                            <div class="user-profile">
                                <c:if test="${user.role eq 'ADMIN'}">
                                    <button class="btn-premium" onclick="openModal()">
                                        <i class="fas fa-calendar-plus"></i> Add Event
                                    </button>
                                </c:if>
                                <span>${user.fullName}</span>
                                <img src="https://ui-avatars.com/api/?name=${user.fullName}&background=A68B5B&color=fff"
                                    alt="Profile">
                            </div>
                        </header>

                        <div class="calendar-container">
                            <c:forEach var="t" begin="1" end="3">
                                <div class="term-card">
                                    <h3>
                                        <i class="fas fa-graduation-cap"></i> Term ${t}
                                    </h3>
                                    <div class="event-list">
                                        <c:forEach var="event" items="${events}">
                                            <c:if test="${event.term == t}">
                                                <div class="event-item">
                                                    <div class="event-date">
                                                        <div class="date-box">
                                                            <div class="date-day">${event.date.dayOfMonth}</div>
                                                            <div class="date-month">
                                                                ${event.date.month.name().substring(0,3)}</div>
                                                        </div>
                                                    </div>
                                                    <div class="event-content">
                                                        <div class="event-title">
                                                            ${event.title}
                                                            <c:if test="${event.major}">
                                                                <span
                                                                    class="major-badge ${event.category eq 'Exam' ? 'exam-badge' : (event.category eq 'Exam' ? 'cat-badge' : '')}">${event.category}</span>
                                                            </c:if>
                                                        </div>
                                                        <div class="event-desc">${event.description}</div>
                                                        <c:if test="${user.role eq 'ADMIN'}">
                                                            <a href="${pageContext.request.contextPath}/calendar/delete?id=${event.id}"
                                                                style="position: absolute; right: 0; top: 0; color: #ff9999; font-size: 0.8rem;"
                                                                onclick="return confirm('Delete this event?')">
                                                                <i class="fas fa-times"></i>
                                                            </a>
                                                        </c:if>
                                                    </div>
                                                </div>
                                            </c:if>
                                        </c:forEach>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </main>

                    <div class="modal-overlay" id="eventModal">
                        <div class="modal-content">
                            <h2 style="margin-bottom: 1.5rem;">Add Academic Event</h2>
                            <form action="${pageContext.request.contextPath}/calendar/add" method="POST">
                                <div class="form-group">
                                    <label>Event Title</label>
                                    <input type="text" name="title" required placeholder="e.g., Final Exams">
                                </div>
                                <div class="form-group">
                                    <label>Date</label>
                                    <input type="date" name="date" required>
                                </div>
                                <div class="form-group">
                                    <label>Term</label>
                                    <select name="term">
                                        <option value="1">Term 1</option>
                                        <option value="2">Term 2</option>
                                        <option value="3">Term 3</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label>Category</label>
                                    <select name="category">
                                        <option value="Academic">Academic</option>
                                        <option value="Exam">Exam</option>
                                        <option value="Event">Event</option>
                                        <option value="Deadline">Deadline</option>
                                        <option value="Holidays">Holidays</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label>
                                        <input type="checkbox" name="major" value="true"> Major Event
                                    </label>
                                </div>
                                <div class="form-group">
                                    <label>Description</label>
                                    <textarea name="description" rows="2"></textarea>
                                </div>
                                <div style="display: flex; gap: 1rem; margin-top: 2rem;">
                                    <button type="button" class="btn-premium"
                                        style="background: #eee; color: #666; flex:1"
                                        onclick="closeModal()">Cancel</button>
                                    <button type="submit" class="btn-premium" style="flex:2">Save Event</button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <script>
                        function openModal() { document.getElementById('eventModal').style.display = 'flex'; }
                        function closeModal() { document.getElementById('eventModal').style.display = 'none'; }
                    </script>
            </body>

            </html>