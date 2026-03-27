package servlets;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class AdminLoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        // Temporary Hardcoded Admin
        if (username.equals("admin") && password.equals("123")) {

            HttpSession session = req.getSession();
            session.setAttribute("admin", "true");

            res.sendRedirect("admin.jsp");

        } else {
            // ===== CHANGED THIS PART =====
            // Instead of printing error text, redirect back to admin login page with error
            // parameter
            // This will show the error message on the same admin login page
            res.sendRedirect("admin_login.jsp?error=invalid");
            // =============================
        }
    }
}