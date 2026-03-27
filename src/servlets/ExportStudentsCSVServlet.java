package servlets;

import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import util.DBConnection;

public class ExportStudentsCSVServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        int examId = Integer.parseInt(req.getParameter("exam_id"));

        res.setContentType("text/csv");
        res.setHeader("Content-Disposition", "attachment; filename=students_exam_" + examId + ".csv");

        PrintWriter out = res.getWriter();

        try {

            Connection con = DBConnection.getConnection();

            String sql = "SELECT s.name, s.reg_no, s.department " +
                    "FROM exam_registration r " +
                    "JOIN student s ON r.student_id = s.id " +
                    "WHERE r.exam_id=?";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, examId);

            ResultSet rs = ps.executeQuery();

            // CSV Header
            out.println("Name,Register No,Department");

            while (rs.next()) {

                out.println(
                        rs.getString("name") + "," +
                                rs.getString("reg_no") + "," +
                                rs.getString("department"));

            }

            rs.close();
            ps.close();
            con.close();

        } catch (Exception e) {

            out.println("Error exporting data");

        }

        out.flush();
        out.close();
    }
}