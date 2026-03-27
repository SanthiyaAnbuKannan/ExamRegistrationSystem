package servlets;

import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import util.DBConnection;
import util.EmailUtility;

public class RegisterExamServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        try {

            int examId = Integer.parseInt(req.getParameter("exam_id"));

            // GET STUDENT ID FROM SESSION
            HttpSession session = req.getSession(false);
            int studentId = (Integer) session.getAttribute("student_id");

            Connection con = DBConnection.getConnection();

            // Check if already registered
            String checkQuery = "SELECT * FROM exam_registration WHERE student_id=? AND exam_id=?";
            PreparedStatement checkPs = con.prepareStatement(checkQuery);
            checkPs.setInt(1, studentId);
            checkPs.setInt(2, examId);

            ResultSet rs = checkPs.executeQuery();

            if (rs.next()) {

                res.getWriter().println("You have already registered for this exam!");

            } else {

                String sql = "INSERT INTO exam_registration(student_id, exam_id) VALUES(?, ?)";
                PreparedStatement ps = con.prepareStatement(sql);

                ps.setInt(1, studentId);
                ps.setInt(2, examId);

                ps.executeUpdate();

                // GET STUDENT EMAIL
                String emailQuery = "SELECT email, name FROM student WHERE id=?";
                PreparedStatement emailPs = con.prepareStatement(emailQuery);
                emailPs.setInt(1, studentId);
                ResultSet emailRs = emailPs.executeQuery();

                String studentEmail = "";
                String studentName = "";

                if (emailRs.next()) {
                    studentEmail = emailRs.getString("email");
                    studentName = emailRs.getString("name");
                }

                // GET SUBJECT NAME
                String examQuery = "SELECT subject, date FROM exam WHERE exam_id=?";
                PreparedStatement examPs = con.prepareStatement(examQuery);
                examPs.setInt(1, examId);
                ResultSet examRs = examPs.executeQuery();

                String subject = "";
                String date = "";

                if (examRs.next()) {
                    subject = examRs.getString("subject");
                    date = examRs.getString("date");
                }

                // EMAIL CONTENT
                String emailSubject = "Exam Registration Successful";

                String emailMessage = "Hello " + studentName + ",\n\n" +
                        "You have successfully registered for the exam.\n\n" +
                        "Subject: " + subject + "\n" +
                        "Date: " + date + "\n\n" +
                        "All the best!\n" +
                        "Exam Registration System";

                // SEND EMAIL
                EmailUtility.sendEmail(studentEmail, emailSubject, emailMessage);

                // REDIRECT
                res.sendRedirect("examlist.jsp?success=1");

            }

        } catch (Exception e) {
            e.printStackTrace();
            res.getWriter().println("Error occurred");
        }
    }
}