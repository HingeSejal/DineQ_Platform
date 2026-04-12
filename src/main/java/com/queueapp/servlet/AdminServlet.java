package com.queueapp.servlet;

import com.queueapp.dao.QueueDAO;
import com.queueapp.dao.BookingDAO;
import com.queueapp.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;

public class AdminServlet extends HttpServlet {
    private QueueDAO queueDAO = new QueueDAO();
    private BookingDAO bookingDAO = new BookingDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String role = (String) req.getSession().getAttribute("role");
        Integer hotelId = (Integer) req.getSession().getAttribute("adminHotelId");

        if (!"admin".equals(role) || hotelId == null) {
            resp.sendRedirect(req.getContextPath() + "/adminAuth");
            return;
        }
        
        req.setAttribute("activeTokens", queueDAO.getActiveBookingsByHotel(hotelId));
        req.setAttribute("historyTokens", queueDAO.getHistoryBookings(hotelId));
        req.getRequestDispatcher("/admin.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String role = (String) req.getSession().getAttribute("role");
        Integer hotelId = (Integer) req.getSession().getAttribute("adminHotelId");

        if (!"admin".equals(role) || hotelId == null) {
            resp.sendRedirect(req.getContextPath() + "/adminAuth");
            return;
        }
        
        String tokenIdStr = req.getParameter("tokenId");
        String status = req.getParameter("status"); // 'serving', 'completed', 'skipped'
        
        if (tokenIdStr != null && status != null) {
            int tokenId = Integer.parseInt(tokenIdStr);
            bookingDAO.updateBookingStatus(tokenId, status);
        }
        
        resp.sendRedirect(req.getContextPath() + "/admin");
    }
}
