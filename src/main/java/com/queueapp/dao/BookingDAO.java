package com.queueapp.dao;

import com.queueapp.db.DBConnection;
import com.queueapp.model.Booking;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {

    public Booking getBookingById(int id, Connection conn) throws SQLException {
        String sql = "SELECT t.*, s.name as hotel_name FROM bookings t JOIN hotels s ON t.hotel_id = s.id WHERE t.id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractBooking(rs);
                }
            }
        }
        return null;
    }
    
    public Booking getBookingById(int id) {
        try (Connection conn = DBConnection.getConnection()) {
            return getBookingById(id, conn);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Booking> getBookingsByUser(int userId) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT t.*, s.name as hotel_name FROM bookings t JOIN hotels s ON t.hotel_id = s.id WHERE t.user_id = ? ORDER BY t.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
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
    
    public boolean updateBookingStatus(int bookingId, String status) {
        String sql = "UPDATE bookings SET status = ?, served_at = NOW() WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
             
            stmt.setString(1, status);
            stmt.setInt(2, bookingId);
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteBooking(int bookingId, int userId) {
        String sql = "DELETE FROM bookings WHERE id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, bookingId);
            stmt.setInt(2, userId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
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
        if (hasColumn(rs, "hotel_name")) {
            t.setHotelName(rs.getString("hotel_name"));
        }
        return t;
    }
    
    private boolean hasColumn(ResultSet rs, String columnName) throws SQLException {
        ResultSetMetaData rsmd = rs.getMetaData();
        int columns = rsmd.getColumnCount();
        for (int x = 1; x <= columns; x++) {
            if (columnName.equals(rsmd.getColumnLabel(x))) {
                return true;
            }
        }
        return false;
    }
}
