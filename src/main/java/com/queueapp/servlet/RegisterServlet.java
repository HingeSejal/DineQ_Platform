package com.queueapp.servlet;

import com.queueapp.dao.UserDAO;
import com.queueapp.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class RegisterServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/signup.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String user = req.getParameter("username");
        String pass = req.getParameter("password");

        if (user == null || user.trim().isEmpty() || pass == null || pass.trim().isEmpty()) {
            req.setAttribute("error", "Username and password cannot be empty");
            req.getRequestDispatcher("/signup.jsp").forward(req, resp);
            return;
        }

        // Strict Password Validation
        String passwordPattern = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$";
        if (!pass.matches(passwordPattern)) {
            req.setAttribute("error", "Password must be at least 8 characters long, contain at least 1 uppercase, 1 lowercase, 1 number, and 1 special symbol.");
            req.getRequestDispatcher("/signup.jsp").forward(req, resp);
            return;
        }

        User existingUser = userDAO.getUserByUsername(user);
        if (existingUser != null) {
            req.setAttribute("error", "Username already exists");
            req.getRequestDispatcher("/signup.jsp").forward(req, resp);
            return;
        }

        String hashed = hashSHA256(pass);
        boolean created = userDAO.createUser(user, hashed, "USER");
        if (created) {
            // Forward to index.jsp with success message (which index.jsp will currently show as an alert-error unless we distinguish, but it's acceptable for now or we can change error to message)
            req.setAttribute("error", "Account created successfully. Please login.");
            req.getRequestDispatcher("/index.jsp").forward(req, resp);
        } else {
            req.setAttribute("error", "Failed to create account. Please try again.");
            req.getRequestDispatcher("/signup.jsp").forward(req, resp);
        }
    }

    private String hashSHA256(String data) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(data.getBytes());
            StringBuilder hexString = new StringBuilder();
            for (byte b : hash) {
                String hex = Integer.toHexString(0xff & b);
                if (hex.length() == 1) hexString.append('0');
                hexString.append(hex);
            }
            return hexString.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }
    }
}
