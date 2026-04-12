package com.queueapp.servlet;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.queueapp.dao.QueueDAO;
import com.queueapp.dao.BookingDAO;
import com.queueapp.model.Booking;
import com.queueapp.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.PrintWriter;

public class QueueServlet extends HttpServlet {
    private QueueDAO queueDAO = new QueueDAO();
    private BookingDAO bookingDAO = new BookingDAO();
    private Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");

        String hotelStatsId = req.getParameter("hotel_id_stats");
        if (hotelStatsId != null) {
            int hotelId = Integer.parseInt(hotelStatsId);
            int activeCount = queueDAO.getCurrentBookingsCount(hotelId);
            int estWait = activeCount * 30; // 30 mins per existing active booking
            
            JsonObject res = new JsonObject();
            res.addProperty("waitMins", estWait);
            res.addProperty("bookingsCount", activeCount);
            
            try (PrintWriter out = resp.getWriter()) {
                out.print(gson.toJson(res));
                out.flush();
            }
            return;
        }

        String tokenIdStr = req.getParameter("token_id");
        if (tokenIdStr == null) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        int bookingId = Integer.parseInt(tokenIdStr);
        Booking b = bookingDAO.getBookingById(bookingId);
        
        if (b == null) {
            resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        int pos = queueDAO.getQueuePosition(b);
        int waitMins = queueDAO.getEstimatedTime(b);

        JsonObject json = new JsonObject();
        json.addProperty("status", b.getStatus());
        json.addProperty("position", pos);
        json.addProperty("waitMins", waitMins);
        json.addProperty("tokenNumber", b.getTokenNumber());
        json.addProperty("customerName", b.getCustomerName());

        try (PrintWriter out = resp.getWriter()) {
            out.print(gson.toJson(json));
            out.flush();
        }
    }
}
