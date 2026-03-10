-- =============================================
-- Health Insurance QC System - Database Schema
-- =============================================

CREATE DATABASE IF NOT EXISTS health_insurance_qc;
USE health_insurance_qc;

-- Drop tables in reverse dependency order
DROP TABLE IF EXISTS claims;
DROP TABLE IF EXISTS policies;
DROP TABLE IF EXISTS providers;
DROP TABLE IF EXISTS patients;

-- ----------------------------
-- Table: patients
-- ----------------------------
CREATE TABLE patients (
    patient_id    INT            PRIMARY KEY AUTO_INCREMENT,
    full_name     VARCHAR(100)   NOT NULL,
    age           INT,
    gender        VARCHAR(10),
    bmi           DECIMAL(5,2),
    smoker        VARCHAR(5),
    region        VARCHAR(50),
    email         VARCHAR(100),
    phone         VARCHAR(20),
    created_at    DATE
);

-- ----------------------------
-- Table: providers
-- ----------------------------
CREATE TABLE providers (
    provider_id   INT            PRIMARY KEY AUTO_INCREMENT,
    provider_name VARCHAR(100)   NOT NULL,
    provider_type VARCHAR(50),
    region        VARCHAR(50),
    license_no    VARCHAR(30),
    contact_email VARCHAR(100)
);

-- ----------------------------
-- Table: policies
-- ----------------------------
CREATE TABLE policies (
    policy_id       INT            PRIMARY KEY AUTO_INCREMENT,
    patient_id      INT,
    policy_type     VARCHAR(50),
    premium_amount  DECIMAL(10,2),
    coverage_amount DECIMAL(10,2),
    policy_start    DATE,
    policy_end      DATE,
    status          VARCHAR(20),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);

-- ----------------------------
-- Table: claims
-- ----------------------------
CREATE TABLE claims (
    claim_id       INT            PRIMARY KEY AUTO_INCREMENT,
    policy_id      INT,
    provider_id    INT,
    claim_date     DATE,
    claim_amount   DECIMAL(10,2),
    diagnosis_code VARCHAR(20),
    claim_status   VARCHAR(20),
    notes          TEXT,
    FOREIGN KEY (policy_id)   REFERENCES policies(policy_id),
    FOREIGN KEY (provider_id) REFERENCES providers(provider_id)
);
