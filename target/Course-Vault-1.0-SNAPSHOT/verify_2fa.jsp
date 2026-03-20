<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CourseVault | Verify Code</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/index.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            display: flex; align-items: center; justify-content: center;
            background: radial-gradient(circle at top left, #FDFBFA 0%, #F5F3EF 100%);
            margin: 0; min-height: 100vh; font-family: 'Outfit', sans-serif;
        }
        .verify-container {
            background: var(--card-bg, #fff);
            border-radius: 32px;
            border: 1px solid var(--glass-border, #e5e7eb);
            box-shadow: 0 20px 60px rgba(0,0,0,0.08);
            padding: 3rem 3.25rem;
            width: min(500px, calc(100vw - 2rem));
        }
        h2 { font-size: 2rem; font-weight: 700; color: #1F2937; margin: 0 0 0.4rem; }
        .subtitle { color: #6B7280; font-size: 0.95rem; margin-bottom: 2rem; }
        .error-msg {
            background: rgba(239,68,68,0.08); color: #B91C1C;
            padding: 0.9rem 1rem; border-radius: 12px; margin-bottom: 1.25rem;
            font-size: 0.9rem; border-left: 4px solid #EF4444;
        }
        .code-input {
            width: 100%; padding: 1.1rem; border-radius: 16px;
            border: 1px solid #E5E7EB; font-size: 1.5rem;
            letter-spacing: 0.5em; text-align: center; font-weight: 700;
            outline: none; box-sizing: border-box;
        }
        .code-input:focus { border-color: #F8C697; box-shadow: 0 0 0 4px rgba(248,198,151,0.2); }
        .btn-verify {
            width: 100%; margin-top: 1.25rem; padding: 1.05rem;
            border-radius: 16px; border: none;
            background: linear-gradient(135deg, #F8C697 0%, #f6b579 100%);
            font-weight: 700; cursor: pointer; font-size: 1rem; color: #333;
            box-shadow: 0 10px 20px rgba(248,198,151,0.3);
        }
        .btn-resend {
            margin-top: 1rem; background: transparent;
            border: 1px solid #E5E7EB; padding: 0.7rem 1.2rem;
            border-radius: 14px; font-weight: 600; cursor: pointer;
            color: #374151; font-size: 0.9rem; transition: 0.2s;
        }
        .btn-resend:disabled { opacity: 0.5; cursor: not-allowed; }
        .btn-resend:not(:disabled):hover { border-color: #F8C697; }
        .resend-area { margin-top: 1rem; text-align: center; }
        #statusMsg { margin-top: 0.6rem; font-size: 0.88rem; color: #6B7280; }
        .back-link { margin-top: 1.75rem; text-align: center; font-size: 0.9rem; }
        .back-link a { color: #6B7280; text-decoration: none; font-weight: 600; }
    </style>
</head>
<body>
<c:if test="${empty sessionScope.pending2FAUser and empty sessionScope.pendingSignupUser}">
    <c:redirect url="/auth/login"/>
</c:if>

<div class="verify-container">
    <h2>Verify Identity</h2>
    <p class="subtitle">A 6-digit code was sent to your email. Enter it below to continue.</p>

    <c:if test="${not empty error}">
        <div class="error-msg"><i class="fas fa-exclamation-circle" style="margin-right:6px;"></i>${error}</div>
    </c:if>

    <form method="POST" action="${pageContext.request.contextPath}/auth/verify-2fa">
        <input type="hidden" name="type" value="${param.type}">
        <input type="text" name="code" maxlength="6" class="code-input"
               placeholder="000000" required inputmode="numeric" autocomplete="one-time-code" autofocus>
        <button type="submit" class="btn-verify">Verify Code</button>
    </form>

    <div class="resend-area">
        <button id="resendBtn" type="button" class="btn-resend">Didn't get it? Resend</button>
        <div id="statusMsg"></div>
    </div>

    <div class="back-link">
        <a href="${pageContext.request.contextPath}/auth/login">&larr; Back to Login</a>
    </div>
</div>

<script>
    var resendBtn = document.getElementById('resendBtn');
    var statusMsg = document.getElementById('statusMsg');
    var ctx = '${pageContext.request.contextPath}';

    resendBtn.addEventListener('click', function() {
        resendBtn.disabled = true;
        statusMsg.textContent = 'Sending a new code...';

        fetch(ctx + '/auth/resend-2fa', {
            method: 'POST',
            headers: { 'X-Requested-With': 'XMLHttpRequest' }
        }).then(function(res) {
            if (res.ok) {
                statusMsg.textContent = 'New code sent! Check your inbox.';
            } else if (res.status === 401) {
                window.location.href = ctx + '/auth/login';
            } else {
                statusMsg.textContent = 'Could not send code. Please try again.';
                resendBtn.disabled = false;
            }
        }).catch(function() {
            statusMsg.textContent = 'Network error. Please try again.';
            resendBtn.disabled = false;
        }).then(function() {
            setTimeout(function() { resendBtn.disabled = false; }, 20000);
        });
    });
</script>
</body>
</html>
