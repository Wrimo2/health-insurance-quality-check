-- =============================================
-- Health Insurance QC System - Seed Data
-- Includes intentional dirty data for QC checks
-- =============================================

USE health_insurance_qc;

-- ----------------------------
-- Seed: patients (20 rows)
-- ----------------------------
INSERT INTO patients (full_name, age, gender, bmi, smoker, region, email, phone, created_at) VALUES
('Aarav Sharma',       28, 'M',    24.50, 'no',  'north', 'aarav.sharma@gmail.com',   '9876543210', '2023-01-15'),
('Priya Patel',        35, 'F',    27.30, 'no',  'west',  'priya.patel@yahoo.com',    '9123456789', '2023-02-20'),
('Rohit Verma',        42, 'M',    31.00, 'yes', 'south', 'rohit.verma@outlook.com',  '8765432109', '2023-03-10'),
('Sneha Iyer',         29, 'F',    22.10, 'no',  'south', 'sneha.iyer@gmail.com',     '7654321098', '2023-04-05'),
('Vikram Singh',       55, 'M',    28.90, 'yes', 'north', 'vikram.singh@email.com',   '6543210987', '2023-05-12'),
-- DIRTY: NULL age
('Ananya Gupta',     NULL, 'F',    25.00, 'no',  'east',  'ananya.gupta@gmail.com',   '5432109876', '2023-06-18'),
-- DIRTY: age out of range (negative)
('Karan Mehta',       -5,  'M',    26.70, 'no',  'west',  'karan.mehta@gmail.com',    '4321098765', '2023-07-22'),
-- DIRTY: age out of range (too high)
('Deepa Nair',       200,  'F',    23.40, 'yes', 'south', 'deepa.nair@yahoo.com',     '3210987654', '2023-08-30'),
-- DIRTY: invalid gender format
('Amit Kumar',        38, 'male',  29.50, 'no',  'north', 'amit.kumar@gmail.com',     '2109876543', '2023-09-14'),
-- DIRTY: invalid smoker format
('Neha Reddy',        31, 'F',    24.80, 'YES', 'south', 'neha.reddy@outlook.com',   '1098765432', '2023-10-01'),
-- DIRTY: BMI out of range
('Rajesh Tiwari',     45, 'M',   999.00, 'yes', 'east',  'rajesh.tiwari@gmail.com',  '9988776655', '2023-10-20'),
-- DIRTY: invalid email
('Pooja Deshmukh',    27, 'F',    21.50, 'no',  'west',  'pooja@',                   '8877665544', '2023-11-05'),
-- DIRTY: invalid phone (too short)
('Suresh Joshi',      50, 'M',    30.20, 'yes', 'north', 'suresh.joshi@gmail.com',   '12345',      '2023-11-15'),
('Kavita Rao',        33, 'F',    26.10, 'no',  'south', 'kavita.rao@yahoo.com',     '7766554433', '2023-12-01'),
('Manish Agarwal',    41, 'M',    27.80, 'no',  'east',  'manish.agarwal@gmail.com', '6655443322', '2024-01-10'),
-- DIRTY: invalid email (plain text)
('Swati Mishra',      36, 'F',    23.90, 'no',  'north', 'plaintext',                '5544332211', '2024-01-25'),
('Arjun Pillai',      48, 'M',    32.50, 'yes', 'south', 'arjun.pillai@gmail.com',   '4433221100', '2024-02-14'),
('Divya Saxena',      26, 'F',    20.80, 'no',  'west',  'divya.saxena@outlook.com', '3322110099', '2024-03-01'),
-- DIRTY: duplicate of Aarav Sharma (same name, age, gender)
('Aarav Sharma',      28, 'M',    24.50, 'no',  'north', 'aarav.dup@gmail.com',      '2211009988', '2024-03-15'),
('Aarav Sharma',      -28, 'M',    24.50, 'no',  'north', 'aarav.dup@gmail.com',      '2211009988', '2024-03-15'),
('Lakshmi Menon',     39, 'F',    25.60, 'no',  'south', 'lakshmi.menon@gmail.com',  '1100998877', '2024-04-01');


-- ----------------------------
-- Seed: providers (10 rows)
-- ----------------------------
INSERT INTO providers (provider_name, provider_type, region, license_no, contact_email) VALUES
('Apollo Hospitals',        'hospital',   'south', 'MED-1001', 'contact@apollo.com'),
('Fortis Healthcare',       'hospital',   'north', 'MED-1002', 'info@fortis.com'),
('Max Super Speciality',    'specialist', 'north', 'MED-1003', 'admin@maxhealth.com'),
('Manipal Hospitals',       'hospital',   'south', 'MED-1004', 'support@manipal.com'),
('Medanta - The Medicity',  'specialist', 'north', 'MED-1005', 'care@medanta.com'),
('City Clinic',             'clinic',     'west',  'MED-1006', 'hello@cityclinic.com'),
('Sunshine Medical Center', 'clinic',     'east',  'MED-1007', 'info@sunshine.com'),
-- DIRTY: invalid license format
('Global Health Hub',       'hospital',   'west',  'ABC',      'contact@globalhub.com'),
-- DIRTY: NULL provider name
('',                        'clinic',     'east',  'MED-1009', 'admin@noname.com'),
('Wellness First',          'specialist', 'south', 'MED-1010', 'care@wellnessfirst.com');


