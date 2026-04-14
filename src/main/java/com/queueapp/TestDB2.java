package com.queueapp;

import com.queueapp.db.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class TestDB2 {
    public static void main(String[] args) {
        System.out.println("Testing DB Connection...");
        try (Connection conn = DBConnection.getConnection()) {
            System.out.println("Connection successful!");
            
            String sql = "SELECT count(*) FROM users";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        System.out.println("Users count: " + rs.getInt(1));
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}