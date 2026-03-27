<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <title>Student Login - ExamReg Pro</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .login-header-icon {
            width: 80px;
            height: 80px;
            background: var(--gradient);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 15px;
        }
        .login-header-icon i {
            font-size: 2.5rem;
            color: white;
        }
        .forgot-password {
            font-size: 0.85rem;
            transition: all 0.3s ease;
        }
        .forgot-password:hover {
            letter-spacing: 0.5px;
        }
        @media (max-width: 768px) {
            .container {
                padding: 1rem;
            }
            .card {
                margin: 10px;
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
            <div class="login-header-icon">
                <i class="fas fa-user-graduate"></i>
            </div>
            <h3 class="mt-3">Student Login</h3>
            <p class="text-muted">Enter your credentials to access your account</p>
        </div>

        <!-- Error Message -->
        <% if(request.getParameter("error") != null) { 
            String error = request.getParameter("error");
            if("invalid".equals(error)) {
        %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i>
                <strong>Invalid Credentials!</strong> Email or password is incorrect.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } else if("empty".equals(error)) { %>
            <div class="alert alert-warning alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i>
                <strong>Empty Fields!</strong> Please fill all fields.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } else { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i>
                <strong>Login Failed!</strong> Invalid email or password.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>
        <% } %>
        
        <!-- Success Message for Registration -->
        <% if(request.getParameter("success") != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert" id="successAlert">
                <i class="fas fa-check-circle me-2"></i>
                <strong>Registration Successful!</strong> Your account has been created. Please login with your credentials.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                <small class="d-block mt-1 text-success-emphasis" id="timerText">
                    This message will auto-dismiss in 5 seconds...
                </small>
            </div>
        <% } %>

        <form action="<%= request.getContextPath() %>/LoginServlet" method="post">
            <div class="mb-3">
                <label class="form-label fw-bold">Email Address</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                    <input type="email" 
                           name="email" 
                           class="form-control" 
                           placeholder="Enter your email" 
                           value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>"
                           required>
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label fw-bold">Password</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fas fa-lock"></i></span>
                    <input type="password" 
                           name="password" 
                           class="form-control" 
                           placeholder="Enter your password" 
                           required>
                </div>
            </div>

            <!-- Remember me and Forgot Password Row -->
            <div class="d-flex justify-content-between align-items-center mb-3">
                <div class="form-check">
                    <input type="checkbox" class="form-check-input" id="remember" name="remember">
                    <label class="form-check-label" for="remember">Remember me</label>
                </div>
                <a href="forgot_password.jsp" class="forgot-password text-decoration-none">
                    <i class="fas fa-key me-1"></i>Forgot Password?
                </a>
            </div>

            <button type="submit" class="btn btn-primary w-100 py-2">
                <i class="fas fa-sign-in-alt me-2"></i>Login
            </button>
        </form>

        <div class="text-center mt-3">
            <p class="mb-0">New User? 
                <a href="register.jsp" class="text-decoration-none fw-bold">Register Here</a>
            </p>
        </div>
        
        <div class="text-center mt-2">
            <a href="index.jsp" class="text-decoration-none small">
                <i class="fas fa-arrow-left me-1"></i>Back to Home
            </a>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Auto-dismiss success message with countdown
    var successAlert = document.getElementById('successAlert');
    if (successAlert) {
        var timer = 5;
        var timerText = document.getElementById('timerText');
        
        var countdown = setInterval(function() {
            timer--;
            if (timerText) {
                timerText.textContent = 'This message will auto-dismiss in ' + timer + ' seconds...';
            }
            
            if (timer <= 0) {
                clearInterval(countdown);
                var bsAlert = new bootstrap.Alert(successAlert);
                bsAlert.close();
            }
        }, 1000);
        
        setTimeout(function() {
            var bsAlert = new bootstrap.Alert(successAlert);
            bsAlert.close();
        }, 5000);
    }
    
    // Auto-dismiss other alerts after 5 seconds
    setTimeout(function() {
        var alerts = document.querySelectorAll('.alert:not(#successAlert)');
        alerts.forEach(function(alert) {
            var bsAlert = new bootstrap.Alert(alert);
            bsAlert.close();
        });
    }, 5000);
</script>

</body>
</html>