<%@ page language="java" %>
<%
Integer studentId = (Integer) session.getAttribute("student_id");
if(studentId == null){
    response.sendRedirect("login.jsp");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Profile - ExamReg Pro</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <style>
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
        .form-control:read-only {
            background-color: #e9ecef;
            cursor: not-allowed;
        }
        .required-field::after {
            content: " *";
            color: var(--danger);
            font-weight: bold;
        }
        .edit-header-icon {
            width: 80px;
            height: 80px;
            background: var(--gradient);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto;
        }
        .edit-header-icon i {
            font-size: 2rem;
            color: white;
        }
        @media (max-width: 768px) {
            .form-section {
                padding: 15px;
            }
            .btn {
                margin-bottom: 10px;
            }
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark">
    <div class="container-fluid">
        <span class="navbar-brand">
            <i class="fas fa-user-edit me-2"></i>Edit Profile
        </span>
        <div class="d-flex">
            <span class="navbar-text me-3">
                <i class="fas fa-user me-1"></i> <%= session.getAttribute("student_name") %>
            </span>
            <a href="profile.jsp" class="btn btn-outline-light">
                <i class="fas fa-arrow-left me-2"></i>Back to Profile
            </a>
        </div>
    </div>
</nav>

<div class="container mt-4 col-md-8">
    <div class="card p-4">
        
        <!-- Page Header -->
        <div class="text-center mb-4">
            <div class="edit-header-icon">
                <i class="fas fa-user-edit"></i>
            </div>
            <h3 class="mt-3">Edit Your Profile</h3>
            <p class="text-muted">Update your personal information below</p>
        </div>
        
        <!-- Success/Error Messages -->
        <% if(request.getParameter("success") != null) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i>
                <strong>Success!</strong> Your profile has been updated successfully.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>
        
        <% if(request.getParameter("error") != null) { 
            String error = request.getParameter("error");
            if("db".equals(error)) {
        %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i>
                <strong>Database Error!</strong> Could not update profile. Please try again.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } else if("phone".equals(error)) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i>
                <strong>Invalid Phone!</strong> Please enter a valid 10-digit phone number.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } } %>

        <form action="UpdateProfileServlet" method="post" id="editProfileForm">
            
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
                                       value="<%= session.getAttribute("student_name") %>" 
                                       required>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label class="form-label fw-bold">Email Address</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                                <input type="email" 
                                       name="email" 
                                       class="form-control"
                                       value="<%= session.getAttribute("student_email") %>" 
                                       readonly
                                       required>
                            </div>
                            <small class="text-muted">
                                <i class="fas fa-info-circle me-1"></i>Email cannot be changed
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
                                       value="<%= session.getAttribute("student_college") %>" 
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
                                       value="<%= session.getAttribute("student_department") %>" 
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
                                    <% String currentSem = (String) session.getAttribute("student_semester"); %>
                                    <option value="1" <%= "1".equals(currentSem) ? "selected" : "" %>>1st Semester</option>
                                    <option value="2" <%= "2".equals(currentSem) ? "selected" : "" %>>2nd Semester</option>
                                    <option value="3" <%= "3".equals(currentSem) ? "selected" : "" %>>3rd Semester</option>
                                    <option value="4" <%= "4".equals(currentSem) ? "selected" : "" %>>4th Semester</option>
                                    <option value="5" <%= "5".equals(currentSem) ? "selected" : "" %>>5th Semester</option>
                                    <option value="6" <%= "6".equals(currentSem) ? "selected" : "" %>>6th Semester</option>
                                    <option value="7" <%= "7".equals(currentSem) ? "selected" : "" %>>7th Semester</option>
                                    <option value="8" <%= "8".equals(currentSem) ? "selected" : "" %>>8th Semester</option>
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
                                    <% String currentYear = (String) session.getAttribute("student_year"); %>
                                    <option value="1" <%= "1".equals(currentYear) ? "selected" : "" %>>1st Year</option>
                                    <option value="2" <%= "2".equals(currentYear) ? "selected" : "" %>>2nd Year</option>
                                    <option value="3" <%= "3".equals(currentYear) ? "selected" : "" %>>3rd Year</option>
                                    <option value="4" <%= "4".equals(currentYear) ? "selected" : "" %>>4th Year</option>
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
                                       value="<%= session.getAttribute("student_regno") %>" 
                                       pattern="[A-Za-z0-9]+"
                                       title="Only letters and numbers allowed"
                                       required>
                            </div>
                            <small class="text-muted">
                                <i class="fas fa-info-circle me-1"></i>Max 12 characters, letters & numbers only
                            </small>
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
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label class="form-label fw-bold required-field">Phone Number</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-phone"></i></span>
                                <input type="tel" 
                                       name="phone" 
                                       class="form-control"
                                       value="<%= session.getAttribute("student_phone") %>" 
                                       pattern="[0-9]{10}"
                                       maxlength="10"
                                       oninput="this.value = this.value.replace(/[^0-9]/g, '')"
                                       title="Please enter a valid 10-digit phone number"
                                       required>
                            </div>
                            <small class="text-muted">
                                <i class="fas fa-info-circle me-1"></i>Enter 10-digit mobile number (numbers only)
                            </small>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="mb-3">
                            <label class="form-label fw-bold required-field">Address</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="fas fa-map-marker-alt"></i></span>
                                <textarea name="address" 
                                          class="form-control" 
                                          rows="3"
                                          required><%= session.getAttribute("student_address") %></textarea>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Form Actions -->
            <div class="row mt-4 g-3">
                <div class="col-md-6">
                    <button type="submit" class="btn btn-success w-100 py-2">
                        <i class="fas fa-save me-2"></i>Update Profile
                    </button>
                </div>
                <div class="col-md-6">
                    <a href="profile.jsp" class="btn btn-secondary w-100 py-2">
                        <i class="fas fa-times me-2"></i>Cancel
                    </a>
                </div>
            </div>
            
        </form>
        
        <div class="text-center mt-4">
            <a href="profile.jsp" class="text-decoration-none small">
                <i class="fas fa-arrow-left me-1"></i>Back to Profile
            </a>
        </div>
        
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Restrict phone input to numbers only (real-time)
    const phoneInput = document.querySelector('input[name="phone"]');
    if(phoneInput) {
        phoneInput.addEventListener('input', function(e) {
            this.value = this.value.replace(/[^0-9]/g, '');
        });
    }
    
    // Form submission validation
    document.getElementById('editProfileForm').addEventListener('submit', function(e) {
        let phone = document.querySelector('input[name="phone"]').value;
        let regno = document.querySelector('input[name="regno"]').value;
        
        // Phone validation
        if(phone.length !== 10) {
            e.preventDefault();
            alert('Please enter a valid 10-digit phone number');
            return false;
        }
        
        // Register number validation
        if(regno.length === 0 || regno.length > 12) {
            e.preventDefault();
            alert('Register number must be between 1-12 characters');
            return false;
        }
    });
    
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