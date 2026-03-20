<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CourseVault | Manage Users</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/index.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .users-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 2rem;
            background: white;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.03);
            border: 1px solid #eee;
        }
        .users-table th, .users-table td {
            padding: 1.2rem 1.5rem;
            text-align: left;
            border-bottom: 1px solid #F3F4F6;
        }
        .users-table th {
            background: #FAF9F6;
            font-weight: 700;
            color: #4B5563;
            text-transform: uppercase;
            font-size: 0.85rem;
            letter-spacing: 0.5px;
        }
        .users-table tr:hover {
            background: #F9FAFB;
        }
        .badge-pending {
            background: #FEF3C7;
            color: #D97706;
            padding: 0.3rem 0.8rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 700;
        }
        .btn-approve {
            background: #10B981;
            color: white;
            border: none;
            padding: 0.6rem 1.2rem;
            border-radius: 12px;
            cursor: pointer;
            font-weight: 600;
            transition: 0.3s;
            text-decoration: none;
            display: inline-flex;
            gap: 5px;
            align-items: center;
        }
        .btn-approve:hover { background: #059669; transform: translateY(-2px); }
        .btn-decline {
            background: #FEE2E2;
            color: #DC2626;
            border: none;
            padding: 0.6rem 1.2rem;
            border-radius: 12px;
            cursor: pointer;
            font-weight: 600;
            transition: 0.3s;
            text-decoration: none;
            display: inline-flex;
            gap: 5px;
            align-items: center;
        }
        .btn-decline:hover { background: #FECACA; transform: translateY(-2px); }
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/jspf/sidebar.jspf" %>
    <main class="main-viewport">
        <header class="header-top">
            <h1 style="font-weight: 700;">Manage Users</h1>
            <div class="user-profile">
                <span>${user.fullName} (${user.role})</span>
                <img src="https://ui-avatars.com/api/?name=${user.fullName}&background=A68B5B&color=fff" alt="Profile">
            </div>
        </header>

        <section style="margin-top: 2rem;">
            <h2>Teacher Requests</h2>
            <p style="color: #6B7280;">Review users who have requested Teacher privileges.</p>
            
            <c:choose>
                <c:when test="${not empty pendingTeachers}">
                    <table class="users-table animate__animated animate__fadeInUp">
                        <thead>
                            <tr>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="pt" items="${pendingTeachers}">
                                <tr>
                                    <td><strong>${pt.fullName}</strong></td>
                                    <td>${pt.email}</td>
                                    <td><span class="badge-pending">Pending Approval</span></td>
                                    <td style="display: flex; gap: 0.5rem;">
                                        <form action="${pageContext.request.contextPath}/users/" method="POST" style="display:inline;">
                                            <input type="hidden" name="action" value="approve">
                                            <input type="hidden" name="userId" value="${pt.id}">
                                            <button type="submit" class="btn-approve"><i class="fas fa-check"></i> Approve</button>
                                        </form>
                                        <form action="${pageContext.request.contextPath}/users/" method="POST" style="display:inline;">
                                            <input type="hidden" name="action" value="decline">
                                            <input type="hidden" name="userId" value="${pt.id}">
                                            <button type="submit" class="btn-decline"><i class="fas fa-times"></i> Decline</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:when>
                <c:otherwise>
                    <div style="text-align: center; padding: 4rem; background: rgba(255,255,255,0.5); border-radius: 20px; border: 2px dashed #D1D5DB; margin-top: 2rem;">
                        <i class="fas fa-check-circle" style="font-size: 3rem; color: #10B981; margin-bottom: 1rem;"></i>
                        <h3 style="color: #374151;">All caught up!</h3>
                        <p style="color: #6B7280;">There are no new teacher requests pending approval.</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>
    </main>
</body>
</html>