-- ----------------------------
-- Seed: policies (20 rows)
-- ----------------------------
INSERT INTO policies (patient_id, policy_type, premium_amount, coverage_amount, policy_start, policy_end, status) VALUES
(1,  'premium',   15000.00, 500000.00, '2023-01-01', '2024-01-01', 'active'),
(2,  'standard',   8000.00, 300000.00, '2023-03-01', '2024-03-01', 'active'),
(3,  'basic',      4000.00, 100000.00, '2023-04-01', '2024-04-01', 'expired'),
(4,  'premium',   16000.00, 500000.00, '2023-05-01', '2024-05-01', 'active'),
(5,  'standard',   9000.00, 300000.00, '2023-06-01', '2024-06-01', 'active'),
(6,  'basic',      3500.00, 100000.00, '2023-07-01', '2024-07-01', 'cancelled'),
(7,  'standard',   7500.00, 250000.00, '2023-08-01', '2024-08-01', 'active'),
(8,  'premium',   18000.00, 600000.00, '2023-09-01', '2024-09-01', 'active'),
(9,  'basic',      4500.00, 150000.00, '2023-10-01', '2024-10-01', 'active'),
(10, 'standard',   8500.00, 300000.00, '2023-11-01', '2024-11-01', 'active'),
-- DIRTY: negative premium
(11, 'premium',   -500.00,  500000.00, '2024-01-01', '2025-01-01', 'active'),
-- DIRTY: policy_end before policy_start
(12, 'standard',   7000.00, 200000.00, '2024-06-01', '2023-06-01', 'active'),
-- DIRTY: invalid policy status
(13, 'basic',      5000.00, 150000.00, '2024-01-15', '2025-01-15', 'pending'),
(14, 'premium',   14000.00, 450000.00, '2024-02-01', '2025-02-01', 'active'),
(15, 'standard',   8200.00, 280000.00, '2024-03-01', '2025-03-01', 'active'),
-- DIRTY: NULL policy dates
(16, 'basic',      3800.00, 120000.00,  NULL,         NULL,         'active'),
(17, 'premium',   17000.00, 550000.00, '2024-05-01', '2025-05-01', 'expired'),
(18, 'standard',   7800.00, 260000.00, '2024-06-01', '2025-06-01', 'active'),
-- DIRTY: duplicate policy for patient 1 (same patient, same type)
(1,  'premium',   15500.00, 500000.00, '2024-07-01', '2025-07-01', 'active'),
(20, 'basic',      4200.00, 130000.00, '2024-08-01', '2025-08-01', 'active');


-- ----------------------------
-- Seed: claims (25 rows)
-- ----------------------------
INSERT INTO claims (policy_id, provider_id, claim_date, claim_amount, diagnosis_code, claim_status, notes) VALUES
(1,  1,  '2023-06-15', 25000.00,  'A09',     'approved', 'Gastroenteritis treatment'),
(1,  2,  '2023-08-20', 15000.00,  'J06.9',   'approved', 'Upper respiratory infection'),
(2,  3,  '2023-09-10', 45000.00,  'E11.9',   'pending',  'Type 2 diabetes management'),
(3,  1,  '2023-10-05',  8000.00,  'M54.5',   'approved', 'Lower back pain'),
(4,  4,  '2023-11-12', 120000.00, 'C50',     'approved', 'Breast cancer screening'),
(5,  5,  '2023-12-01', 35000.00,  'I10',     'rejected', 'Hypertension follow-up'),
(6,  6,  '2023-09-15', 12000.00,  'K21.0',   'approved', 'GERD treatment'),
(7,  7,  '2024-01-20', 18000.00,  'J45.9',   'pending',  'Asthma management'),
(8,  1,  '2024-02-14', 55000.00,  'N18.3',   'approved', 'Chronic kidney disease stage 3'),
(9,  2,  '2024-03-10',  9500.00,  'L40',     'approved', 'Psoriasis treatment'),
(10, 3,  '2024-04-05', 22000.00,  'G43.9',   'pending',  'Migraine management'),
-- DIRTY: negative claim amount
(1,  4,  '2023-07-10', -200.00,   'B34.9',   'approved', 'Viral infection'),
-- DIRTY: orphan claim (policy_id 9999 doesn't exist) — uses valid FK for insert, will be updated
(2,  5,  '2023-10-20', 30000.00,  'D64.9',   'pending',  'Anemia workup'),
-- DIRTY: claim date before policy start (policy 3 starts 2023-04-01)
(3,  6,  '2022-01-15', 10000.00,  'R51',     'approved', 'Headache evaluation'),
-- DIRTY: claim date after policy end (policy 3 ends 2024-04-01)
(3,  7,  '2025-12-01', 11000.00,  'R10.9',   'approved', 'Abdominal pain'),
-- DIRTY: invalid diagnosis code
(4,  1,  '2023-08-22', 40000.00,  'INVALID', 'approved', 'Unknown condition'),
-- DIRTY: NULL claim amount
(5,  2,  '2024-01-05',  NULL,     'J18.9',   'pending',  'Pneumonia treatment'),
-- DIRTY: invalid claim status
(6,  3,  '2023-08-20', 15000.00,  'E78.5',   'processing', 'Cholesterol management'),
-- DIRTY: claim amount exceeds coverage (policy 9 coverage = 150000)
(9,  4,  '2024-05-15', 200000.00, 'S72.0',   'approved', 'Hip fracture surgery'),
-- DIRTY: duplicate claim (same policy, date, amount as row 1)
(1,  1,  '2023-06-15', 25000.00,  'A09',     'approved', 'Duplicate gastroenteritis claim'),
(10, 5,  '2024-06-20', 28000.00,  'M17.1',   'approved', 'Knee osteoarthritis'),
(14, 6,  '2024-04-10', 16000.00,  'H52.1',   'pending',  'Myopia correction'),
(15, 7,  '2024-05-25', 19000.00,  'K29.7',   'approved', 'Gastritis treatment'),
(17, 1,  '2024-07-14', 42000.00,  'I25.1',   'approved', 'Coronary artery disease'),
(18, 2,  '2024-08-03', 13000.00,  'N40.0',   'pending',  'Prostate hyperplasia');
