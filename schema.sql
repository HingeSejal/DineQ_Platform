CREATE TABLE IF NOT EXISTS hotels (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    admin_username VARCHAR(50),
    admin_pin VARCHAR(20),
    available_tables INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password_hash VARCHAR(64) NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'USER',
    hotel_id INT DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (hotel_id) REFERENCES hotels(id)
);

CREATE TABLE IF NOT EXISTS bookings (
    id SERIAL PRIMARY KEY,
    hotel_id INT NOT NULL,
    user_id INT NOT NULL,
    token_number INT NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    seating_type VARCHAR(50) NOT NULL,
    booking_time VARCHAR(50) NOT NULL,
    estimated_duration INT NOT NULL DEFAULT 30,
    status VARCHAR(20) DEFAULT 'waiting',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    served_at TIMESTAMP NULL,
    FOREIGN KEY (hotel_id) REFERENCES hotels(id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    UNIQUE (hotel_id, token_number)
);

CREATE INDEX idx_bookings_status ON bookings(status);
CREATE INDEX idx_bookings_hotel ON bookings(hotel_id);

CREATE TABLE IF NOT EXISTS queue_config (
    id SERIAL PRIMARY KEY,
    config_key VARCHAR(50) UNIQUE NOT NULL,
    config_value VARCHAR(255) NOT NULL
);

-- Insert Dummy Data --
INSERT INTO hotels (id, name, description) VALUES (1, 'Grand Palace Hotel', 'Luxury dining and premium tables') ON CONFLICT (id) DO NOTHING;
INSERT INTO hotels (id, name, description) VALUES (2, 'Sunset Resort Resto', 'Seaside view table bookings') ON CONFLICT (id) DO NOTHING;
INSERT INTO hotels (id, name, description) VALUES (3, 'Oceanview Grill', 'Fresh seafood and coastal views') ON CONFLICT (id) DO NOTHING;
INSERT INTO hotels (id, name, description) VALUES (4, 'The Rustic Fork', 'Farm-to-table organic dining') ON CONFLICT (id) DO NOTHING;
INSERT INTO hotels (id, name, description) VALUES (5, 'Skyline Lounge', 'Rooftop dining with city panorama') ON CONFLICT (id) DO NOTHING;
INSERT INTO hotels (id, name, description) VALUES (6, 'Steakhouse 42', 'Premium dry-aged stakes and wine') ON CONFLICT (id) DO NOTHING;
INSERT INTO hotels (id, name, description) VALUES (7, 'Bella Napoli Bistro', 'Authentic Italian wood-fired pizzas') ON CONFLICT (id) DO NOTHING;
INSERT INTO hotels (id, name, description) VALUES (8, 'Zen Garden Sushi', 'Exquisite sushi and calming ambiance') ON CONFLICT (id) DO NOTHING;
INSERT INTO hotels (id, name, description) VALUES (9, 'The Velvet Room', 'Exclusive fine dining experience') ON CONFLICT (id) DO NOTHING;
INSERT INTO hotels (id, name, description) VALUES (10, 'Spice Route Caravan', 'Authentic Pan-Asian flavors') ON CONFLICT (id) DO NOTHING;
INSERT INTO hotels (id, name, description) VALUES (11, 'Breakfast Club Cafe', 'All-day breakfast and artisanal coffee') ON CONFLICT (id) DO NOTHING;
INSERT INTO hotels (id, name, description) VALUES (12, 'Midnight Diner', 'Late-night comfort street food') ON CONFLICT (id) DO NOTHING;

-- Users matching the hotels
-- Password for all is 'Admin@12' -> 04f8996da763b7a969b1028ee3007569eaf3a635486ddab211d512c85b9df8fb
INSERT INTO users (username, password_hash, role, hotel_id) VALUES ('admin_palace', '04f8996da763b7a969b1028ee3007569eaf3a635486ddab211d512c85b9df8fb', 'ADMIN', 1) ON CONFLICT (username) DO NOTHING;
INSERT INTO users (username, password_hash, role, hotel_id) VALUES ('admin_sunset', '04f8996da763b7a969b1028ee3007569eaf3a635486ddab211d512c85b9df8fb', 'ADMIN', 2) ON CONFLICT (username) DO NOTHING;
INSERT INTO users (username, password_hash, role, hotel_id) VALUES ('admin_oceanview', '04f8996da763b7a969b1028ee3007569eaf3a635486ddab211d512c85b9df8fb', 'ADMIN', 3) ON CONFLICT (username) DO NOTHING;
INSERT INTO users (username, password_hash, role, hotel_id) VALUES ('admin_rustic', '04f8996da763b7a969b1028ee3007569eaf3a635486ddab211d512c85b9df8fb', 'ADMIN', 4) ON CONFLICT (username) DO NOTHING;
INSERT INTO users (username, password_hash, role, hotel_id) VALUES ('admin_skyline', '04f8996da763b7a969b1028ee3007569eaf3a635486ddab211d512c85b9df8fb', 'ADMIN', 5) ON CONFLICT (username) DO NOTHING;
INSERT INTO users (username, password_hash, role, hotel_id) VALUES ('admin_steakhouse', '04f8996da763b7a969b1028ee3007569eaf3a635486ddab211d512c85b9df8fb', 'ADMIN', 6) ON CONFLICT (username) DO NOTHING;
INSERT INTO users (username, password_hash, role, hotel_id) VALUES ('admin_bistro', '04f8996da763b7a969b1028ee3007569eaf3a635486ddab211d512c85b9df8fb', 'ADMIN', 7) ON CONFLICT (username) DO NOTHING;
INSERT INTO users (username, password_hash, role, hotel_id) VALUES ('admin_zen', '04f8996da763b7a969b1028ee3007569eaf3a635486ddab211d512c85b9df8fb', 'ADMIN', 8) ON CONFLICT (username) DO NOTHING;
INSERT INTO users (username, password_hash, role, hotel_id) VALUES ('admin_velvet', '04f8996da763b7a969b1028ee3007569eaf3a635486ddab211d512c85b9df8fb', 'ADMIN', 9) ON CONFLICT (username) DO NOTHING;
INSERT INTO users (username, password_hash, role, hotel_id) VALUES ('admin_spice', '04f8996da763b7a969b1028ee3007569eaf3a635486ddab211d512c85b9df8fb', 'ADMIN', 10) ON CONFLICT (username) DO NOTHING;
INSERT INTO users (username, password_hash, role, hotel_id) VALUES ('admin_cafe', '04f8996da763b7a969b1028ee3007569eaf3a635486ddab211d512c85b9df8fb', 'ADMIN', 11) ON CONFLICT (username) DO NOTHING;
INSERT INTO users (username, password_hash, role, hotel_id) VALUES ('admin_diner', '04f8996da763b7a969b1028ee3007569eaf3a635486ddab211d512c85b9df8fb', 'ADMIN', 12) ON CONFLICT (username) DO NOTHING;

-- user / user (sha256)
INSERT INTO users (username, password_hash, role, hotel_id) VALUES ('user', '04f8996da763b7a969b1028ee3007569eaf3a635486ddab211d512c85b9df8fb', 'USER', NULL) ON CONFLICT (username) DO NOTHING;
