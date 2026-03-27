<%@ page import="java.sql.*" %>
<%@ page import="util.DBConnection" %>

<%
Integer studentId = (Integer) session.getAttribute("student_id");

if(studentId == null){
    response.sendRedirect("login.jsp");
    return;
}

Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;
%>

<!DOCTYPE html>
<html>
<head>
    <title>My Registered Exams - ExamReg Pro</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <style>
        .section-header {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 20px;
            margin-top: 30px;
        }
        .section-header i {
            font-size: 1.8rem;
        }
        .upcoming-icon {
            color: var(--success);
        }
        .completed-icon {
            color: var(--secondary);
        }
        .badge-upcoming {
            background: var(--gradient-success);
            color: white;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
        }
        .badge-completed {
            background: #6c757d;
            color: white;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
        }
        .btn-expired {
            background: #6c757d;
            color: white;
            cursor: not-allowed;
            opacity: 0.6;
        }
        .btn-expired:hover {
            transform: none;
            box-shadow: none;
        }
        .empty-state {
            text-align: center;
            padding: 40px;
            background: #f8f9fa;
            border-radius: 15px;
            margin: 20px 0;
        }
        .empty-state i {
            font-size: 3rem;
            color: var(--secondary);
            margin-bottom: 15px;
        }
        .empty-state p {
            color: #777;
            margin-bottom: 0;
        }
        @media (max-width: 768px) {
            .section-header {
                flex-direction: column;
                text-align: center;
            }
            .table {
                font-size: 0.9rem;
            }
            .btn-sm {
                padding: 5px 10px;
                font-size: 0.75rem;
            }
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark">
    <div class="container-fluid">
        <span class="navbar-brand">
            <i class="fas fa-clipboard-list me-2"></i>My Registered Exams
        </span>
        <div class="d-flex">
            <a href="dashboard.jsp" class="btn btn-outline-light">
                <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
            </a>
        </div>
    </div>
</nav>

<div class="container mt-4">
    
    <!-- Success Message for Cancellation -->
    <% if(request.getParameter("cancel") != null) { %>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="fas fa-check-circle me-2"></i>
            <strong>Registration Cancelled!</strong> Your exam registration has been successfully cancelled.
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    <% } %>
    
    <div class="card p-4">
        
        <!-- Page Header -->
        <div class="text-center mb-4">
            <div style="width: 80px; height: 80px; background: var(--gradient); border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 15px;">
                <i class="fas fa-clipboard-list fa-2x" style="color: white;"></i>
            </div>
            <h3>My Registered Exams</h3>
            <p class="text-muted">View and manage your exam registrations</p>
        </div>
        
        <%
        try {
            con = DBConnection.getConnection();
            
            // ========== UPCOMING EXAMS ==========
        %>
        
        <div class="section-header">
            <i class="fas fa-calendar-alt upcoming-icon fa-2x"></i>
            <h4 class="mb-0 text-success">Upcoming Exams</h4>
            <span class="badge-upcoming ms-auto">Active Registrations</span>
        </div>
        
        <table class="table table-hover">
            <thead>
                <tr>
                    <th><i class="fas fa-book-open me-2"></i>Subject</th>
                    <th><i class="fas fa-calendar-day me-2"></i>Exam Date</th>
                    <th><i class="fas fa-clock me-2"></i>Registered On</th>
                    <th><i class="fas fa-cog me-2"></i>Action</th>
                </tr>
            </thead>
            <tbody>
        <%
            String sqlUpcoming = "SELECT e.subject, e.date, er.reg_date, er.reg_id " +
                                 "FROM exam_registration er " +
                                 "JOIN exam e ON er.exam_id = e.exam_id " +
                                 "WHERE er.student_id=? AND e.date >= CURDATE() " +
                                 "ORDER BY e.date ASC";
            
            ps = con.prepareStatement(sqlUpcoming);
            ps.setInt(1, studentId);
            rs = ps.executeQuery();
            
            boolean hasUpcoming = false;
            
            while(rs.next()) {
                hasUpcoming = true;
                Timestamp regDate = rs.getTimestamp("reg_date");
                long diff = System.currentTimeMillis() - regDate.getTime();
                long days = diff / (1000 * 60 * 60 * 24);
        %>
                <tr>
                    <td><strong><%= rs.getString("subject") %></strong></td>
                    <td><span class="badge bg-primary"><i class="far fa-calendar-alt me-1"></i> <%= rs.getDate("date") %></span></td>
                    <td><small><i class="far fa-clock me-1"></i> <%= rs.getTimestamp("reg_date") %></small></td>
                    <td>
                        <% if(days <= 5) { %>
                            <a href="CancelExamServlet?reg_id=<%= rs.getInt("reg_id") %>" 
                               class="btn btn-danger btn-sm"
                               onclick="return confirm('Are you sure you want to cancel this registration?')">
                                <i class="fas fa-times-circle me-1"></i>Cancel
                            </a>
                        <% } else { %>
                            <button class="btn btn-secondary btn-sm" disabled>
                                <i class="fas fa-hourglass-end me-1"></i>Cancellation Expired
                            </button>
                            <small class="text-muted d-block mt-1">(Cancellation period: 5 days)</small>
                        <% } %>
                    </td>
                </tr>
        <%
            }
            
            if(!hasUpcoming) {
        %>
                <tr>
                    <td colspan="4">
                        <div class="empty-state">
                            <i class="fas fa-calendar-check"></i>
                            <p>No upcoming exams registered yet.</p>
                            <a href="examlist.jsp" class="btn btn-primary btn-sm mt-2">
                                <i class="fas fa-plus me-1"></i>Register for Exams
                            </a>
                        </div>
                    </td>
                </tr>
        <%
            }
        %>
            </tbody>
        </table>
        
        <hr class="my-4">
        
        <%
            // ========== COMPLETED EXAMS ==========
        %>
        
        <div class="section-header">
            <i class="fas fa-check-circle completed-icon fa-2x"></i>
            <h4 class="mb-0 text-secondary">Completed Exams</h4>
            <span class="badge-completed ms-auto">Past Registrations</span>
        </div>
        
        <table class="table table-hover">
            <thead>
                <tr>
                    <th><i class="fas fa-book-open me-2"></i>Subject</th>
                    <th><i class="fas fa-calendar-day me-2"></i>Exam Date</th>
                    <th><i class="fas fa-clock me-2"></i>Registered On</th>
                    <th><i class="fas fa-info-circle me-2"></i>Status</th>
                </tr>
            </thead>
            <tbody>
        <%
            String sqlCompleted = "SELECT e.subject, e.date, er.reg_date " +
                                  "FROM exam_registration er " +
                                  "JOIN exam e ON er.exam_id = e.exam_id " +
                                  "WHERE er.student_id=? AND e.date < CURDATE() " +
                                  "ORDER BY e.date DESC";
            
            ps = con.prepareStatement(sqlCompleted);
            ps.setInt(1, studentId);
            rs = ps.executeQuery();
            
            boolean hasCompleted = false;
            
            while(rs.next()) {
                hasCompleted = true;
        %>
                <tr>
                    <td><%= rs.getString("subject") %></td>
                    <td><span class="badge bg-secondary"><i class="far fa-calendar-alt me-1"></i> <%= rs.getDate("date") %></span></td>
                    <td><small><i class="far fa-clock me-1"></i> <%= rs.getTimestamp("reg_date") %></small></td>
                    <td><span class="badge bg-success"><i class="fas fa-check me-1"></i>Completed</span></td>
                </tr>
        <%
            }
            
            if(!hasCompleted) {
        %>
                <tr>
                    <td colspan="4">
                        <div class="empty-state">
                            <i class="fas fa-history"></i>
                            <p>No completed exams yet.</p>
                            <small class="text-muted">Exams will appear here after the exam date passes.</small>
                        </div>
                    </td>
                </tr>
        <%
            }
            
        } catch(Exception e) {
        %>
            <div class="alert alert-danger" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i>
                <strong>Error Loading Exams!</strong> <%= e.getMessage() %>
            </div>
        <%
        } finally {
            try { if(rs != null) rs.close(); } catch(Exception e) {}
            try { if(ps != null) ps.close(); } catch(Exception e) {}
            try { if(con != null) con.close(); } catch(Exception e) {}
        }
        %>
            </tbody>
        </table>
        
        <!-- Quick Actions -->
        <div class="text-center mt-4">
            <a href="examlist.jsp" class="btn btn-success">
                <i class="fas fa-plus-circle me-2"></i>Register for New Exam
            </a>
            <a href="dashboard.jsp" class="btn btn-secondary ms-2">
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