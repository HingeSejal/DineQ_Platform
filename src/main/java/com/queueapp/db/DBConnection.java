package com.queueapp.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    public static Connection getConnection() throws SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("MySQL Driver not found.", e);
        }

        String url = System.getenv("DB_URL");
        String user = System.getenv("DB_USER");
        String pass = System.getenv("DB_PASS");

        if (url == null) url = "jdbc:mysql://localhost:3306/queue_db";
        if (user == null) user = "queue_user";
        if (pass == null) pass = "queue_password";

        if (!url.contains("allowPublicKeyRetrieval")) {
            url += (url.contains("?") ? "&" : "?") + "allowPublicKeyRetrieval=true&useSSL=false";
        }

        return DriverManager.getConnection(url, user, pass);
    }
}
