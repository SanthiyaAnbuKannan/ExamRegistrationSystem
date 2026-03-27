package servlets;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import util.DBConnection;

public class UpdateProfileServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        Integer studentId = (Integer) session.getAttribute("student_id");

        if (studentId == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String college = req.getParameter("college");
        String department = req.getParameter("department");
        String semester = req.getParameter("semester");
        String year = req.getParameter("year");
        String regno = req.getParameter("regno");
        String phone = req.getParameter("phone");
        String address = req.getParameter("address");

        // Validate phone number
        if (phone == null || !phone.matches("\\d{10}")) {
            res.sendRedirect("edit_profile.jsp?error=phone");
            return;
        }

        try {
            Connection con = DBConnection.getConnection();
            String sql = "UPDATE student SET name=?, email=?, college=?, department=?, semester=?, year=?, reg_no=?, phone=?, address=? WHERE id=?";
            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, college);
            ps.setString(4, department);
            ps.setString(5, semester);
            ps.setString(6, year);
            ps.setString(7, regno);
            ps.setString(8, phone);
            ps.setString(9, address);
            ps.setInt(10, studentId);

            ps.executeUpdate();

            // UPDATE SESSION VALUES ALSO
            session.setAttribute("student_name", name);
            session.setAttribute("student_email", email);
            session.setAttribute("student_college", college);
            session.setAttribute("student_department", department);
            session.setAttribute("student_semester", semester);
            session.setAttribute("student_year", year);
            session.setAttribute("student_regno", regno);
            session.setAttribute("student_phone", phone);
            session.setAttribute("student_address", address);

            res.sendRedirect("profile.jsp");

            ps.close();
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}