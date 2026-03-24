-- ============================================================
--  E-Voting System  |  MySQL Workbench Setup Script
-- ============================================================

-- ❌ WRONG: delete secured_voting;
-- ✅ CORRECT:
DROP DATABASE IF EXISTS secured_voting;

CREATE DATABASE secured_voting
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE secured_voting;

-- ------------------------------------------------------------
-- 1. Admin credentials
-- ------------------------------------------------------------
CREATE TABLE v_admin_detail (
    id          INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_name   VARCHAR(50) NOT NULL UNIQUE,
    password    VARCHAR(100) NOT NULL
);

INSERT INTO v_admin_detail (user_name, password)
VALUES ('admin', 'admin123');

-- ------------------------------------------------------------
-- 2. Voter (user) login credentials
-- ------------------------------------------------------------
CREATE TABLE v_user_detail (
    id          INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_name   VARCHAR(50) NOT NULL UNIQUE,
    password    VARCHAR(100) NOT NULL
);

INSERT INTO v_user_detail (user_name, password)
VALUES ('user_1', 'user@123');

-- ------------------------------------------------------------
-- 3. Pre-stored voter master data
-- ------------------------------------------------------------
CREATE TABLE v_voterid_prestored_data (
    id          INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    voter_id    VARCHAR(20) NOT NULL UNIQUE,
    voter_name  VARCHAR(100) NOT NULL,
    booth_name  VARCHAR(100) NOT NULL DEFAULT 'Main Booth'
);

INSERT INTO v_voterid_prestored_data (voter_id, voter_name, booth_name) VALUES
('VOTER001', 'votername01', 'Booth A'),
('VOTER002', 'votername02', 'Booth A'),
('VOTER003', 'votername03', 'Booth A'),
('VOTER004', 'votername04', 'Booth B'),
('VOTER005', 'votername05', 'Booth B'),
('VOTER006', 'votername06', 'Booth B'),
('VOTER007', 'votername07', 'Booth C'),
('VOTER008', 'votername08', 'Booth C'),
('VOTER009', 'votername09', 'Booth C'),
('VOTER010', 'votername10', 'Booth C'),
('VOTER011', 'votername11', 'Booth D'),
('VOTER012', 'votername12', 'Booth D'),
('VOTER013', 'votername13', 'Booth D'),
('VOTER014', 'votername14', 'Booth D'),
('VOTER015', 'votername15', 'Booth D');

-- ------------------------------------------------------------
-- 4. Polling tracking
-- ------------------------------------------------------------
CREATE TABLE v_voterid_details (
    id              INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    voter_id        VARCHAR(20) NOT NULL,
    voter_name      VARCHAR(100) NOT NULL,
    polling_status  VARCHAR(20) NOT NULL DEFAULT 'NOT_POLLED',
    verified_at     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (voter_id) REFERENCES v_voterid_prestored_data(voter_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ------------------------------------------------------------
-- 5. Vote result
-- ------------------------------------------------------------
CREATE TABLE vote_result (
    id          INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    voter_id    VARCHAR(20),
    voter_name  VARCHAR(100),
    party_name  VARCHAR(50) NOT NULL,
    voted_at    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- Verification Queries
-- ============================================================

-- Total votes per party
SELECT party_name, COUNT(*) AS votes
FROM vote_result
GROUP BY party_name
ORDER BY votes DESC;

-- Full voter + result view
SELECT vd.voter_id, vd.voter_name, vd.polling_status,
       vr.party_name, vr.voted_at
FROM v_voterid_details vd
LEFT JOIN vote_result vr ON vd.voter_id = vr.voter_id
ORDER BY vr.voted_at DESC;