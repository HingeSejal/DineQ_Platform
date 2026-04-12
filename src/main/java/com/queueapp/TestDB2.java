package com.queueapp;

import com.queueapp.dao.UserDAO;
import com.queueapp.model.User;

public class TestDB2 {

    public static void main(String[] args) {
        try {
            UserDAO dao = new UserDAO();
            User admin = dao.getUserByUsername("admin");

            if (admin != null) {
                System.out.println("Found admin, hash=" + admin.getPasswordHash() + ", role=" + admin.getRole());
            } else {
                System.out.println("Admin not found!");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}