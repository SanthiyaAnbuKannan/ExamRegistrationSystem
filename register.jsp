<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Student Registration - ExamReg Pro</title>
    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="css/style.css">
    
    <style>
        /* Additional styles specific to registration page */
        .form-section {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 15px;
            margin-bottom: 20px;
            transition: all 0.3s ease;
        }
        .form-section:hover {
            box-shadow: var(--shadow-sm);
        }
        .section-title {
            color: var(--primary);
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid var(--primary);
        }
        .section-title i {
            margin-right: 10px;
        }
        .required-field::after {
            content: " *";
            color: var(--danger);
            font-weight: bold;
        }
        .header-icon {
            width: 80px;
            height: 80px;
            background: var(--gradient-success);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 15px;
        }
        .header-icon i {
            font-size: 2.5rem;
            color: white;
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container-fluid">
            <span class="navbar-brand">
                <i class="fas fa-graduation-cap me-2"></i>Exam Registration System
            </span>
            <div class="d-flex">
                <a href="login.jsp" class="btn btn-outline-light me-2">
                    <i class="fas fa-sign-in-alt me-2"></i>Login
                </a>
                <a href="index.jsp" class="btn btn-outline-light">
                    <i class="fas fa-home me-2"></i>Home
                </a>
            </div>
        </div>
    </nav>

    <div class="container mt-4 col-md-8">
        <div class="card p-4">
            <!-- Header -->
            <div class="text-center mb-4">
                <div class="header-icon">
                    <i class="fas fa-user-plus"></i>
                </div>
                <h3 class="mt-2">Student Registration</h3>
                <p class="text-muted">Fill in your details to create an account</p>
            </div>

            <!-- Error Messages -->
            <% if("emailExists".equals(request.getParameter("error"))) { %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i>
                    <strong>Email Already Registered!</strong> This email is already in use. 
                    <a href="login.jsp" class="alert-link">Login here</a> or use a different email.
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            <% } %>
            
            <% if("passwordLength".equals(request.getParameter("error"))) { %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i>
                    <strong>Invalid Password!</strong> Password must be at least 6 characters long.
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            <% } %>
            
            <% if("phone".equals(request.getParameter("error"))) { %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i>
                    <strong>Invalid Phone Number!</strong> Please enter a valid 10-digit number (numbers only).
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            <% } %>
            
            <% if("database".equals(request.getParameter("error"))) { %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-database me-2"></i>
                    <strong>Registration Failed!</strong> Something went wrong. Please try again later.
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            <% } %>

            <form action="RegisterServlet" method="post" id="registrationForm">
                <!-- Personal Information Section -->
                <div class="form-section">
                    <div class="section-title">
                        <i class="fas fa-user-circle"></i> Personal Information
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label fw-bold required-field">Full Name</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-user"></i></span>
                                    <input type="text" 
                                           name="name" 
                                           class="form-control" 
                                           placeholder="Enter your full name"
                                           value="<%= request.getParameter("name") != null ? request.getParameter("name") : "" %>"
                                           required>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label fw-bold required-field">Email Address</label>
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
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label fw-bold required-field">Password</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-lock"></i></span>
                                    <input type="password" 
                                           name="password" 
                                           class="form-control" 
                                           placeholder="Create a password"
                                           minlength="6"
                                           required>
                                </div>
                                <small class="text-muted">
                                    <i class="fas fa-info-circle me-1"></i>
                                    Minimum 6 characters required
                                </small>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label fw-bold required-field">Phone Number</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-phone"></i></span>
                                    <input type="text"
                                           name="phone"
                                           class="form-control"
                                           placeholder="10-digit mobile number"
                                           maxlength="10"
                                           oninput="this.value = this.value.replace(/[^0-9]/g, '')"
                                           title="Please enter numbers only"
                                           value="<%= request.getParameter("phone") != null ? request.getParameter("phone") : "" %>"
                                           required>
                                </div>
                                <small class="text-muted">
                                    <i class="fas fa-info-circle me-1"></i>
                                    Enter 10-digit number (numbers only)
                                </small>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Academic Information Section -->
                <div class="form-section">
                    <div class="section-title">
                        <i class="fas fa-graduation-cap"></i> Academic Information
                    </div>
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label fw-bold required-field">College</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-university"></i></span>
                                    <input type="text" 
                                           name="college" 
                                           class="form-control" 
                                           placeholder="Enter your college name"
                                           value="<%= request.getParameter("college") != null ? request.getParameter("college") : "" %>"
                                           required>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label fw-bold required-field">Department</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-book"></i></span>
                                    <input type="text" 
                                           name="department" 
                                           class="form-control" 
                                           placeholder="Enter your department"
                                           value="<%= request.getParameter("department") != null ? request.getParameter("department") : "" %>"
                                           required>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="row">
                        <div class="col-md-4">
                            <div class="mb-3">
                                <label class="form-label fw-bold required-field">Semester</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-layer-group"></i></span>
                                    <select name="semester" class="form-control" required>
                                        <option value="">Select Semester</option>
                                        <% String selectedSem = request.getParameter("semester"); %>
                                        <option value="1" <%= "1".equals(selectedSem) ? "selected" : "" %>>1st Semester</option>
                                        <option value="2" <%= "2".equals(selectedSem) ? "selected" : "" %>>2nd Semester</option>
                                        <option value="3" <%= "3".equals(selectedSem) ? "selected" : "" %>>3rd Semester</option>
                                        <option value="4" <%= "4".equals(selectedSem) ? "selected" : "" %>>4th Semester</option>
                                        <option value="5" <%= "5".equals(selectedSem) ? "selected" : "" %>>5th Semester</option>
                                        <option value="6" <%= "6".equals(selectedSem) ? "selected" : "" %>>6th Semester</option>
                                        <option value="7" <%= "7".equals(selectedSem) ? "selected" : "" %>>7th Semester</option>
                                        <option value="8" <%= "8".equals(selectedSem) ? "selected" : "" %>>8th Semester</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="mb-3">
                                <label class="form-label fw-bold required-field">Year</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-calendar"></i></span>
                                    <select name="year" class="form-control" required>
                                        <option value="">Select Year</option>
                                        <% String selectedYear = request.getParameter("year"); %>
                                        <option value="1" <%= "1".equals(selectedYear) ? "selected" : "" %>>1st Year</option>
                                        <option value="2" <%= "2".equals(selectedYear) ? "selected" : "" %>>2nd Year</option>
                                        <option value="3" <%= "3".equals(selectedYear) ? "selected" : "" %>>3rd Year</option>
                                        <option value="4" <%= "4".equals(selectedYear) ? "selected" : "" %>>4th Year</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="mb-3">
                                <label class="form-label fw-bold required-field">Register Number</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-id-card"></i></span>
                                    <input type="text" 
                                           name="regno" 
                                           maxlength="12" 
                                           class="form-control" 
                                           placeholder="e.g., 2021CS001"
                                           pattern="[A-Za-z0-9]+"
                                           title="Only letters and numbers allowed"
                                           value="<%= request.getParameter("regno") != null ? request.getParameter("regno") : "" %>"
                                           required>
                                </div>
                                <small class="text-muted">Max 12 characters (letters & numbers only)</small>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Contact Information Section -->
                <div class="form-section">
                    <div class="section-title">
                        <i class="fas fa-address-card"></i> Contact Information
                    </div>
                    <div class="row">
                        <div class="col-12">
                            <div class="mb-3">
                                <label class="form-label fw-bold required-field">Address</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="fas fa-map-marker-alt"></i></span>
                                    <textarea name="address" 
                                              class="form-control" 
                                              rows="3"
                                              placeholder="Enter your full address"
                                              required><%= request.getParameter("address") != null ? request.getParameter("address") : "" %></textarea>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Submit Button -->
                <button type="submit" class="btn btn-success w-100 py-2">
                    <i class="fas fa-user-plus me-2"></i>Create Account
                </button>
            </form>

            <div class="text-center mt-3">
                <p class="mb-0">Already have an account? 
                    <a href="login.jsp" class="text-decoration-none fw-bold">Login here</a>
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
        // Restrict phone input to numbers only
        const phoneInput = document.querySelector('input[name="phone"]');
        if(phoneInput) {
            phoneInput.addEventListener('input', function(e) {
                this.value = this.value.replace(/[^0-9]/g, '');
            });
        }

        // Auto-dismiss alerts after 5 seconds
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);
    </script>
</body>
</html>