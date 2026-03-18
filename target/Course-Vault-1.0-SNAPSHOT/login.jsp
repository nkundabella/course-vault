<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>CourseVault | Login</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/index.css">
            <link rel="preconnect" href="https://fonts.googleapis.com">
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
            <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&display=swap"
                rel="stylesheet">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">
            <script src="https://unpkg.com/@dotlottie/player-component@2.7.12/dist/dotlottie-player.mjs"
                type="module"></script>
            <style>
                body {
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    background: radial-gradient(circle at top left, #FDFBFA 0%, #F5F3EF 100%);
                    margin: 0;
                    min-height: 100vh;
                    overflow: auto;
                }

                .login-container {
                    display: flex;
                    background: var(--card-bg);
                    backdrop-filter: blur(12px);
                    -webkit-backdrop-filter: blur(12px);
                    border: 1px solid var(--glass-border);
                    border-radius: 40px;
                    box-shadow: var(--shadow-premium);
                    width: min(1000px, calc(100vw - 2.5rem));
                    min-height: 600px;
                    height: auto;
                    overflow: hidden;
                    animation: fadeInUp 0.8s cubic-bezier(0.165, 0.84, 0.44, 1);
                }

                @keyframes fadeInUp {
                    from {
                        opacity: 0;
                        transform: translateY(30px);
                    }

                    to {
                        opacity: 1;
                        transform: translateY(0);
                    }
                }

                .login-form-area {
                    flex: 1;
                    padding: 4.5rem;
                    display: flex;
                    flex-direction: column;
                    justify-content: center;
                    position: relative;
                }

                .login-animation-area {
                    flex: 1.1;
                    background: linear-gradient(135deg, #FFF9F2 0%, #FFF1E0 100%);
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    position: relative;
                }

                .login-animation-area::after {
                    content: '';
                    position: absolute;
                    width: 100%;
                    height: 100%;
                    background: url('https://www.transparenttextures.com/patterns/cubes.png');
                    opacity: 0.03;
                    pointer-events: none;
                }

                .login-header h2 {
                    font-size: 2.4rem;
                    margin-bottom: 0.5rem;
                    font-weight: 700;
                    color: #1F2937;
                    letter-spacing: -1px;
                }

                .login-header p {
                    color: #6B7280;
                    margin-bottom: 2.5rem;
                    font-size: 1.05rem;
                }

                .form-group {
                    margin-bottom: 1.5rem;
                    position: relative;
                    transition: var(--transition-smooth);
                }

                .form-group label {
                    display: block;
                    margin-bottom: 0.6rem;
                    font-weight: 600;
                    font-size: 0.9rem;
                    color: #4B5563;
                    margin-left: 4px;
                }

                .form-group input {
                    width: 100%;
                    padding: 1.1rem 1.2rem;
                    background: rgba(255, 255, 255, 0.8);
                    border: 1px solid #E5E7EB;
                    border-radius: 16px;
                    outline: none;
                    transition: var(--transition-smooth);
                    font-family: inherit;
                    font-size: 1rem;
                    box-sizing: border-box;
                }

                .form-group input:focus {
                    border-color: var(--accent-gold);
                    background: white;
                    box-shadow: 0 0 0 4px rgba(166, 139, 91, 0.1);
                    transform: translateY(-2px);
                }

                .password-toggle {
                    position: absolute;
                    right: 20px;
                    top: 42px;
                    cursor: pointer;
                    color: #9CA3AF;
                    font-size: 1.1rem;
                    transition: color 0.3s;
                    z-index: 2;
                }

                /* Lottie Skeleton */
                .lottie-skeleton {
                    width: 350px;
                    height: 350px;
                    background: rgba(0, 0, 0, 0.02);
                    border-radius: 50%;
                    position: absolute;
                    animation: pulse 2s infinite ease-in-out;
                }

                @keyframes pulse {

                    0%,
                    100% {
                        opacity: 0.5;
                        transform: scale(0.98);
                    }

                    50% {
                        opacity: 0.8;
                        transform: scale(1);
                    }
                }

                .password-toggle:hover {
                    color: var(--accent-gold);
                }

                .forgot-link {
                    display: block;
                    text-align: right;
                    margin-top: 0.7rem;
                    font-size: 0.85rem;
                    color: var(--accent-gold);
                    text-decoration: none;
                    font-weight: 600;
                    transition: color 0.3s;
                }

                .forgot-link:hover {
                    color: var(--accent-gold-light);
                }

                .btn-login {
                    width: 100%;
                    background: linear-gradient(135deg, #F8C697 0%, #f6b579 100%);
                    color: #333;
                    padding: 1.1rem;
                    border: none;
                    border-radius: 16px;
                    font-weight: 700;
                    cursor: pointer;
                    transition: var(--transition-smooth);
                    margin-top: 1.5rem;
                    font-size: 1.1rem;
                    box-shadow: 0 10px 20px rgba(248, 198, 151, 0.3);
                }

                .btn-login:hover {
                    transform: translateY(-3px);
                    box-shadow: 0 15px 30px rgba(248, 198, 151, 0.4);
                }

                .btn-login:active {
                    transform: translateY(-1px);
                }

                .error-box {
                    display: none;
                    background: #FEF2F2;
                    border-left: 4px solid #EF4444;
                    color: #991B1B;
                    padding: 1rem;
                    border-radius: 12px;
                    margin-bottom: 2rem;
                    font-size: 0.95rem;
                    animation: shake 0.5s;
                }

                @keyframes shake {

                    0%,
                    100% {
                        transform: translateX(0);
                    }

                    25% {
                        transform: translateX(-5px);
                    }

                    75% {
                        transform: translateX(5px);
                    }
                }

                .success-msg {
                    background: #ECFDF5;
                    color: #059669;
                    padding: 1rem;
                    border-radius: 12px;
                    margin-bottom: 2rem;
                    font-size: 0.95rem;
                    text-align: center;
                    border-left: 4px solid #10B981;
                }

                .signup-link {
                    text-align: center;
                    margin-top: 2.5rem;
                    font-size: 0.95rem;
                    color: #6B7280;
                }

                .signup-link a {
                    color: var(--accent-gold);
                    text-decoration: none;
                    font-weight: 700;
                    margin-left: 5px;
                }

                .signup-link a:hover {
                    text-decoration: underline;
                }

                /* Multi-step styling */
                #step2 {
                    display: none;
                }

                .step-indicator {
                    display: flex;
                    justify-content: center;
                    gap: 1rem;
                    margin-bottom: 2.5rem;
                }

                .step-dot {
                    width: 40px;
                    height: 8px;
                    background: #E5E7EB;
                    border-radius: 4px;
                    transition: var(--transition-smooth);
                }

                .step-dot.active {
                    background: var(--accent-gold);
                    width: 60px;
                }

                .step-dot.completed {
                    background: #10B981;
                }

                .loader {
                    display: none;
                    width: 20px;
                    height: 20px;
                    border: 3px solid rgba(0, 0, 0, 0.1);
                    border-top: 3px solid #333;
                    border-radius: 50%;
                    animation: spin 1s linear infinite;
                    margin: 0 auto;
                }

                @keyframes spin {
                    0% {
                        transform: rotate(0deg);
                    }

                    100% {
                        transform: rotate(360deg);
                    }
                }

                /* Prevent text clipping on smaller viewports */
                @media (max-width: 980px) {
                    .login-container {
                        flex-direction: column;
                        min-height: unset;
                    }
                    .login-form-area {
                        padding: 2.5rem;
                    }
                    .login-animation-area {
                        min-height: 260px;
                    }
                    .lottie-skeleton {
                        width: 260px;
                        height: 260px;
                    }
                }

                @media (max-width: 520px) {
                    .login-form-area {
                        padding: 1.75rem;
                    }
                    #twoFactorCode {
                        letter-spacing: 0.45em !important;
                        font-size: 1.25rem !important;
                    }
                }
            </style>
        </head>

        <body>
            <input type="hidden" id="contextPath" value="${pageContext.request.contextPath}">
            <div id="globalLoadingOverlay" style="
                display:none;
                position:fixed;
                inset:0;
                background: rgba(17,24,39,0.35);
                backdrop-filter: blur(6px);
                z-index: 2000;
                align-items:center;
                justify-content:center;
            ">
                <div style="
                    background: white;
                    border-radius: 18px;
                    padding: 1.25rem 1.5rem;
                    width: min(420px, calc(100vw - 2rem));
                    box-shadow: 0 20px 50px rgba(0,0,0,0.12);
                    text-align:center;
                ">
                    <div class="loader" style="display:block; margin: 0 auto 0.75rem auto;"></div>
                    <div style="font-weight:700; color:#111827;">Signing you in…</div>
                    <div style="margin-top:0.25rem; font-size:0.9rem; color:#6B7280;">Please wait a moment.</div>
                </div>
            </div>
            <div class="login-container">
                <div class="login-form-area">
                    <div class="login-header">
                        <h2>Welcome Back</h2>
                        <p>Sign in to continue your academic journey.</p>
                    </div>

                    <div id="errorBox" class="error-box"></div>

                    <c:if test="${param.success eq 'account_created'}">
                        <div class="success-msg">Your account is ready! Please log in.</div>
                    </c:if>
                    <c:if test="${param.success eq 'password_reset'}">
                        <div class="success-msg">Password updated. You can now log in.</div>
                    </c:if>
                    <c:if test="${param.smtp eq 'configured'}">
                        <div class="success-msg">Email 2FA configured. You can now log in.</div>
                    </c:if>

                    <form id="loginForm" onsubmit="handleFormSubmit(event)">
                        <div class="step-indicator">
                            <div class="step-dot active" id="dot1"></div>
                            <div class="step-dot" id="dot2"></div>
                        </div>

                        <!-- Step 1: Credentials -->
                        <div id="step1" class="animate__animated animate__fadeIn">
                            <div class="form-group">
                                <label>Email Address</label>
                                <input type="email" id="email" name="email" placeholder="name@domain.com" required>
                            </div>
                            <div class="form-group">
                                <label>Password</label>
                                <input type="password" id="password" name="password" placeholder="••••••••" required>
                                <i class="fas fa-eye password-toggle" id="togglePassword"></i>
                                <a href="${pageContext.request.contextPath}/auth/forgot-password"
                                    class="forgot-link">Forgot Password?</a>
                            </div>
                            <button type="submit" id="loginBtn" class="btn-login" style="display:flex; align-items:center; justify-content:center; gap:0.75rem;">
                                <span id="btnText">Continue</span>
                                <div id="btnLoader" class="loader" style="margin:0;"></div>
                            </button>
                        </div>
                    </form>

                    <div id="smtpSetupBox" 
                         data-server-error="${not empty smtpSetupError}"
                         style="display:none; margin-top: 1.75rem; background:#FFF9F2; border:1px solid #FFE8D1; padding: 1.25rem; border-radius: 18px;">
                        <div style="font-weight:800; color:#92400E; margin-bottom:0.5rem;">Set up Email 2FA (SMTP)</div>
                        <div style="color:#6B7280; font-size:0.92rem; margin-bottom:1rem;">
                            Email 2FA is required. We’ll send codes from <b>nkundabella2@gmail.com</b> via Gmail SMTP.
                        </div>

                        <c:if test="${not empty smtpSetupError}">
                            <div class="error-box" style="display:block; margin-bottom: 1rem;">${smtpSetupError}</div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/auth/bootstrap-smtp" method="POST">
                            <!-- Keep Gmail SMTP defaults hidden to reduce confusion -->
                            <input type="hidden" name="smtpHost" value="smtp.gmail.com">
                            <input type="hidden" name="smtpPort" value="587">
                            <input type="hidden" name="smtpUser" value="nkundabella2@gmail.com">
                            <div class="form-group">
                                <label>SMTP Password (App Password)</label>
                                <input type="password" name="smtpPass" placeholder="••••••••••••••••" required>
                            </div>
                            <button type="submit" class="btn-login" style="margin-top:0.25rem;">Save SMTP</button>
                        </form>
                        <div style="margin-top:0.75rem; font-size:0.85rem; color:#6B7280;">
                            This must be a Gmail <b>App Password</b> (not your normal Gmail password).
                        </div>
                    </div>

                    <div class="signup-link">
                        New here? <a href="${pageContext.request.contextPath}/auth/signup">Create an account</a>
                    </div>
                </div>
                <div class="login-animation-area">
                    <div class="lottie-skeleton"></div>
                    <!-- Use the same player component used elsewhere in the app for reliability -->
                    <dotlottie-player
                        src="https://lottie.host/64a233a8-215c-4770-8786-0ade923d0b13/0t2RxapWsm.lottie"
                        style="width: 450px; height: 450px; position: relative; z-index: 1;" autoplay loop>
                    </dotlottie-player>
                </div>
            </div>

            <script>
                const togglePassword = document.querySelector('#togglePassword');
                const passwordInput = document.querySelector('#password');
                const errorBox = document.getElementById('errorBox');
                const loginBtn = document.getElementById('loginBtn');
                const btnText = document.getElementById('btnText');
                const btnLoader = document.getElementById('btnLoader');

                togglePassword.addEventListener('click', function (e) {
                    const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
                    passwordInput.setAttribute('type', type);
                    this.classList.toggle('fa-eye-slash');
                });

                function handleFormSubmit(e) {
                    e.preventDefault();
                    handleInitialLogin();
                }

                function showError(msg) {
                    errorBox.innerText = msg;
                    errorBox.style.display = 'block';
                    setTimeout(() => { errorBox.classList.remove('animate__shakeX'); void errorBox.offsetWidth; errorBox.classList.add('animate__animated', 'animate__shakeX'); }, 10);
                }

                function handleInitialLogin() {
                    const email = document.getElementById('email').value;
                    const passwordValue = document.getElementById('password').value;

                    if (!email || !passwordValue) {
                        showError("Please fill in both fields.");
                        return;
                    }

                    errorBox.style.display = 'none';
                    btnText.style.display = 'none';
                    btnLoader.style.display = 'block';
                    loginBtn.disabled = true;
                    setGlobalLoading(true, "Sending your 2FA code...");

                    const formData = new URLSearchParams();
                    formData.append('email', email);
                    formData.append('password', passwordValue);

                    const controller = new AbortController();
                    const timeoutId = setTimeout(() => controller.abort(), 30000);

                    const contextPath = document.getElementById('contextPath').value;
                    fetch(contextPath + '/auth/login-step1', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                        body: formData,
                        signal: controller.signal
                    })
                        .then(response => {
                            clearTimeout(timeoutId);
                            btnText.style.display = 'block';
                            btnLoader.style.display = 'none';
                            loginBtn.disabled = false;
                            setGlobalLoading(false);

                            if (response.ok) {
                                window.location.href = contextPath + '/auth/verify-2fa';
                            } else if (response.status === 401) {
                                const errorType = response.headers.get('X-Login-Error');
                                if (errorType === 'user_not_found') {
                                    showError("This email is not registered in our system.");
                                } else if (errorType === 'invalid_password') {
                                    showError("Incorrect password. Please try again.");
                                } else {
                                    showError("Invalid credentials.");
                                }
                            } else if (response.status === 503) {
                                const errorType = response.headers.get('X-Login-Error');
                                const errorDetail = response.headers.get('X-Error-Detail');
                                if (errorType === 'email_unavailable') {
                                    showError("Email 2FA is not configured yet. Please set it up below.");
                                    const box = document.getElementById('smtpSetupBox');
                                    if (box) box.style.display = 'block';
                                } else {
                                    let msg = "Email service is currently unavailable. Please try again later.";
                                    if (errorDetail) {
                                        msg += "\nDetails: " + errorDetail;
                                    }
                                    showError(msg);
                                }
                            } else {
                                showError("An unexpected error occurred.");
                            }
                        })
                        .catch(err => {
                            clearTimeout(timeoutId);
                            btnText.style.display = 'block';
                            btnLoader.style.display = 'none';
                            loginBtn.disabled = false;
                            setGlobalLoading(false);
                            if (err && err.name === 'AbortError') {
                                showError("Login timed out. Email service is taking too long.");
                            } else {
                                showError("Connection failed. Please check your internet.");
                            }
                        });
                }

                function setGlobalLoading(isLoading, msg = "Signing you in…") {
                    const overlay = document.getElementById('globalLoadingOverlay');
                    if (!overlay) return;
                    const textEl = overlay.querySelector('div[style*="font-weight:700"]');
                    if (textEl) textEl.innerText = msg;
                    overlay.style.display = isLoading ? 'flex' : 'none';
                }

                // If server forwarded back with SMTP setup error, ensure the box is visible.
                (function () {
                    const box = document.getElementById('smtpSetupBox');
                    if (box && box.dataset.serverError === 'true') {
                        box.style.display = 'block';
                    }
                })();
            </script>
        </body>

        </html>