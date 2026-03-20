<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>CourseVault | Sign Up</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/index.css">
            <link rel="preconnect" href="https://fonts.googleapis.com">
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
            <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&display=swap"
                rel="stylesheet">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css">
            <script src="https://unpkg.com/@dotlottie/player-component@2.7.12/dist/dotlottie-player.mjs"
                type="module"></script>
            <script src="https://challenges.cloudflare.com/turnstile/v0/api.js" async defer></script>
            <style>
                body {
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    background: radial-gradient(circle at top left, #FDFBFA 0%, #F5F3EF 100%);
                    margin: 0;
                    height: 100vh;
                    overflow: hidden;
                }

                .signup-container {
                    display: flex;
                    background: var(--card-bg);
                    backdrop-filter: blur(12px);
                    -webkit-backdrop-filter: blur(12px);
                    border: 1px solid var(--glass-border);
                    border-radius: 40px;
                    box-shadow: var(--shadow-premium);
                    width: 1050px;
                    min-height: 720px;
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

                .signup-form-area {
                    flex: 1.3;
                    padding: 3.5rem;
                    display: flex;
                    flex-direction: column;
                    justify-content: center;
                }

                .signup-animation-area {
                    flex: 1;
                    background: linear-gradient(135deg, #FFF9F2 0%, #FFF1E0 100%);
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    position: relative;
                }

                .signup-animation-area::after {
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
                }

                .form-row {
                    display: flex;
                    gap: 1.2rem;
                    margin-bottom: 1.2rem;
                }

                .form-group {
                    position: relative;
                    flex: 1;
                }

                .form-group label {
                    display: block;
                    margin-bottom: 0.6rem;
                    font-weight: 600;
                    font-size: 0.85rem;
                    color: #4B5563;
                    margin-left: 4px;
                }

                .form-group input,
                .form-group select {
                    width: 100%;
                    padding: 0.9rem 1.1rem;
                    background: rgba(255, 255, 255, 0.8);
                    border: 1px solid #E5E7EB;
                    border-radius: 14px;
                    outline: none;
                    transition: var(--transition-smooth);
                    font-family: inherit;
                    font-size: 0.95rem;
                    box-sizing: border-box;
                }

                .form-group input:focus,
                .form-group select:focus {
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

                .btn-signup {
                    width: 100%;
                    background: linear-gradient(135deg, #F8C697 0%, #f6b579 100%);
                    color: #333;
                    padding: 1.1rem;
                    border: none;
                    border-radius: 16px;
                    font-weight: 700;
                    cursor: pointer;
                    transition: var(--transition-smooth);
                    margin-top: 1rem;
                    font-size: 1.1rem;
                    box-shadow: 0 10px 20px rgba(248, 198, 151, 0.2);
                }

                .btn-signup:hover {
                    transform: translateY(-3px);
                    box-shadow: 0 15px 30px rgba(248, 198, 151, 0.3);
                }

                .login-link {
                    text-align: center;
                    margin-top: 1.5rem;
                    font-size: 0.95rem;
                    color: #6B7280;
                }

                .login-link a {
                    color: var(--accent-gold);
                    text-decoration: none;
                    font-weight: 700;
                    margin-left: 5px;
                }

                .login-link a:hover {
                    text-decoration: underline;
                }

                .captcha-container {
                    background: #F9FAFB;
                    border: 1px dashed #D1D5DB;
                    border-radius: 16px;
                    padding: 1rem;
                    margin: 1.5rem 0;
                }
            </style>
        </head>

        <body>
            <div class="signup-container">
                <div class="signup-animation-area">
                    <div class="lottie-skeleton"></div>
                    <dotlottie-player src="https://lottie.host/64a233a8-215c-4770-8786-0ade923d0b13/0t2RxapWsm.lottie"
                        style="width: 350px;height: 350px; position: relative; z-index: 1;" autoplay
                        loop></dotlottie-player>
                </div>
                <div class="signup-form-area">
                    <div class="header">
                        <h2>Create Account</h2>
                        <p>Join CourseVault to organize your academic materials</p>
                    </div>

                    <c:if test="${not empty error}">
                        <div style="
                            background: rgba(239, 68, 68, 0.10);
                            color: #B91C1C;
                            padding: 0.9rem 1rem;
                            border-radius: 14px;
                            margin-bottom: 1.25rem;
                            font-size: 0.95rem;
                            border-left: 4px solid #EF4444;
                        ">
                            <i class="fas fa-exclamation-circle" style="margin-right:8px;"></i>${error}
                        </div>
                    </c:if>

                    <form id="signupForm" action="${pageContext.request.contextPath}/auth/signup" method="POST">
                        <div class="form-row">
                            <div class="form-group">
                                <label>Full Name</label>
                                <input type="text" id="fullName" name="fullName" placeholder="John Doe" required>
                            </div>
                            <div class="form-group">
                                <label>Email Address</label>
                                <input type="email" id="email" name="email" placeholder="john@example.com" required>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label>Password</label>
                                <input type="password" name="password" id="password" placeholder="••••••••" required>
                                <i class="fas fa-eye password-toggle" id="togglePassword"></i>
                            </div>
                            <div class="form-group">
                                <label>Identify as</label>
                                <select name="role" required>
                                    <option value="STUDENT">Student</option>
                                    <option value="TEACHER">Teacher</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label>Security Question</label>
                                <select name="securityQuestion" required>
                                    <option value="Who is your favorite teacher?">Who is your favorite teacher?</option>
                                    <option value="What is your pet's name?">What is your pet's name?</option>
                                    <option value="What city were you born in?">What city were you born in?</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Security Answer</label>
                                <input type="text" name="securityAnswer" placeholder="Your answer" required>
                            </div>
                        </div>



                        <button type="submit" class="btn-signup">Complete Sign Up</button>
                    </form>

                    <div class="login-link">
                        Already have an account? <a href="${pageContext.request.contextPath}/auth/login">Login</a>
                    </div>
                </div>
            </div>

            <script>
                const togglePassword = document.querySelector('#togglePassword');
                const password = document.querySelector('#password');

                togglePassword.addEventListener('click', function (e) {
                    const type = password.getAttribute('type') === 'password' ? 'text' : 'password';
                    password.setAttribute('type', type);
                    this.classList.toggle('fa-eye-slash');
                });
            </script>
        </body>

        </html>