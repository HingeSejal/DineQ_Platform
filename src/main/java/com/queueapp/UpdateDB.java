package com.queueapp;

import com.queueapp.db.DBConnection;
import java.sql.Connection;
import java.sql.Statement;

public class UpdateDB {
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            
            System.out.println("Adding admin_username mapping...");
            try {
                stmt.execute("ALTER TABLE hotels ADD COLUMN admin_username VARCHAR(50);");
            } catch(Exception e) { System.out.println(e.getMessage()); }
            
            System.out.println("Adding admin_pin mapping...");
            try {
                stmt.execute("ALTER TABLE hotels ADD COLUMN admin_pin VARCHAR(20);");
            } catch(Exception e) { System.out.println(e.getMessage()); }
            
            System.out.println("Adding available_tables mapping...");
            try {
                stmt.execute("ALTER TABLE hotels ADD COLUMN available_tables INT DEFAULT 0;");
            } catch(Exception e) { System.out.println(e.getMessage()); }
            
            System.out.println("Updates complete!");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
