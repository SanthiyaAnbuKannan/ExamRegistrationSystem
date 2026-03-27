package servlets;

import java.io.*;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import util.DBConnection;

public class CancelExamServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        try {

            int regId = Integer.parseInt(req.getParameter("reg_id"));

            Connection con = DBConnection.getConnection();

            String sql = "DELETE FROM exam_registration WHERE reg_id=?";
            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, regId);

            ps.executeUpdate();

            res.sendRedirect("myexams.jsp?cancel=1");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}