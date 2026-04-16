package com.queueapp.servlet;

import com.queueapp.dao.QueueDAO;
import com.queueapp.dao.BookingDAO;
import com.queueapp.model.Booking;
import com.queueapp.model.User;
import com.queueapp.model.Hotel;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

public class BookingServlet extends HttpServlet {
    private BookingDAO bookingDAO = new BookingDAO();
    private QueueDAO queueDAO = new QueueDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

        String action = req.getParameter("action");
        if ("book".equals(action)) {
            // Give booking.jsp proper hotel info
            req.setAttribute("hotelId", req.getParameter("hotel_id"));
            req.getRequestDispatcher("/booking.jsp").forward(req, resp);
        } else if ("status".equals(action)) {
            String bookingIdStr = req.getParameter("booking_id");
            if (bookingIdStr != null) {
                int bid = Integer.parseInt(bookingIdStr);
                Booking b = bookingDAO.getBookingById(bid);
                if (b != null && b.getUserId() == user.getId()) {
                    req.setAttribute("booking", b);
                    req.getRequestDispatcher("/bookingStatus.jsp").forward(req, resp);
                    return;
                }
            }
        } else if ("delete".equals(action)) {
            String bookingIdStr = req.getParameter("booking_id");
            if (bookingIdStr != null) {
                int bid = Integer.parseInt(bookingIdStr);
                bookingDAO.deleteBooking(bid, user.getId());
            }
            resp.sendRedirect(req.getContextPath() + "/dashboard");
        } else {
            // Default Dashboard: Shows history or booking options depending on nav
            List<Booking> userHistory = bookingDAO.getBookingsByUser(user.getId());
            req.setAttribute("history", userHistory);
            req.setAttribute("hotels", queueDAO.getAllHotels());
            req.getRequestDispatcher("/dashboard.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/");
            return;
        }

        String hotelIdStr = req.getParameter("hotelId");
        String customerName = req.getParameter("customerName");
        String seatingType = req.getParameter("seatingType"); 
        String bookingTime = req.getParameter("bookingTime");

        if (hotelIdStr != null && customerName != null && seatingType != null && bookingTime != null) {
            int hotelId = Integer.parseInt(hotelIdStr);
            Booking b = queueDAO.addBooking(user.getId(), hotelId, customerName, seatingType, bookingTime);
            if (b != null) {
                // Auto allocate logic check
                Hotel h = queueDAO.getHotelById(hotelId);
                int pos = queueDAO.getQueuePosition(b);
                if (h != null && pos < h.getAvailableTables()) {
                    bookingDAO.updateBookingStatus(b.getId(), "available");
                }
                
                resp.sendRedirect(req.getContextPath() + "/dashboard?action=status&booking_id=" + b.getId());
                return;
            }
        }
        resp.sendRedirect(req.getContextPath() + "/dashboard?error=booking_failed");
    }
}
