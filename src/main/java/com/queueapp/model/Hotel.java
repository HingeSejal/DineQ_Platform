package com.queueapp.model;

import java.sql.Timestamp;

public class Hotel {
    private int id;
    private String name;
    private String description;
    private Timestamp createdAt;
    private String adminUsername;
    private String adminPin;
    private int availableTables;

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public String getAdminUsername() { return adminUsername; }
    public void setAdminUsername(String adminUsername) { this.adminUsername = adminUsername; }

    public String getAdminPin() { return adminPin; }
    public void setAdminPin(String adminPin) { this.adminPin = adminPin; }

    public int getAvailableTables() { return availableTables; }
    public void setAvailableTables(int availableTables) { this.availableTables = availableTables; }
}
