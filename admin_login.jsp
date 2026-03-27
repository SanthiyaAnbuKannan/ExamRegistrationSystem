<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Login - ExamReg Pro</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .admin-login-icon {
            width: 80px;
            height: 80px;
            background: var(--gradient);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 15px;
            animation: pulse 2s ease-in-out infinite;
        }
        @keyframes pulse {
            0%, 100% {
                transform: scale(1);
            }
            50% {
                transform: scale(1.05);
            }
        }
        .admin-login-icon i {
            font-size: 2.5rem;
            color: white;
        }
        @media (max-width: 768px) {
            .container {
                padding: 1rem;
            }
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark">
    <div class="container-fluid">
        <span class="navbar-brand">
            <i class="fas fa-graduation-cap me-2"></i>Exam Registration System
        </span>
        <div class="d-flex">
            <a href="index.jsp" class="btn btn-outline-light">
                <i class="fas fa-home me-2"></i>Home
            </a>
        </div>
    </div>
</nav>

<div class="container mt-5 col-md-4">
    <div class="card p-4">
        <div class="text-center mb-4">
            <div class="admin-login-icon">
                <i class="fas fa-user-shield"></i>
            </div>
            <h3 class="mt-2">Admin Login</h3>
            <p class="text-muted">Enter your credentials to access admin panel</p>
        </div>
        
        <!-- Error Messages -->
        <% if(request.getParameter("error") != null) { 
            String error = request.getParameter("error");
            if("invalid".equals(error)) {
        %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i>
                <strong>Invalid Credentials!</strong> Username or password is incorrect.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } else if("session".equals(error)) { %>
            <div class="alert alert-warning alert-dismissible fade show" role="alert">
                <i class="fas fa-clock me-2"></i>
                <strong>Session Expired!</strong> Please login again.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } else { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i>
                <strong>Login Failed!</strong> Invalid username or password.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>
        <% } %>
        
        <!-- Session Expired Message -->
        <% if(request.getParameter("expired") != null) { %>
            <div class="alert alert-warning alert-dismissible fade show" role="alert">
                <i class="fas fa-clock me-2"></i>
                <strong>Session Expired!</strong> Please login again.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>

        <!-- Login Form -->
        <form action="AdminLoginServlet" method="post">
            <div class="mb-3">
                <label class="form-label fw-bold">
                    <i class="fas fa-user me-1"></i>Username
                </label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fas fa-user"></i></span>
                    <input type="text" 
                           name="username" 
                           class="form-control" 
                           placeholder="Enter username"
                           value="<%= request.getParameter("username") != null ? request.getParameter("username") : "" %>"
                           required>
                </div>
            </div>
            
            <div class="mb-3">
                <label class="form-label fw-bold">
                    <i class="fas fa-lock me-1"></i>Password
                </label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fas fa-lock"></i></span>
                    <input type="password" 
                           name="password" 
                           class="form-control" 
                           placeholder="Enter password"
                           required>
                </div>
            </div>
            
            <!-- Remember Me Checkbox -->
            <div class="mb-3 form-check">
                <input type="checkbox" class="form-check-input" id="remember" name="remember">
                <label class="form-check-label" for="remember">Remember me</label>
            </div>
            
            <button type="submit" class="btn btn-primary w-100 py-2">
                <i class="fas fa-sign-in-alt me-2"></i>Login
            </button>
            
            <div class="text-end mt-2">
                <a href="#" class="text-decoration-none small">Forgot Password?</a>
            </div>
        </form>
        
        <div class="text-center mt-3">
            <p class="mb-0">Return to 
                <a href="index.jsp" class="text-decoration-none fw-bold">Home Page</a>
            </p>
        </div>
        
        <div class="text-center mt-2">
            <a href="index.jsp" class="text-decoration-none small">
                <i class="fas fa-arrow-left me-1"></i>Back to Home
            </a>
        </div>
        
        <!-- Admin Hint (for testing) -->
        <div class="text-center mt-3">
            <small class="text-muted">
                <i class="fas fa-info-circle me-1"></i>
                Demo Credentials: <strong>admin</strong> / <strong>123</strong>
            </small>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Auto-dismiss alerts after 5 seconds
    setTimeout(function() {
        var alerts = document.querySelectorAll('.alert');
        alerts.forEach(function(alert) {
            var bsAlert = new bootstrap.Alert(alert);
            bsAlert.close();
        });
    }, 5000);
</script>

</body>
</html>