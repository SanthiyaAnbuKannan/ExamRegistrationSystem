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
    <title>Admin Panel - ExamReg Pro</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .admin-welcome-icon {
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
        .admin-welcome-icon i {
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
        @media (max-width: 768px) {
            .dashboard-card {
                margin-bottom: 20px;
            }
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark">
    <div class="container-fluid">
        <span class="navbar-brand">
            <i class="fas fa-user-shield me-2"></i>Admin Panel
        </span>
        <div class="d-flex">
            <span class="navbar-text me-3">
                <i class="fas fa-crown me-1"></i> Welcome, Administrator
            </span>
            <a href="index.jsp" class="btn btn-outline-light me-2">
                <i class="fas fa-home me-2"></i>Home
            </a>
        </div>
    </div>
</nav>

<div class="container mt-4">
    
    <!-- Welcome Section -->
    <div class="text-center mb-4">
        <div class="admin-welcome-icon">
            <i class="fas fa-user-shield"></i>
        </div>
        <h2>Admin Dashboard</h2>
        <p class="text-muted">Manage your exam system efficiently</p>
    </div>
    
    <!-- Dashboard Cards -->
    <div class="row justify-content-center g-4">
        <div class="col-md-4">
            <div class="dashboard-card">
                <i class="fas fa-plus-circle"></i>
                <h3>Add Exam</h3>
                <p>Create new exam entries for students</p>
                <a href="admin_add_exam.jsp" class="btn btn-primary">
                    <i class="fas fa-plus me-2"></i>Add Exam
                </a>
            </div>
        </div>
        
        <div class="col-md-4">
            <div class="dashboard-card">
                <i class="fas fa-users"></i>
                <h3>View Registrations</h3>
                <p>Check and manage student registrations</p>
                <a href="admin_view_registrations.jsp" class="btn btn-success">
                    <i class="fas fa-eye me-2"></i>View All
                </a>
            </div>
        </div>
        
        <div class="col-md-4">
            <div class="dashboard-card">
                <i class="fas fa-chart-line"></i>
                <h3>Statistics</h3>
                <p>View system statistics and reports</p>
                <a href="#" class="btn btn-info" data-bs-toggle="modal" data-bs-target="#statsModal">
                    <i class="fas fa-chart-bar me-2"></i>View Stats
                </a>
            </div>
        </div>
    </div>
    
    <!-- Quick Stats Section -->
    <div class="row mt-5 g-4">
        <div class="col-md-3 col-6">
            <div class="stats-card">
                <div class="stats-number">
                    <%@ page import="util.DBConnection" %>
                    <%@ page import="java.sql.*" %>
                    <%
                        try {
                            Connection con = DBConnection.getConnection();
                            String sqlCount = "SELECT COUNT(*) FROM student";
                            Statement st = con.createStatement();
                            ResultSet rs = st.executeQuery(sqlCount);
                            if(rs.next()) {
                                out.print(rs.getInt(1));
                            }
                            rs.close();
                            st.close();
                            con.close();
                        } catch(Exception e) {
                            out.print("0");
                        }
                    %>
                </div>
                <div class="stats-label">Total Students</div>
            </div>
        </div>
        <div class="col-md-3 col-6">
            <div class="stats-card">
                <div class="stats-number">
                    <%
                        try {
                            Connection con = DBConnection.getConnection();
                            String sqlCount = "SELECT COUNT(*) FROM exam";
                            Statement st = con.createStatement();
                            ResultSet rs = st.executeQuery(sqlCount);
                            if(rs.next()) {
                                out.print(rs.getInt(1));
                            }
                            rs.close();
                            st.close();
                            con.close();
                        } catch(Exception e) {
                            out.print("0");
                        }
                    %>
                </div>
                <div class="stats-label">Total Exams</div>
            </div>
        </div>
        <div class="col-md-3 col-6">
            <div class="stats-card">
                <div class="stats-number">
                    <%
                        try {
                            Connection con = DBConnection.getConnection();
                            String sqlCount = "SELECT COUNT(*) FROM exam_registration";
                            Statement st = con.createStatement();
                            ResultSet rs = st.executeQuery(sqlCount);
                            if(rs.next()) {
                                out.print(rs.getInt(1));
                            }
                            rs.close();
                            st.close();
                            con.close();
                        } catch(Exception e) {
                            out.print("0");
                        }
                    %>
                </div>
                <div class="stats-label">Total Registrations</div>
            </div>
        </div>
        <div class="col-md-3 col-6">
            <div class="stats-card">
                <div class="stats-number">
                    <i class="fas fa-calendar-alt" style="font-size: 1.8rem; color: var(--primary);"></i>
                </div>
                <div class="stats-label">Current Year</div>
            </div>
        </div>
    </div>
    
    <!-- Recent Activity Section (Optional) -->
    <div class="card mt-5 p-4">
        <h4 class="mb-3">
            <i class="fas fa-history me-2" style="color: var(--primary);"></i>Recent Registrations
        </h4>
        <div class="table-responsive">
            <table class="table table-hover">
                <thead class="table-light">
                    <tr>
                        <th><i class="fas fa-user me-1"></i> Student</th>
                        <th><i class="fas fa-book me-1"></i> Exam</th>
                        <th><i class="fas fa-calendar me-1"></i> Registered On</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try {
                            Connection con = DBConnection.getConnection();
                            String sqlRecent = "SELECT s.name, e.subject, er.reg_date " +
                                              "FROM exam_registration er " +
                                              "JOIN student s ON er.student_id = s.id " +
                                              "JOIN exam e ON er.exam_id = e.exam_id " +
                                              "ORDER BY er.reg_date DESC LIMIT 5";
                            Statement st = con.createStatement();
                            ResultSet rs = st.executeQuery(sqlRecent);
                            
                            boolean hasRecent = false;
                            while(rs.next()) {
                                hasRecent = true;
                    %>
                                <tr>
                                    <td><i class="fas fa-user-graduate me-2 text-primary"></i><%= rs.getString("name") %></td>
                                    <td><span class="badge bg-primary"><%= rs.getString("subject") %></span></td>
                                    <td><i class="far fa-clock me-1"></i> <%= rs.getTimestamp("reg_date") %></td>
                                </tr>
                    <%
                            }
                            if(!hasRecent) {
                    %>
                                <tr>
                                    <td colspan="3" class="text-center text-muted">No recent registrations</td>
                                </tr>
                    <%
                            }
                            rs.close();
                            st.close();
                            con.close();
                        } catch(Exception e) {
                    %>
                                <tr>
                                    <td colspan="3" class="text-center text-danger">Error loading recent activity</td>
                                </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>
    
    <!-- Logout Button -->
    <div class="text-center mt-4 mb-5">
        <a href="LogoutServlet" class="btn btn-danger btn-lg px-5" onclick="return confirm('Are you sure you want to logout?')">
            <i class="fas fa-sign-out-alt me-2"></i>Logout
        </a>
    </div>
    
</div>

<!-- Statistics Modal -->
<div class="modal fade" id="statsModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header" style="background: var(--gradient); color: white;">
                <h5 class="modal-title">
                    <i class="fas fa-chart-line me-2"></i>System Statistics
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <h6><i class="fas fa-users me-2 text-primary"></i>Student Statistics</h6>
                <hr>
                <p><strong>Total Students:</strong> 
                    <%
                        try {
                            Connection con = DBConnection.getConnection();
                            String sql = "SELECT COUNT(*) FROM student";
                            Statement st = con.createStatement();
                            ResultSet rs = st.executeQuery(sql);
                            if(rs.next()) out.print(rs.getInt(1));
                            rs.close();
                            st.close();
                            con.close();
                        } catch(Exception e) { out.print("0"); }
                    %>
                </p>
                <p><strong>Total Exams:</strong> 
                    <%
                        try {
                            Connection con = DBConnection.getConnection();
                            String sql = "SELECT COUNT(*) FROM exam";
                            Statement st = con.createStatement();
                            ResultSet rs = st.executeQuery(sql);
                            if(rs.next()) out.print(rs.getInt(1));
                            rs.close();
                            st.close();
                            con.close();
                        } catch(Exception e) { out.print("0"); }
                    %>
                </p>
                <p><strong>Total Registrations:</strong> 
                    <%
                        try {
                            Connection con = DBConnection.getConnection();
                            String sql = "SELECT COUNT(*) FROM exam_registration";
                            Statement st = con.createStatement();
                            ResultSet rs = st.executeQuery(sql);
                            if(rs.next()) out.print(rs.getInt(1));
                            rs.close();
                            st.close();
                            con.close();
                        } catch(Exception e) { out.print("0"); }
                    %>
                </p>
                <hr>
                <h6><i class="fas fa-chart-pie me-2 text-success"></i>Quick Actions</h6>
                <p>• Add new exams for upcoming semesters<br>
                • Monitor student registrations<br>
                • Generate reports for administration</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>