package servlets;

import util.DBConnection;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class AdminAddExamServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String subject = req.getParameter("subject");
        String date = req.getParameter("date");
        String semester = req.getParameter("semester");

        try {
            Connection con = DBConnection.getConnection();

            // STEP 1: Check if exam already exists
            PreparedStatement check = con.prepareStatement(
                    "SELECT * FROM exam WHERE subject=? AND semester=?");

            check.setString(1, subject);
            check.setString(2, semester);

            ResultSet rs = check.executeQuery();

            if (rs.next()) {
                // Exam already exists
                res.sendRedirect("admin_add_exam.jsp?error=exists");
            } else {

                // STEP 2: Insert exam
                PreparedStatement ps = con.prepareStatement(
                        "INSERT INTO exam(subject, date, semester) VALUES (?,?,?)");

                ps.setString(1, subject);
                ps.setString(2, date);
                ps.setString(3, semester);

                ps.executeUpdate();

                res.sendRedirect("admin_add_exam.jsp?success=1");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}