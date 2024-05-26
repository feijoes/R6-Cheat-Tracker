-- Add migration script here

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE
    "users" (
        id UUID NOT NULL PRIMARY KEY DEFAULT (uuid_generate_v4()),
        name VARCHAR(100) NOT NULL,
        email VARCHAR(255) NOT NULL UNIQUE,
        photo VARCHAR,
        verified BOOLEAN NOT NULL DEFAULT FALSE,
        password VARCHAR(100) NOT NULL,
        role VARCHAR(50) NOT NULL DEFAULT 'user',
        created_at TIMESTAMP
        WITH
            TIME ZONE DEFAULT NOW(),
            updated_at TIMESTAMP
        WITH
            TIME ZONE DEFAULT NOW()
    );

CREATE INDEX users_email_idx ON users (email);

CREATE TABLE CheaterReports (
    report_id INT AUTO_INCREMENT PRIMARY KEY,
    reporter_id INT NOT NULL,
    platform ENUM('pc', 'psn', 'xbox') NOT NULL,
    cheater_ubisoft_account VARCHAR(255) NOT NULL,
    plataform 
    evidence_video_url VARCHAR(255) NOT NULL,
    comments TEXT,
    reported_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    verified BOOLEAN DEFAULT FALSE
);
