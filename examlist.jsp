<%@ page import="util.DBConnection" %>
<%@ page import="java.sql.*" %>

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
    <title>Available Exams - ExamReg Pro</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .exam-header-icon {
            width: 80px;
            height: 80px;
            background: var(--gradient);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 15px;
        }
        .exam-header-icon i {
            font-size: 2.5rem;
            color: white;
        }
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            background: #f8f9fa;
            border-radius: 15px;
            margin: 20px 0;
        }
        .empty-state i {
            font-size: 4rem;
            color: var(--secondary);
            margin-bottom: 20px;
        }
        .empty-state p {
            color: #777;
            font-size: 1.1rem;
        }
        .badge-upcoming {
            background: var(--gradient-success);
            color: white;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.75rem;
        }
        .exam-card {
            transition: all 0.3s ease;
        }
        .exam-card:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-sm);
        }
        @media (max-width: 768px) {
            .table {
                font-size: 0.9rem;
            }
            .btn-sm {
                padding: 5px 10px;
                font-size: 0.75rem;
            }
            .empty-state {
                padding: 40px 15px;
            }
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark">
    <div class="container-fluid">
        <span class="navbar-brand">
            <i class="fas fa-clipboard-list me-2"></i>Available Exams
        </span>
        <div class="d-flex">
            <a href="dashboard.jsp" class="btn btn-outline-light">
                <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
            </a>
        </div>
    </div>
</nav>

<div class="container mt-4">
    <div class="card p-4">
        
        <!-- Page Header -->
        <div class="text-center mb-4">
            <div class="exam-header-icon">
                <i class="fas fa-calendar-alt"></i>
            </div>
            <h3>Exams Available for Registration</h3>
            <p class="text-muted">Select an exam to register. You can only register for exams matching your semester.</p>
        </div>
        
        <%
        try {
            Connection con = DBConnection.getConnection();
            
            String semester = (String) session.getAttribute("student_semester");
            
            String sql = "SELECT e.exam_id, e.subject, e.date, er.student_id " +
                         "FROM exam e " +
                         "LEFT JOIN exam_registration er " +
                         "ON e.exam_id = er.exam_id AND er.student_id = ? " +
                         "WHERE e.semester=? AND e.date >= CURDATE() " +
                         "ORDER BY e.date ASC";
            
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, studentId);
            ps.setString(2, semester);
            
            ResultSet rs = ps.executeQuery();
            
            boolean hasExams = false;
        %>
        
        <div class="table-responsive">
            <table class="table table-hover">
                <thead class="table-light">
                    <tr>
                        <th><i class="fas fa-book-open me-2"></i>Subject</th>
                        <th><i class="fas fa-calendar-day me-2"></i>Exam Date</th>
                        <th><i class="fas fa-cog me-2"></i>Action</th>
                    </tr>
                </thead>
                <tbody>
        <%
            while(rs.next()) {
                hasExams = true;
        %>
                    <tr class="exam-card">
                        <td>
                            <i class="fas fa-book-open me-2" style="color: var(--primary);"></i>
                            <strong><%= rs.getString("subject") %></strong>
                        </td>
                        <td>
                            <span class="badge bg-primary">
                                <i class="far fa-calendar-alt me-1"></i> <%= rs.getDate("date") %>
                            </span>
                        </td>
                        <td>
                            <% if(rs.getObject("student_id") != null) { %>
                                <button class="btn btn-secondary btn-sm" disabled>
                                    <i class="fas fa-check-circle me-1"></i>Already Registered
                                </button>
                            <% } else { %>
                                <a href="RegisterExamServlet?exam_id=<%= rs.getInt("exam_id") %>" 
                                   class="btn btn-success btn-sm"
                                   onclick="return confirm('Are you sure you want to register for this exam?')">
                                    <i class="fas fa-check-circle me-1"></i>Register Now
                                </a>
                            <% } %>
                        </td>
                    </tr>
        <%
            }
            
            if(!hasExams) {
        %>
                    <tr>
                        <td colspan="3">
                            <div class="empty-state">
                                <i class="fas fa-calendar-times"></i>
                                <h5>No Exams Available</h5>
                                <p>There are no exams available for your semester at the moment.</p>
                                <a href="dashboard.jsp" class="btn btn-primary mt-2">
                                    <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
                                </a>
                            </div>
                        </td>
                    </tr>
        <%
            }
            
            rs.close();
            ps.close();
            con.close();
            
        } catch(Exception e) {
            e.printStackTrace();
        %>
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i>
                <strong>Error Loading Exams!</strong> Please try again later.
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        <%
        }
        %>
                </tbody>
            </table>
        </div>
        
        <!-- Quick Info -->
        <div class="alert alert-info alert-dismissible fade show mt-3" role="alert">
            <i class="fas fa-info-circle me-2"></i>
            <strong>Note:</strong> You can only cancel registrations within 5 days of registration. Cancellation is not allowed after that period.
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        
        <div class="text-center mt-3">
            <a href="myexams.jsp" class="btn btn-info me-2">
                <i class="fas fa-eye me-2"></i>View My Registered Exams
            </a>
            <a href="dashboard.jsp" class="btn btn-secondary">
                <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
            </a>
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