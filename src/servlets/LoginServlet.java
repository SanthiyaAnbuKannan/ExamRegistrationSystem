package servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import util.DBConnection;

public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String pass = req.getParameter("password");

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {

            con = DBConnection.getConnection();

            System.out.println("Email: " + email);
            System.out.println("Pass: " + pass);

            String sql = "SELECT * FROM student WHERE email=? AND password=?";
            ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, pass);

            rs = ps.executeQuery();

            if (rs.next()) {

                System.out.println("Login Success");

                // CREATE SESSION ONLY ONCE
                HttpSession session = req.getSession();

                session.setAttribute("student_id", rs.getInt("id"));
                session.setAttribute("student_name", rs.getString("name"));
                session.setAttribute("student_email", rs.getString("email"));
                session.setAttribute("student_college", rs.getString("college"));
                session.setAttribute("student_department", rs.getString("department"));
                session.setAttribute("student_semester", rs.getString("semester"));
                session.setAttribute("student_year", rs.getString("year"));
                session.setAttribute("student_regno", rs.getString("reg_no"));
                session.setAttribute("student_phone", rs.getString("phone"));
                session.setAttribute("student_address", rs.getString("address"));

                System.out.println("Session ID: " + session.getId());

                // REDIRECT TO DASHBOARD ON SUCCESS
                res.sendRedirect(req.getContextPath() + "/dashboard.jsp");

            } else {
                // ===== CHANGED THIS PART =====
                // Instead of printing error text, redirect back to login page with error
                // parameter
                // This will show the error message on the same login page
                res.sendRedirect("login.jsp?error=invalid&email=" + email);
                // =============================
            }

        } catch (Exception e) {
            e.printStackTrace();
            // Redirect with database error if needed
            res.sendRedirect("login.jsp?error=database");
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