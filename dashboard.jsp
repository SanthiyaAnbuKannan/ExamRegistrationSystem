<%
Integer studentId = (Integer) session.getAttribute("student_id");
if(studentId == null){
    response.sendRedirect("login.jsp");
    return;
}
String studentName = (String) session.getAttribute("student_name");
%>

<%@ page import="util.DBConnection" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Student Dashboard - ExamReg Pro</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .welcome-section {
            text-align: center;
            margin-bottom: 30px;
        }
        .welcome-icon {
            width: 100px;
            height: 100px;
            background: var(--gradient);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
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
        .welcome-icon i {
            font-size: 3rem;
            color: white;
        }
        .stats-card {
            background: white;
            border-radius: 15px;
            padding: 20px;
            text-align: center;
            box-shadow: var(--shadow-sm);
            transition: all 0.3s ease;
            height: 100%;
        }
        .stats-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-md);
        }
        .stats-number {
            font-size: 2rem;
            font-weight: 700;
            color: var(--primary);
        }
        .stats-label {
            color: #777;
            font-size: 0.9rem;
        }
        .alert-today {
            background: linear-gradient(135deg, #ff6b6b, #ee5a5a);
            color: white;
            border: none;
            border-radius: 15px;
            animation: slideInDown 0.5s ease;
        }
        .alert-tomorrow {
            background: linear-gradient(135deg, #ffd93d, #ffc107);
            color: #333;
            border: none;
            border-radius: 15px;
        }
        @keyframes slideInDown {
            from {
                transform: translateY(-30px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }
        @media (max-width: 768px) {
            .dashboard-card {
                margin-bottom: 20px;
            }
            .welcome-icon {
                width: 80px;
                height: 80px;
            }
            .welcome-icon i {
                font-size: 2rem;
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
            <span class="navbar-text me-3">
                <i class="fas fa-user me-1"></i> Welcome, <%= studentName %>!
            </span>
            <a href="LogoutServletStudent" class="btn btn-outline-light" onclick="return confirm('Are you sure you want to logout?')">
                <i class="fas fa-sign-out-alt me-2"></i>Logout
            </a>
        </div>
    </div>
</nav>

<div class="container mt-4">
    
    <!-- Exam Alerts -->
    <%
    try {
        Connection con = DBConnection.getConnection();
        
        // Today's Exam Alert
        String sqlToday = "SELECT e.subject, e.date " +
                         "FROM exam_registration er " +
                         "JOIN exam e ON er.exam_id = e.exam_id " +
                         "WHERE er.student_id=? AND e.date = CURDATE()";
        
        PreparedStatement psToday = con.prepareStatement(sqlToday);
        psToday.setInt(1, studentId);
        ResultSet rsToday = psToday.executeQuery();
        
        while(rsToday.next()) {
    %>
        <div class="alert alert-today alert-dismissible fade show text-center mb-4" role="alert">
            <i class="fas fa-bell fa-2x mb-2 d-block"></i>
            <strong>⚠️ EXAM TODAY!</strong>
            <hr>
            <i class="fas fa-book-open me-2"></i> <strong><%= rsToday.getString("subject") %></strong>
            <br>
            <i class="far fa-calendar-alt me-2"></i> Today
            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert"></button>
        </div>
    <%
        }
        
        // Tomorrow's Exam Alert
        String sqlTomorrow = "SELECT e.subject, e.date " +
                            "FROM exam_registration er " +
                            "JOIN exam e ON er.exam_id = e.exam_id " +
                            "WHERE er.student_id=? AND e.date = CURDATE() + INTERVAL 1 DAY";
        
        PreparedStatement psTomorrow = con.prepareStatement(sqlTomorrow);
        psTomorrow.setInt(1, studentId);
        ResultSet rsTomorrow = psTomorrow.executeQuery();
        
        while(rsTomorrow.next()) {
    %>
        <div class="alert alert-tomorrow alert-dismissible fade show text-center mb-4" role="alert">
            <i class="fas fa-clock fa-2x mb-2 d-block"></i>
            <strong>⏰ EXAM TOMORROW!</strong>
            <hr>
            <i class="fas fa-book-open me-2"></i> <strong><%= rsTomorrow.getString("subject") %></strong>
            <br>
            <i class="far fa-calendar-alt me-2"></i> <%= rsTomorrow.getDate("date") %>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <%
        }
        
        rsToday.close();
        rsTomorrow.close();
        psToday.close();
        psTomorrow.close();
        con.close();
        
    } catch(Exception e) {
        // Silently handle alert errors - don't show error to user
        System.err.println("Alert Error: " + e.getMessage());
    }
    %>
    
    <!-- Welcome Section -->
    <div class="welcome-section">
        <div class="welcome-icon">
            <i class="fas fa-smile-wink"></i>
        </div>
        <h2>Welcome back, <%= studentName %>! 👋</h2>
        <p class="text-muted">What would you like to do today?</p>
    </div>
    
    <!-- Dashboard Cards -->
    <div class="row justify-content-center g-4">
        <div class="col-md-5">
            <div class="dashboard-card">
                <i class="fas fa-clipboard-list"></i>
                <h3>Available Exams</h3>
                <p>Browse and register for upcoming exams</p>
                <a href="examlist.jsp" class="btn btn-primary">
                    <i class="fas fa-eye me-2"></i>View Exams
                </a>
            </div>
        </div>
        
        <div class="col-md-5">
            <div class="dashboard-card">
                <i class="fas fa-calendar-check"></i>
                <h3>My Registered Exams</h3>
                <p>View and manage your exam registrations</p>
                <a href="myexams.jsp" class="btn btn-success">
                    <i class="fas fa-list me-2"></i>My Exams
                </a>
            </div>
        </div>
        
        <div class="col-md-5">
            <div class="dashboard-card">
                <i class="fas fa-user-circle"></i>
                <h3>My Profile</h3>
                <p>View and update your personal information</p>
                <a href="profile.jsp" class="btn btn-info">
                    <i class="fas fa-user-edit me-2"></i>View Profile
                </a>
            </div>
        </div>
        
        <div class="col-md-5">
            <div class="dashboard-card">
                <i class="fas fa-question-circle"></i>
                <h3>Need Help?</h3>
                <p>FAQs and support information</p>
                <a href="#" class="btn btn-secondary" data-bs-toggle="modal" data-bs-target="#helpModal">
                    <i class="fas fa-life-ring me-2"></i>Help & Support
                </a>
            </div>
        </div>
    </div>
    
    <!-- Quick Stats Section - Removed "Active Semester" -->
    <div class="row mt-5 g-4">
        <div class="col-md-4 col-6">
            <div class="stats-card">
                <div class="stats-number">
                    <%
                        try {
                            Connection con = DBConnection.getConnection();
                            String sqlCount = "SELECT COUNT(*) FROM exam_registration WHERE student_id=?";
                            PreparedStatement psCount = con.prepareStatement(sqlCount);
                            psCount.setInt(1, studentId);
                            ResultSet rsCount = psCount.executeQuery();
                            if(rsCount.next()) {
                                out.print(rsCount.getInt(1));
                            }
                            rsCount.close();
                            psCount.close();
                            con.close();
                        } catch(Exception e) {
                            out.print("0");
                        }
                    %>
                </div>
                <div class="stats-label">Total Registrations</div>
            </div>
        </div>
        <div class="col-md-4 col-6">
            <div class="stats-card">
                <div class="stats-number">
                    <%
                        try {
                            Connection con = DBConnection.getConnection();
                            String sqlActive = "SELECT COUNT(*) FROM exam_registration er JOIN exam e ON er.exam_id = e.exam_id WHERE er.student_id=? AND e.date >= CURDATE()";
                            PreparedStatement psActive = con.prepareStatement(sqlActive);
                            psActive.setInt(1, studentId);
                            ResultSet rsActive = psActive.executeQuery();
                            if(rsActive.next()) {
                                out.print(rsActive.getInt(1));
                            }
                            rsActive.close();
                            psActive.close();
                            con.close();
                        } catch(Exception e) {
                            out.print("0");
                        }
                    %>
                </div>
                <div class="stats-label">Upcoming Exams</div>
            </div>
        </div>
        <div class="col-md-4 col-6">
            <div class="stats-card">
                <div class="stats-number">
                    <%
                        try {
                            Connection con = DBConnection.getConnection();
                            String sqlCompleted = "SELECT COUNT(*) FROM exam_registration er JOIN exam e ON er.exam_id = e.exam_id WHERE er.student_id=? AND e.date < CURDATE()";
                            PreparedStatement psCompleted = con.prepareStatement(sqlCompleted);
                            psCompleted.setInt(1, studentId);
                            ResultSet rsCompleted = psCompleted.executeQuery();
                            if(rsCompleted.next()) {
                                out.print(rsCompleted.getInt(1));
                            }
                            rsCompleted.close();
                            psCompleted.close();
                            con.close();
                        } catch(Exception e) {
                            out.print("0");
                        }
                    %>
                </div>
                <div class="stats-label">Completed Exams</div>
            </div>
        </div>
    </div>
    
</div>

<!-- Help Modal -->
<div class="modal fade" id="helpModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header" style="background: var(--gradient); color: white;">
                <h5 class="modal-title">
                    <i class="fas fa-life-ring me-2"></i>Help & Support
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <h6><i class="fas fa-question-circle me-2 text-primary"></i>Frequently Asked Questions</h6>
                <hr>
                <p><strong>📝 How to register for an exam?</strong><br>
                Go to "Available Exams" and click "Register" on the exam you want.</p>
                <p><strong>⏰ Can I cancel my registration?</strong><br>
                Yes, you can cancel within 5 days of registration.</p>
                <p><strong>📧 Need more help?</strong><br>
                Contact support: <a href="mailto:support@examreg.com">support@examreg.com</a></p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            </div>
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
    }, 8000);
</script>

</body>
</html>