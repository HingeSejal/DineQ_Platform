<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DineQ | Premium Dining</title>
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;700&family=Playfair+Display:ital,wght@0,500;0,600;0,700;1,500&display=swap" rel="stylesheet">
    <!-- FontAwesome CDN for modern icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<%
    String currentURI = request.getRequestURI();
%>
<header class="navbar">
    <h1>
        <div class="nav-logo-box"><i class="fa-solid fa-utensils"></i></div>
        DineQ
    </h1>
    <div class="nav-links">
        <% 
            com.queueapp.model.User user = (com.queueapp.model.User) session.getAttribute("user");
            String role = (String) session.getAttribute("role");
            
            if ("admin".equals(role)) { 
        %>
            <a href="<%= request.getContextPath() %>/admin" class="<%= currentURI.contains("/admin") ? "active" : "" %>"><i class="fa-solid fa-chart-pie"></i> Admin Panel</a>
            <a href="<%= request.getContextPath() %>/auth?action=logout" class="logout-btn"><i class="fa-solid fa-power-off"></i> Logout</a>
        <% } else if (user != null) { %>
            <a href="<%= request.getContextPath() %>/dashboard" class="<%= currentURI.contains("/dashboard") || currentURI.contains("/booking") ? "active" : "" %>"><i class="fa-solid fa-building"></i> Directory</a>
            <a href="<%= request.getContextPath() %>/auth?action=logout" class="logout-btn"><i class="fa-solid fa-power-off"></i> Logout</a>
        <% } else { %>
            <a href="<%= request.getContextPath() %>/index.jsp" class="<%= currentURI.contains("/index.jsp") || currentURI.equals("/") ? "active" : "" %>">Login</a>
            <a href="<%= request.getContextPath() %>/signup.jsp" class="<%= currentURI.contains("/signup.jsp") ? "active" : "" %>">Sign Up</a>
        <% } %>
    </div>
</header>
<main class="container">
