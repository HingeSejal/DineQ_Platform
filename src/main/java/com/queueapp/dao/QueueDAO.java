package com.queueapp.dao;

import com.queueapp.db.DBConnection;
import com.queueapp.model.Hotel;
import com.queueapp.model.Booking;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class QueueDAO {

    public List<Hotel> getAllHotels() {
        List<Hotel> hotels = new ArrayList<>();
        String sql = "SELECT * FROM hotels";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Hotel h = new Hotel();
                h.setId(rs.getInt("id"));
                h.setName(rs.getString("name"));
                h.setDescription(rs.getString("description"));
                h.setCreatedAt(rs.getTimestamp("created_at"));
                hotels.add(h);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return hotels;
    }

    public Booking addBooking(int userId, int hotelId, String customerName, String seatingType, String bookingTime) {
        // Average dining time is 30 mins
        int estimatedDuration = 30; 
        
        String insertSql = "INSERT INTO bookings (hotel_id, user_id, token_number, customer_name, seating_type, booking_time, estimated_duration) " +
                           "SELECT ?, ?, COALESCE(MAX(token_number), 0) + 1, ?, ?, ?, ? FROM bookings WHERE hotel_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
            
            conn.setAutoCommit(false);
            
            stmt.setInt(1, hotelId);
            stmt.setInt(2, userId);
            stmt.setString(3, customerName);
            stmt.setString(4, seatingType);
            stmt.setString(5, bookingTime);
            stmt.setInt(6, estimatedDuration);
            stmt.setInt(7, hotelId);
            
            int affected = stmt.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        int bookingId = rs.getInt(1);
                        conn.commit();
                        
                        BookingDAO bookingDAO = new BookingDAO();
                        return bookingDAO.getBookingById(bookingId, conn);
                    }
                }
            }
            conn.rollback();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public int getQueuePosition(Booking booking) {
        String sql = "SELECT COUNT(*) as pos FROM bookings WHERE hotel_id = ? AND status = 'waiting' AND token_number < ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, booking.getHotelId());
            stmt.setInt(2, booking.getTokenNumber());
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("pos");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getEstimatedTime(Booking booking) {
        // queue_position * 30 mins
        int queuePosition = getQueuePosition(booking);
        return queuePosition * 30;
    }

    public List<Booking> getActiveBookingsByHotel(int hotelId) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT t.*, s.name as hotel_name FROM bookings t JOIN hotels s ON t.hotel_id = s.id WHERE t.status IN ('waiting', 'serving') AND t.hotel_id = ? ORDER BY t.status DESC, t.created_at ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, hotelId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(extractBooking(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getCurrentBookingsCount(int hotelId) {
        String sql = "SELECT COUNT(*) as current_count FROM bookings WHERE hotel_id = ? AND status IN ('waiting', 'serving')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, hotelId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("current_count");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // For admin history calendar
    public List<Booking> getHistoryBookings(int hotelId) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT t.*, s.name as hotel_name FROM bookings t JOIN hotels s ON t.hotel_id = s.id WHERE t.status IN ('completed', 'skipped') AND t.hotel_id = ? ORDER BY t.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, hotelId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(extractBooking(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    private Booking extractBooking(ResultSet rs) throws SQLException {
        Booking t = new Booking();
        t.setId(rs.getInt("id"));
        t.setHotelId(rs.getInt("hotel_id"));
        t.setUserId(rs.getInt("user_id"));
        t.setTokenNumber(rs.getInt("token_number"));
        t.setCustomerName(rs.getString("customer_name"));
        t.setSeatingType(rs.getString("seating_type"));
        t.setBookingTime(rs.getString("booking_time"));
        t.setEstimatedDuration(rs.getInt("estimated_duration"));
        t.setStatus(rs.getString("status"));
        t.setCreatedAt(rs.getTimestamp("created_at"));
        t.setServedAt(rs.getTimestamp("served_at"));
        
        ResultSetMetaData rsmd = rs.getMetaData();
        int columns = rsmd.getColumnCount();
        for (int x = 1; x <= columns; x++) {
            if ("hotel_name".equals(rsmd.getColumnLabel(x))) {
                t.setHotelName(rs.getString("hotel_name"));
                break;
            }
        }
        return t;
    }
}
