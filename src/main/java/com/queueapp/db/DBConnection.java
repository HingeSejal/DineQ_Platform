package com.queueapp.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("PostgreSQL Driver not found.", e);
        }

        String url = System.getenv("DB_URL");
        String user = System.getenv("DB_USER");
        String pass = System.getenv("DB_PASS");

        if (url == null) url = "jdbc:postgresql://localhost:5432/queue_db";
        if (user == null) user = "queue_user";
        if (pass == null) pass = "queue_password";

        if (!url.contains("sslmode")) {
            url += (url.contains("?") ? "&" : "?") + "sslmode=require";
        }

        return DriverManager.getConnection(url, user, pass);
    }
}
