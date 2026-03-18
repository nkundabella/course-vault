<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>CourseVault | Reset Password</title>
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
                    font-family: 'Outfit', sans-serif;
                }

                .reset-container {
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

                .form-area {
                    flex: 1.2;
                    padding: 3.5rem;
                    display: flex;
                    flex-direction: column;
                    justify-content: center;
                }

                .animation-area {
                    flex: 1;
                    background: linear-gradient(135deg, #F0F9FF 0%, #E0F2FE 100%);
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    position: relative;
                }

                .animation-area::after {
                    content: '';
                    position: absolute;
                    width: 100%;
                    height: 100%;
                    background: url('https://www.transparenttextures.com/patterns/cubes.png');
                    opacity: 0.03;
                    pointer-events: none;
                }

                .header h2 {
                    font-size: 2.2rem;
                    margin-bottom: 0.5rem;
                    font-weight: 700;
                    color: #1F2937;
                    letter-spacing: -1px;
                }

                .header p {
                    color: #6B7280;
                    margin-bottom: 2rem;
                    font-size: 1rem;
                    line-height: 1.5;
                }

                .form-group {
                    margin-bottom: 1.5rem;
                    position: relative;
                }

                .form-group label {
                    display: block;
                    margin-bottom: 0.6rem;
                    font-weight: 600;
                    font-size: 0.85rem;
                    color: #4B5563;
                    margin-left: 4px;
                }

                .form-group input {
                    width: 100%;
                    padding: 1.1rem;
                    padding-right: 3rem;
                    background: rgba(255, 255, 255, 0.8);
                    border: 1px solid #E5E7EB;
                    border-radius: 16px;
                    outline: none;
                    transition: var(--transition-smooth);
                    font-family: inherit;
                    font-size: 0.95rem;
                    box-sizing: border-box;
                }

                .form-group input:focus {
                    border-color: var(--accent-gold);
                    background: white;
                    box-shadow: 0 0 0 4px rgba(166, 139, 91, 0.1);
                    transform: translateY(-1px);
                }

                .password-toggle {
                    position: absolute;
                    right: 18px;
                    top: 42px;
                    cursor: pointer;
                    color: #9CA3AF;
                    transition: color 0.3s;
                    z-index: 2;
                }

                .password-toggle:hover {
                    color: var(--accent-gold);
                }

                .btn-reset {
                    width: 100%;
                    background: linear-gradient(135deg, #F8C697 0%, #f6b579 100%);
                    color: #333;
                    padding: 1.2rem;
                    border: none;
                    border-radius: 18px;
                    font-weight: 700;
                    cursor: pointer;
                    transition: var(--transition-smooth);
                    margin-top: 1rem;
                    font-size: 1.1rem;
                    box-shadow: 0 10px 20px rgba(248, 198, 151, 0.2);
                }

                .btn-reset:hover {
                    transform: translateY(-3px);
                    box-shadow: 0 15px 30px rgba(248, 198, 151, 0.3);
                }

                .error-msg {
                    background: rgba(239, 68, 68, 0.1);
                    color: #EF4444;
                    padding: 1rem;
                    border-radius: 14px;
                    margin-bottom: 1.5rem;
                    font-size: 0.9rem;
                    text-align: center;
                    border: 1px solid rgba(239, 68, 68, 0.2);
                    animation: shake 0.5s cubic-bezier(.36, .07, .19, .97) both;
                }

                /* Skeleton */
                .lottie-skeleton {
                    width: 350px;
                    height: 350px;
                    background: rgba(0, 0, 0, 0.02);
                    border-radius: 50%;
                    position: absolute;
                }

                @media (max-width: 980px) {
                    .reset-container {
                        flex-direction: column;
                        min-height: unset;
                    }
                    .form-area {
                        padding: 2.5rem;
                    }
                    .animation-area {
                        min-height: 260px;
                    }
                    .lottie-skeleton {
                        width: 260px;
                        height: 260px;
                    }
                }
            </style>
        </head>

        <body>
            <c:if test="${empty sessionScope.resetPasswordEmail}">
                <c:redirect url="/auth/forgot-password" />
            </c:if>

            <div class="reset-container">
                <div class="animation-area">
                    <div class="lottie-skeleton"></div>
                    <dotlottie-player
                        src="https://assets4.lottiefiles.com/packages/lf20_32NcN8.json"
                        style="width: 400px; height: 400px; position: relative; z-index: 1;" autoplay loop>
                    </dotlottie-player>
                </div>

                <div class="form-area">
                    <div class="header">
                        <h2>Secure Your Account</h2>
                        <p>Choose a strong password that you haven't used before. Aim for at least 8 characters.</p>
                    </div>

                    <c:if test="${not empty error}">
                        <div class="error-msg">
                            <i class="fas fa-exclamation-circle" style="margin-right: 8px;"></i>
                            ${error}
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/auth/update-password" method="POST"
                        onsubmit="return validatePasswords()">
                        <div class="form-group">
                            <label>New Password</label>
                            <input type="password" id="newPassword" name="newPassword" placeholder="••••••••" required>
                            <i class="fas fa-eye password-toggle" onclick="togglePass('newPassword', this)"></i>
                        </div>
                        <div class="form-group">
                            <label>Confirm Password</label>
                            <input type="password" id="confirmPassword" name="confirmPassword" placeholder="••••••••"
                                required>
                            <i class="fas fa-eye password-toggle" onclick="togglePass('confirmPassword', this)"></i>
                        </div>

                        <button type="submit" class="btn-reset">Update Password</button>
                    </form>
                </div>
            </div>

            <script>
                function togglePass(id, btn) {
                    const input = document.getElementById(id);
                    if (input.type === 'password') {
                        input.type = 'text';
                        btn.classList.add('fa-eye-slash');
                    } else {
                        input.type = 'password';
                        btn.classList.remove('fa-eye-slash');
                    }
                }

                function validatePasswords() {
                    const p1 = document.getElementById('newPassword').value;
                    const p2 = document.getElementById('confirmPassword').value;
                    if (p1 !== p2) {
                        const errBox = document.createElement('div');
                        errBox.className = 'error-msg';
                        errBox.innerHTML = '<i class="fas fa-exclamation-circle" style="margin-right: 8px;"></i> Passwords do not match!';
                        const existingErr = document.querySelector('.error-msg');
                        if (existingErr) existingErr.remove();
                        document.querySelector('.header').after(errBox);
                        return false;
                    }
                    return true;
                }
            </script>
        </body>

        </html>