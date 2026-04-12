package com.queueapp.servlet;

import com.queueapp.dao.QueueDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;

public class AdminAuthServlet extends HttpServlet {
    private QueueDAO queueDAO = new QueueDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        
        if ("login".equals(action)) {
            String hotelId = req.getParameter("hotelId");
            if (hotelId == null) {
                resp.sendRedirect(req.getContextPath() + "/adminAuth");
                return;
            }
            req.getRequestDispatcher("/adminLogin.jsp").forward(req, resp);
        } else {
            // Default: show the hotel selection
            req.setAttribute("hotels", queueDAO.getAllHotels());
            req.getRequestDispatcher("/adminHotelSelect.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String user = req.getParameter("username");
        String pass = req.getParameter("password");
        String hotelIdStr = req.getParameter("hotelId");

        if ("admin".equals(user) && "Admin@1234".equals(pass)) {
            if (hotelIdStr != null && !hotelIdStr.isEmpty()) {
                HttpSession session = req.getSession();
                session.setAttribute("role", "admin");
                session.setAttribute("adminHotelId", Integer.parseInt(hotelIdStr));
                
                resp.sendRedirect(req.getContextPath() + "/admin");
                return;
            }
        }
        
        // Return back to same login panel if failure
        req.setAttribute("error", "Invalid Terminal Credentials");
        req.getRequestDispatcher("/adminLogin.jsp?hotelId=" + hotelIdStr).forward(req, resp);
    }
}
