CREATE DATABASE IF NOT EXISTS queue_db;
USE queue_db;

CREATE TABLE IF NOT EXISTS hotels (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(64) NOT NULL,
    role ENUM('USER', 'ADMIN') NOT NULL DEFAULT 'USER',
    hotel_id INT DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (hotel_id) REFERENCES hotels(id)
);

CREATE TABLE IF NOT EXISTS bookings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    hotel_id INT NOT NULL,
    user_id INT NOT NULL,
    token_number INT NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    seating_type VARCHAR(50) NOT NULL,
    booking_time VARCHAR(50) NOT NULL,
    estimated_duration INT NOT NULL DEFAULT 30,
    status ENUM('waiting', 'serving', 'completed', 'skipped') DEFAULT 'waiting',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    served_at TIMESTAMP NULL,
    FOREIGN KEY (hotel_id) REFERENCES hotels(id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    UNIQUE KEY idx_hotel_booking (hotel_id, token_number)
);

CREATE INDEX idx_bookings_status ON bookings(status);
CREATE INDEX idx_bookings_hotel ON bookings(hotel_id);

CREATE TABLE IF NOT EXISTS queue_config (
    id INT AUTO_INCREMENT PRIMARY KEY,
    config_key VARCHAR(50) UNIQUE NOT NULL,
    config_value VARCHAR(255) NOT NULL
);

-- Insert Dummy Data --
INSERT IGNORE INTO hotels (id, name, description) VALUES (1, 'Grand Palace Hotel', 'Luxury dining and premium tables');
INSERT IGNORE INTO hotels (id, name, description) VALUES (2, 'Sunset Resort Resto', 'Seaside view table bookings');
INSERT IGNORE INTO hotels (id, name, description) VALUES (3, 'Oceanview Grill', 'Fresh seafood and coastal views');
INSERT IGNORE INTO hotels (id, name, description) VALUES (4, 'The Rustic Fork', 'Farm-to-table organic dining');
INSERT IGNORE INTO hotels (id, name, description) VALUES (5, 'Skyline Lounge', 'Rooftop dining with city panorama');
INSERT IGNORE INTO hotels (id, name, description) VALUES (6, 'Steakhouse 42', 'Premium dry-aged stakes and wine');
INSERT IGNORE INTO hotels (id, name, description) VALUES (7, 'Bella Napoli Bistro', 'Authentic Italian wood-fired pizzas');
INSERT IGNORE INTO hotels (id, name, description) VALUES (8, 'Zen Garden Sushi', 'Exquisite sushi and calming ambiance');
INSERT IGNORE INTO hotels (id, name, description) VALUES (9, 'The Velvet Room', 'Exclusive fine dining experience');
INSERT IGNORE INTO hotels (id, name, description) VALUES (10, 'Spice Route Caravan', 'Authentic Pan-Asian flavors');
INSERT IGNORE INTO hotels (id, name, description) VALUES (11, 'Breakfast Club Cafe', 'All-day breakfast and artisanal coffee');
INSERT IGNORE INTO hotels (id, name, description) VALUES (12, 'Midnight Diner', 'Late-night comfort street food');

-- Users matching the hotels
-- Password for all is 'Admin@12' -> 04f8996da763b7a969b1028ee3007569eaf3a635486ddab211d512c85b9df8fb
INSERT IGNORE INTO users (username, password_hash, role, hotel_id) VALUES ('admin_palace', '04f8996da763b7a969b1028ee3007569eaf3a635486ddab211d512c85b9df8fb', 'ADMIN', 1);
INSERT IGNORE INTO users (username, password_hash, role, hotel_id) VALUES ('admin_sunset', '04f8996da763b7a969b1028ee3007569eaf3a635486ddab211d512c85b9df8fb', 'ADMIN', 2);
INSERT IGNORE INTO users (username, password_hash, role, hotel_id) VALUES ('admin_oceanview', '04f8996da763b7a969b1028ee3007569eaf3a635486ddab211d512c85b9df8fb', 'ADMIN', 3);
INSERT IGNORE INTO users (username, password_hash, role, hotel_id) VALUES ('admin_rustic', '04f8996da763b7a969b1028ee3007569eaf3a635486ddab211d512c85b9df8fb', 'ADMIN', 4);
INSERT IGNORE INTO users (username, password_hash, role, hotel_id) VALUES ('admin_skyline', '04f8996da763b7a969b1028ee3007569eaf3a635486ddab211d512c85b9df8fb', 'ADMIN', 5);
INSERT IGNORE INTO users (username, password_hash, role, hotel_id) VALUES ('admin_steakhouse', '04f8996da763b7a969b1028ee3007569eaf3a635486ddab211d512c85b9df8fb', 'ADMIN', 6);
INSERT IGNORE INTO users (username, password_hash, role, hotel_id) VALUES ('admin_bistro', '04f8996da763b7a969b1028ee3007569eaf3a635486ddab211d512c85b9df8fb', 'ADMIN', 7);
INSERT IGNORE INTO users (username, password_hash, role, hotel_id) VALUES ('admin_zen', '04f8996da763b7a969b1028ee3007569eaf3a635486ddab211d512c85b9df8fb', 'ADMIN', 8);
INSERT IGNORE INTO users (username, password_hash, role, hotel_id) VALUES ('admin_velvet', '04f8996da763b7a969b1028ee3007569eaf3a635486ddab211d512c85b9df8fb', 'ADMIN', 9);
INSERT IGNORE INTO users (username, password_hash, role, hotel_id) VALUES ('admin_spice', '04f8996da763b7a969b1028ee3007569eaf3a635486ddab211d512c85b9df8fb', 'ADMIN', 10);
INSERT IGNORE INTO users (username, password_hash, role, hotel_id) VALUES ('admin_cafe', '04f8996da763b7a969b1028ee3007569eaf3a635486ddab211d512c85b9df8fb', 'ADMIN', 11);
INSERT IGNORE INTO users (username, password_hash, role, hotel_id) VALUES ('admin_diner', '04f8996da763b7a969b1028ee3007569eaf3a635486ddab211d512c85b9df8fb', 'ADMIN', 12);

-- user / user (sha256)
INSERT IGNORE INTO users (username, password_hash, role, hotel_id) VALUES ('user', '04f8996da763b7a969b1028ee3007569eaf3a635486ddab211d512c85b9df8fb', 'USER', NULL);
