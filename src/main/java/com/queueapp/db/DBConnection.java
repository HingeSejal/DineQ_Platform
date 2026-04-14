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

        if (url == null) url = "jdbc:postgresql://ep-plain-block-a1h9ffwn-pooler.ap-southeast-1.aws.neon.tech:5432/neondb";
        if (user == null) user = "neondb_owner";
        if (pass == null) pass = "npg_XexFlgN0WLd3";

        if (!url.contains("sslmode")) {
            url += (url.contains("?") ? "&" : "?") + "sslmode=require";
        }

        return DriverManager.getConnection(url, user, pass);
    }
}