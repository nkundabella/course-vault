<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <c:set var="user" value="${sessionScope.user}" />
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>CourseVault | Settings</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/index.css">
            <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&display=swap"
                rel="stylesheet">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            <style>
                .settings-card {
                    background: white;
                    border: 1px solid #F3F4F6;
                    border-radius: 25px;
                    display: flex;
                    min-height: calc(100vh - 200px);
                    box-shadow: var(--shadow);
                    overflow: hidden;
                    margin-top: 1rem;
                }

                .settings-nav {
                    width: 260px;
                    background: #FAF9F6;
                    padding: 2.5rem 1.2rem;
                    border-right: 1px solid #F3F4F6;
                }

                .settings-nav h2 {
                    font-size: 1.8rem;
                    font-weight: 700;
                    margin-bottom: 2rem;
                    color: #333;
                    padding-left: 1rem;
                }

                .settings-tab {
                    padding: 1rem 1.2rem;
                    margin-bottom: 0.5rem;
                    border-radius: 12px;
                    cursor: pointer;
                    display: flex;
                    align-items: center;
                    gap: 1rem;
                    color: #666;
                    font-weight: 600;
                    transition: var(--transition-smooth);
                }

                .settings-tab:hover {
                    background: rgba(255, 255, 255, 0.6);
                    color: var(--accent-gold);
                }

                .settings-tab.active {
                    background: white;
                    color: var(--accent-gold);
                    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
                }

                .settings-content-area {
                    flex-grow: 1;
                    padding: 3rem;
                    position: relative;
                }

                .tab-content {
                    display: none;
                    animation: fadeIn 0.4s ease-out;
                }

                .tab-content.active {
                    display: block;
                }

                @keyframes fadeIn {
                    from {
                        opacity: 0;
                        transform: translateY(10px);
                    }

                    to {
                        opacity: 1;
                        transform: translateY(0);
                    }
                }

                .section-header {
                    margin-bottom: 2rem;
                }

                .section-header h3 {
                    font-size: 1.5rem;
                    color: #333;
                    margin-bottom: 0.5rem;
                }

                .section-header p {
                    color: #666;
                    font-size: 0.9rem;
                }

                .form-grid {
                    display: grid;
                    grid-template-columns: 1fr 1fr;
                    gap: 2rem;
                }

                .form-group {
                    margin-bottom: 1.5rem;
                }

                .form-group label {
                    display: block;
                    margin-bottom: 0.6rem;
                    font-weight: 600;
                    font-size: 0.9rem;
                    color: #444;
                }

                .form-group input {
                    width: 100%;
                    padding: 0.9rem 1.2rem;
                    border: 1px solid #E5E7EB;
                    border-radius: 12px;
                    outline: none;
                    transition: 0.3s;
                    background: white;
                }

                .form-group input:focus {
                    border-color: var(--accent-gold);
                    box-shadow: 0 0 0 4px rgba(166, 139, 91, 0.1);
                }

                .form-group input:disabled {
                    background: #f9fafb;
                    color: #999;
                    cursor: not-allowed;
                }

                .btn-update {
                    background: var(--accent-gold);
                    color: white;
                    border: none;
                    padding: 1rem 2rem;
                    border-radius: 15px;
                    font-weight: 700;
                    cursor: pointer;
                    transition: 0.3s;
                    display: inline-flex;
                    align-items: center;
                    gap: 0.8rem;
                }

                .btn-update:hover {
                    background: var(--accent-gold-light);
                    transform: translateY(-2px);
                    box-shadow: 0 8px 20px rgba(166, 139, 91, 0.2);
                }

                .alert-success {
                    background: #ECFDF5;
                    color: #059669;
                    border: 1px solid #10B981;
                    padding: 1rem;
                    border-radius: 12px;
                    margin-bottom: 2rem;
                    font-weight: 600;
                }

                .alert-error {
                    background: #FEF2F2;
                    color: #DC2626;
                    border: 1px solid #EF4444;
                    padding: 1rem;
                    border-radius: 12px;
                    margin-bottom: 2rem;
                    font-weight: 600;
                }

                .stats-info-card {
                    background: white;
                    padding: 1.5rem;
                    border-radius: 20px;
                    border: 1px solid #eee;
                    margin-top: 1rem;
                }
            </style>
        </head>

        <body>
            <%@ include file="/WEB-INF/jspf/sidebar.jspf" %>

                <main class="main-viewport">
                    <header class="header-top">
                        <div class="search-bar">
                            <i class="fas fa-search"></i>
                            <input type="text" placeholder="Search setting...">
                        </div>
                        <div class="user-profile">
                            <span>${user.fullName} (${user.role})</span>
                            <img src="https://ui-avatars.com/api/?name=${user.fullName}&background=A68B5B&color=fff"
                                alt="Profile">
                        </div>
                    </header>

                    <c:if test="${not empty param.success}">
                        <div class="alert-success">
                            <i class="fas fa-check-circle"></i>
                            <c:choose>
                                <c:when test="${param.success eq 'profile'}">Profile details saved successfully.
                                </c:when>
                                <c:when test="${param.success eq 'password'}">Your security password has been updated.
                                </c:when>
                                <c:when test="${param.success eq 'security'}">Security question and answer updated.
                                </c:when>
                                <c:otherwise>Settings updated successfully.</c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>
                    <c:if test="${not empty param.error}">
                        <div class="alert-error">
                            <i class="fas fa-exclamation-circle"></i> Something went wrong. Please check your inputs.
                        </div>
                    </c:if>

                    <div class="settings-card">
                        <div class="settings-nav">
                            <h2>Settings</h2>
                            <div class="settings-tab active" onclick="switchTab('account', this)">
                                <i class="fas fa-user"></i> Account
                            </div>
                            <div class="settings-tab" onclick="switchTab('security', this)">
                                <i class="fas fa-shield-alt"></i> Security
                            </div>
                            <c:if test="${user.role eq 'ADMIN'}">
                                <div class="settings-tab" onclick="switchTab('system', this)">
                                    <i class="fas fa-server"></i> System
                                </div>
                            </c:if>
                            <div class="settings-tab" onclick="switchTab('help', this)">
                                <i class="fas fa-question-circle"></i> Help
                            </div>
                        </div>

                        <div class="settings-content-area">
                            <!-- Account Tab -->
                            <div id="account" class="tab-content active">
                                <div class="section-header">
                                    <h3>Basic info</h3>
                                    <p>Manage your profile information and how others see you.</p>
                                </div>
                                <form action="${pageContext.request.contextPath}/settings" method="POST">
                                    <input type="hidden" name="action" value="updateProfile">
                                    <div class="form-group">
                                        <label>Full Name</label>
                                        <input type="text" name="fullName" value="${user.fullName}" required>
                                    </div>
                                    <div class="form-grid">
                                        <div class="form-group">
                                            <label>Email Address</label>
                                            <input type="text" value="${user.email}" disabled>
                                        </div>
                                        <div class="form-group">
                                            <label>User Role</label>
                                            <input type="text" value="${user.role}" disabled>
                                        </div>
                                    </div>
                                    <div style="margin-top: 2rem;">
                                        <button type="submit" class="btn-update">
                                            <i class="fas fa-save"></i> Save Changes
                                        </button>
                                    </div>
                                </form>
                            </div>

                            <!-- Security Tab -->
                            <div id="security" class="tab-content">
                                <div class="section-header">
                                    <h3>Security info</h3>
                                    <p>Protect your account with a strong password and security questions.</p>
                                </div>
                                <form action="${pageContext.request.contextPath}/settings" method="POST"
                                    style="margin-bottom: 3rem;">
                                    <input type="hidden" name="action" value="changePassword">
                                    <div class="form-grid">
                                        <div class="form-group">
                                            <label>New Password</label>
                                            <input type="password" name="newPassword" placeholder="••••••••">
                                        </div>
                                        <div class="form-group">
                                            <label>Confirm Password</label>
                                            <input type="password" name="confirmPassword" placeholder="••••••••">
                                        </div>
                                    </div>
                                    <button type="submit" class="btn-update">Update Password</button>
                                </form>

                                <form action="${pageContext.request.contextPath}/settings" method="POST">
                                    <input type="hidden" name="action" value="updateSecurity">
                                    <div class="form-group">
                                        <label>Security Question</label>
                                        <input type="text" name="securityQuestion" value="${user.securityQuestion}">
                                    </div>
                                    <div class="form-group">
                                        <label>Your Answer</label>
                                        <input type="password" name="securityAnswer"
                                            placeholder="Update your secret answer">
                                    </div>
                                    <button type="submit" class="btn-update">Update Guard</button>
                                </form>
                            </div>

                            <!-- System Tab (Admins Only) -->
                            <c:if test="${user.role eq 'ADMIN'}">
                                <div id="system" class="tab-content">
                                    <div class="section-header">
                                        <h3>SMTP Config</h3>
                                        <p>Configure mail server settings for Two-Factor Authentication.</p>
                                    </div>
                                    <form action="${pageContext.request.contextPath}/settings" method="POST">
                                        <input type="hidden" name="action" value="updateSmtp">
                                        <div class="form-grid">
                                            <div class="form-group">
                                                <label>SMTP Host</label>
                                                <input type="text" name="smtpHost" value="${config.smtpHost}"
                                                    placeholder="smtp.gmail.com">
                                            </div>
                                            <div class="form-group">
                                                <label>SMTP Port</label>
                                                <input type="text" name="smtpPort" value="${config.smtpPort}"
                                                    placeholder="587">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label>SMTP Email</label>
                                            <input type="email" name="smtpUser" value="${config.smtpUser}">
                                        </div>
                                        <div class="form-group">
                                            <label>App Password</label>
                                            <input type="password" name="smtpPass" value="${config.smtpPass}">
                                        </div>
                                        <button type="submit" class="btn-update">Save SMTP</button>
                                    </form>

                                    <div class="stats-info-card">
                                        <p style="font-weight: 600; color: #444; margin-bottom: 0.5rem;">System Insights
                                        </p>
                                        <div style="display: flex; gap: 2rem;">
                                            <div><small>Total Users:</small> <strong>${totalUsers}</strong></div>
                                            <div><small>Admins:</small> <strong>${adminCount}</strong></div>
                                        </div>
                                    </div>
                                </div>
                            </c:if>

                            <!-- Help Tab -->
                            <div id="help" class="tab-content">
                                <div class="section-header">
                                    <h3>Help & Support</h3>
                                    <p>Need assistance? We're here to help.</p>
                                </div>
                                <div class="stats-info-card">
                                    <p>Course-Vault is designed for RCA students and faculty. For technical issues,
                                        please contact the academic office.</p>
                                    <ul style="margin-top: 1rem; color: #666; font-size: 0.9rem;">
                                        <li>Email: support@coursevault.com</li>
                                        <li>Phone: +250 788 548 000</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </main>

                <script>
                    function switchTab(tabId, element) {
                        // Hide all contents
                        document.querySelectorAll('.tab-content').forEach(tab => tab.classList.remove('active'));
                        // Deactivate all tabs
                        document.querySelectorAll('.settings-tab').forEach(t => t.classList.remove('active'));

                        // Show target content
                        document.getElementById(tabId).classList.add('active');
                        // Activate target tab
                        element.classList.add('active');
                    }
                </script>
        </body>

        </html>