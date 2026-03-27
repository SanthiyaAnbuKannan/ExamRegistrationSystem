import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import util.DBConnection;

public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        // Get form values
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String college = req.getParameter("college");
        String department = req.getParameter("department");
        String semester = req.getParameter("semester");
        String year = req.getParameter("year");
        String regno = req.getParameter("regno");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");

        // ===== ADDED: Password length validation =====
        if (password == null || password.length() < 6) {
            res.sendRedirect("register.jsp?error=passwordLength&name=" + name +
                    "&email=" + email +
                    "&college=" + college +
                    "&department=" + department +
                    "&semester=" + semester +
                    "&year=" + year +
                    "&regno=" + regno +
                    "&phone=" + phone +
                    "&address=" + address);
            return;
        }

        // Phone validation
        if (phone == null || !phone.matches("\\d{10}")) {
            res.sendRedirect("register.jsp?error=phone&name=" + name +
                    "&email=" + email +
                    "&college=" + college +
                    "&department=" + department +
                    "&semester=" + semester +
                    "&year=" + year +
                    "&regno=" + regno +
                    "&phone=" + phone +
                    "&address=" + address);
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();

            // Check if email already exists
            String checkQuery = "SELECT * FROM student WHERE email=?";
            ps = con.prepareStatement(checkQuery);
            ps.setString(1, email);
            rs = ps.executeQuery();

            if (rs.next()) {
                // Email already exists
                res.sendRedirect("register.jsp?error=emailExists&name=" + name +
                        "&email=" + email +
                        "&college=" + college +
                        "&department=" + department +
                        "&semester=" + semester +
                        "&year=" + year +
                        "&regno=" + regno +
                        "&phone=" + phone +
                        "&address=" + address);
            } else {
                // Insert new student
                String sql = "INSERT INTO student "
                        + "(name, email, password, college, department, semester, year, address, phone, reg_no) "
                        + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

                ps = con.prepareStatement(sql);
                ps.setString(1, name);
                ps.setString(2, email);
                ps.setString(3, password);
                ps.setString(4, college);
                ps.setString(5, department);
                ps.setString(6, semester);
                ps.setString(7, year);
                ps.setString(8, address);
                ps.setString(9, phone);
                ps.setString(10, regno);

                ps.executeUpdate();

                // Success → go to login
                res.sendRedirect(req.getContextPath() + "/login.jsp?success=1");
            }

        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect("register.jsp?error=database&name=" + name +
                    "&email=" + email +
                    "&college=" + college +
                    "&department=" + department +
                    "&semester=" + semester +
                    "&year=" + year +
                    "&regno=" + regno +
                    "&phone=" + phone +
                    "&address=" + address);
        } finally {
            try {
                if (rs != null)
                    rs.close();
            } catch (Exception e) {
            }
            try {
                if (ps != null)
                    ps.close();
            } catch (Exception e) {
            }
            try {
                if (con != null)
                    con.close();
            } catch (Exception e) {
            }
        }
    }
}