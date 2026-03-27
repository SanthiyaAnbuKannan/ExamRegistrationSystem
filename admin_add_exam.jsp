<%
String admin = (String) session.getAttribute("admin");
if(admin == null){
    response.sendRedirect("admin_login.jsp");
    return;
}
%>
<!DOCTYPE html>
<html>
<head>
    <title>Add Exam - ExamReg Pro</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .add-exam-icon {
            width: 80px;
            height: 80px;
            background: var(--gradient-success);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 15px;
        }
        .add-exam-icon i {
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
            <i class="fas fa-plus-circle me-2"></i>Add New Exam
        </span>
        <div class="d-flex">
            <a href="admin.jsp" class="btn btn-outline-light">
                <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
            </a>
        </div>
    </div>
</nav>

<div class="container mt-5 col-md-6">
    <div class="card p-4">
        
        <!-- Page Header -->
        <div class="text-center mb-4">
            <div class="add-exam-icon">
                <i class="fas fa-calendar-plus"></i>
            </div>
            <h3 class="mt-2">Add New Exam</h3>
            <p class="text-muted">Create a new exam for students to register</p>
        </div>

        <!-- Error Message -->
        <% if("exists".equals(request.getParameter("error"))) { %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i>
                <strong>Exam Already Exists!</strong> An exam with this subject name already exists for this semester.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <% } %>
        
        <!-- Success Message -->
        <% if("1".equals(request.getParameter("success"))) { %>
            <div class="alert alert-success alert-dismissible fade show" role="alert" id="successAlert">
                <i class="fas fa-check-circle me-2"></i>
                <strong>Exam Added Successfully!</strong> The exam has been added to the system.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                <small class="d-block mt-1 text-success-emphasis" id="timerText">
                    This message will auto-dismiss in 5 seconds...
                </small>
            </div>
        <% } %>

        <form action="AdminAddExamServlet" method="post">
            
            <!-- Subject Name -->
            <div class="mb-3">
                <label class="form-label fw-bold required-field">Subject Name</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fas fa-book-open"></i></span>
                    <input type="text" 
                           name="subject"
                           class="form-control"
                           placeholder="Enter subject name" 
                           required>
                </div>
                <small class="text-muted">
                    <i class="fas fa-info-circle me-1"></i>
                    Example: Mathematics, Physics, Computer Science, etc.
                </small>
            </div>

            <!-- Semester Selection -->
            <div class="mb-3">
                <label class="form-label fw-bold required-field">Semester</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fas fa-layer-group"></i></span>
                    <select name="semester" class="form-control" required>
                        <option value="">Select Semester</option>
                        <option value="1">Semester 1</option>
                        <option value="2">Semester 2</option>
                        <option value="3">Semester 3</option>
                        <option value="4">Semester 4</option>
                        <option value="5">Semester 5</option>
                        <option value="6">Semester 6</option>
                        <option value="7">Semester 7</option>
                        <option value="8">Semester 8</option>
                    </select>
                </div>
            </div>

            <!-- Exam Date -->
            <div class="mb-3">
                <label class="form-label fw-bold required-field">Exam Date</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fas fa-calendar-day"></i></span>
                    <input type="date" 
                           name="date"
                           class="form-control" 
                           required>
                </div>
                <small class="text-muted">
                    <i class="fas fa-info-circle me-1"></i>
                    Select the date when the exam will be conducted
                </small>
            </div>

            <!-- Submit Button -->
            <button type="submit" class="btn btn-success w-100 py-2">
                <i class="fas fa-plus-circle me-2"></i>Add Exam
            </button>
        </form>

        <!-- Quick Info -->
        <div class="alert alert-info mt-4 mb-0">
            <i class="fas fa-info-circle me-2"></i>
            <strong>Note:</strong> Make sure to add exams for the correct semester. Students will only see exams matching their enrolled semester.
        </div>
        
        <div class="text-center mt-3">
            <a href="admin.jsp" class="text-decoration-none small">
                <i class="fas fa-arrow-left me-1"></i>Back to Dashboard
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
    
    // Set minimum date to today
    var dateInput = document.querySelector('input[type="date"]');
    if(dateInput) {
        var today = new Date().toISOString().split('T')[0];
        dateInput.setAttribute('min', today);
    }
</script>

</body>
</html>