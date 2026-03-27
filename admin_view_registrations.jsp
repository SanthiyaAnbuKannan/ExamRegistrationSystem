<%
String admin = (String) session.getAttribute("admin");
if(admin == null){
    response.sendRedirect("admin_login.jsp");
    return;
}
%>

<%@ page import="util.DBConnection" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>View Registrations - ExamReg Pro</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .filter-card {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 25px;
            border: none;
        }
        .exam-card {
            transition: all 0.3s ease;
        }
        .exam-card:hover {
            transform: translateY(-2px);
        }
        .student-table tr:hover {
            background: rgba(67, 97, 238, 0.05);
        }
        .badge-semester {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.8rem;
        }
        .header-icon {
            width: 60px;
            height: 60px;
            background: var(--gradient);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 15px;
        }
        .header-icon i {
            font-size: 1.8rem;
            color: white;
        }
        @media (max-width: 768px) {
            .btn-sm {
                margin-bottom: 5px;
                display: inline-block;
            }
            .table {
                font-size: 0.85rem;
            }
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark">
    <div class="container-fluid">
        <span class="navbar-brand">
            <i class="fas fa-clipboard-list me-2"></i>Exam Registrations
        </span>
        <div class="d-flex">
            <a href="admin.jsp" class="btn btn-outline-light">
                <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
            </a>
        </div>
    </div>
</nav>

<div class="container mt-4">
    
    <!-- Page Header -->
    <div class="text-center mb-4">
        <div class="header-icon">
            <i class="fas fa-users"></i>
        </div>
        <h3>Manage Exam Registrations</h3>
        <p class="text-muted">View and manage student exam registrations</p>
    </div>
    
    <!-- Filter Card -->
    <div class="card filter-card">
        <div class="card-body">
            <form method="get" class="row justify-content-center align-items-end g-3">
                <div class="col-md-4">
                    <label class="form-label fw-bold">
                        <i class="fas fa-filter me-1"></i>Filter by Semester
                    </label>
                    <select name="semester" class="form-select">
                        <option value="">All Semesters</option>
                        <option value="1" <%= "1".equals(request.getParameter("semester")) ? "selected" : "" %>>Semester 1</option>
                        <option value="2" <%= "2".equals(request.getParameter("semester")) ? "selected" : "" %>>Semester 2</option>
                        <option value="3" <%= "3".equals(request.getParameter("semester")) ? "selected" : "" %>>Semester 3</option>
                        <option value="4" <%= "4".equals(request.getParameter("semester")) ? "selected" : "" %>>Semester 4</option>
                        <option value="5" <%= "5".equals(request.getParameter("semester")) ? "selected" : "" %>>Semester 5</option>
                        <option value="6" <%= "6".equals(request.getParameter("semester")) ? "selected" : "" %>>Semester 6</option>
                        <option value="7" <%= "7".equals(request.getParameter("semester")) ? "selected" : "" %>>Semester 7</option>
                        <option value="8" <%= "8".equals(request.getParameter("semester")) ? "selected" : "" %>>Semester 8</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <button type="submit" class="btn btn-primary w-100">
                        <i class="fas fa-search me-2"></i>Apply Filter
                    </button>
                </div>
                <div class="col-md-2">
                    <a href="admin_view_registrations.jsp" class="btn btn-secondary w-100">
                        <i class="fas fa-sync-alt me-2"></i>Reset
                    </a>
                </div>
            </form>
        </div>
    </div>
    
    <!-- Exams List Section -->
    <div class="card">
        <div class="card-header" style="background: var(--gradient); color: white;">
            <i class="fas fa-book me-2"></i>Available Exams
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead class="table-light">
                        <tr>
                            <th><i class="fas fa-book-open me-2"></i>Subject</th>
                            <th><i class="fas fa-calendar-day me-2"></i>Date</th>
                            <th><i class="fas fa-layer-group me-2"></i>Semester</th>
                            <th><i class="fas fa-cog me-2"></i>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        try {
                            Connection con = DBConnection.getConnection();
                            String semester = request.getParameter("semester");
                            String sql;
                            PreparedStatement ps;
                            
                            if(semester != null && !semester.trim().isEmpty()){
                                sql = "SELECT exam_id, subject, date, semester FROM exam WHERE semester=? ORDER BY date ASC";
                                ps = con.prepareStatement(sql);
                                ps.setString(1, semester);
                            } else {
                                sql = "SELECT exam_id, subject, date, semester FROM exam ORDER BY semester ASC, date ASC";
                                ps = con.prepareStatement(sql);
                            }
                            
                            ResultSet rs = ps.executeQuery();
                            boolean hasExams = false;
                            
                            while(rs.next()){
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
                                <span class="badge-semester">
                                    <i class="fas fa-layer-group me-1"></i>Semester <%= rs.getString("semester") %>
                                </span>
                            </td>
                            <td>
                                <a href="admin_view_registrations.jsp?exam_id=<%= rs.getInt("exam_id") %><%= semester != null ? "&semester=" + semester : "" %>"
                                   class="btn btn-success btn-sm me-1">
                                    <i class="fas fa-users me-1"></i>View Students
                                </a>
                                <a href="ExportStudentsCSVServlet?exam_id=<%= rs.getInt("exam_id") %>"
                                   class="btn btn-primary btn-sm"
                                   onclick="return confirm('Download CSV file for this exam?')">
                                    <i class="fas fa-download me-1"></i>CSV
                                </a>
                            </td>
                        </tr>
                        <%
                            }
                            
                            if(!hasExams) {
                        %>
                        <tr>
                            <td colspan="4" class="text-center text-muted py-4">
                                <i class="fas fa-calendar-times fa-2x mb-2 d-block"></i>
                                No exams found
                                <%= (semester != null && !semester.trim().isEmpty()) ? "for Semester " + semester : "" %>
                            </td>
                        </tr>
                        <%
                            }
                            rs.close();
                            ps.close();
                            con.close();
                        } catch(Exception e) {
                        %>
                        <tr>
                            <td colspan="4" class="text-center text-danger py-4">
                                <i class="fas fa-exclamation-circle me-2"></i>
                                Error loading exams: <%= e.getMessage() %>
                            </td>
                        </tr>
                        <%
                        }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    
    <!-- Registered Students Section -->
    <%
    String examId = request.getParameter("exam_id");
    if(examId != null && !examId.trim().isEmpty()){
    %>
    <div class="card mt-5">
        <div class="card-header" style="background: var(--gradient-success); color: white;">
            <i class="fas fa-users me-2"></i>Registered Students
        </div>
        <div class="card-body p-0">
            <%
            try {
                Connection con = DBConnection.getConnection();
                
                // Get exam name
                String examNameQuery = "SELECT subject FROM exam WHERE exam_id=?";
                PreparedStatement psExam = con.prepareStatement(examNameQuery);
                psExam.setInt(1, Integer.parseInt(examId));
                ResultSet examRs = psExam.executeQuery();
                String subjectName = "";
                if(examRs.next()){
                    subjectName = examRs.getString("subject");
                }
                examRs.close();
                psExam.close();
                
                // Get registered students
                String sqlStudents = "SELECT s.name, s.reg_no, s.department, s.email, s.phone " +
                                    "FROM exam_registration r " +
                                    "JOIN student s ON r.student_id = s.id " +
                                    "WHERE r.exam_id=? " +
                                    "ORDER BY s.name ASC";
                
                PreparedStatement psStudents = con.prepareStatement(sqlStudents);
                psStudents.setInt(1, Integer.parseInt(examId));
                ResultSet rsStudents = psStudents.executeQuery();
                
                boolean hasStudents = false;
            %>
            
            <div class="table-responsive">
                <table class="table table-hover student-table mb-0">
                    <thead class="table-light">
                        <tr>
                            <th><i class="fas fa-user-graduate me-2"></i>Student Name</th>
                            <th><i class="fas fa-id-card me-2"></i>Register No</th>
                            <th><i class="fas fa-book me-2"></i>Department</th>
                            <th><i class="fas fa-envelope me-2"></i>Email</th>
                            <th><i class="fas fa-phone me-2"></i>Phone</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                        while(rsStudents.next()){
                            hasStudents = true;
                        %>
                        <tr>
                            <td>
                                <i class="fas fa-user-graduate me-2" style="color: var(--primary);"></i>
                                <strong><%= rsStudents.getString("name") %></strong>
                            </td>
                            <td><%= rsStudents.getString("reg_no") %></td>
                            <td><span class="badge bg-secondary"><%= rsStudents.getString("department") %></span></td>
                            <td><small><%= rsStudents.getString("email") %></small></td>
                            <td><%= rsStudents.getString("phone") %></td>
                        </tr>
                        <%
                        }
                        
                        if(!hasStudents){
                        %>
                        <tr>
                            <td colspan="5" class="text-center text-muted py-4">
                                <i class="fas fa-user-slash fa-2x mb-2 d-block"></i>
                                No students have registered for <strong><%= subjectName %></strong> yet.
                            </td>
                        </tr>
                        <%
                        }
                        rsStudents.close();
                        psStudents.close();
                        con.close();
                        %>
                    </tbody>
                </table>
            </div>
            
            <div class="text-center p-3 bg-light">
                <small class="text-muted">
                    <i class="fas fa-chart-line me-1"></i>
                    Total Registered: <%= hasStudents ? "Students listed above" : "0 students" %>
                </small>
                <a href="ExportStudentsCSVServlet?exam_id=<%= examId %>" 
                   class="btn btn-sm btn-primary ms-3"
                   onclick="return confirm('Download CSV file for this exam?')">
                    <i class="fas fa-file-csv me-1"></i>Export to CSV
                </a>
            </div>
            
            <%
            } catch(Exception e){
            %>
            <div class="alert alert-danger m-3">
                <i class="fas fa-exclamation-circle me-2"></i>
                Error loading student data: <%= e.getMessage() %>
            </div>
            <%
            }
            %>
        </div>
    </div>
    <%
    }
    %>
    
    <!-- Back Button -->
    <div class="text-center mt-4 mb-5">
        <a href="admin.jsp" class="btn btn-secondary btn-lg px-4">
            <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
        </a>
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