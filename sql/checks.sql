-- =============================================
-- Health Insurance QC System - Validation Queries
-- Each query returns offending rows.
-- 0 rows = PASS, any rows = FAIL
-- =============================================

-- =====================
-- NULL CHECKS
-- =====================

-- NC-01: Null patient age
-- check_id: NC-01
-- name: Null patient age
-- category: Null Check
SELECT patient_id, full_name, age
FROM patients
WHERE age IS NULL;

-- NC-02: Null claim amount
-- check_id: NC-02
-- name: Null claim amount
-- category: Null Check
SELECT claim_id, policy_id, claim_amount
FROM claims
WHERE claim_amount IS NULL;

-- NC-03: Null policy dates
-- check_id: NC-03
-- name: Null policy dates
-- category: Null Check
SELECT policy_id, patient_id, policy_start, policy_end
FROM policies
WHERE policy_start IS NULL OR policy_end IS NULL;

-- NC-04: Null provider name
-- check_id: NC-04
-- name: Null or empty provider name
-- category: Null Check
SELECT provider_id, provider_name
FROM providers
WHERE provider_name IS NULL OR provider_name = '';


-- =====================
-- RANGE CHECKS
-- =====================

-- RC-01: Invalid age range
-- check_id: RC-01
-- name: Invalid age range
-- category: Range Check
SELECT patient_id, full_name, age
FROM patients
WHERE age < 0 OR age > 120;

-- RC-02: Invalid BMI range
-- check_id: RC-02
-- name: Invalid BMI range
-- category: Range Check
SELECT patient_id, full_name, bmi
FROM patients
WHERE bmi < 10 OR bmi > 60;

-- RC-03: Negative claim amount
-- check_id: RC-03
-- name: Negative claim amount
-- category: Range Check
SELECT claim_id, policy_id, claim_amount
FROM claims
WHERE claim_amount <= 0;

-- RC-04: Negative or zero premium
-- check_id: RC-04
-- name: Negative or zero premium
-- category: Range Check
SELECT policy_id, patient_id, premium_amount
FROM policies
WHERE premium_amount <= 0;


-- =====================
-- ENUM / FORMAT CHECKS
-- =====================

-- EC-01: Invalid gender value
-- check_id: EC-01
-- name: Invalid gender value
-- category: Enum Check
SELECT patient_id, full_name, gender
FROM patients
WHERE gender NOT IN ('M', 'F');

-- EC-02: Invalid smoker flag
-- check_id: EC-02
-- name: Invalid smoker flag
-- category: Enum Check
SELECT patient_id, full_name, smoker
FROM patients
WHERE smoker NOT IN ('yes', 'no');

-- EC-03: Invalid claim status
-- check_id: EC-03
-- name: Invalid claim status
-- category: Enum Check
SELECT claim_id, policy_id, claim_status
FROM claims
WHERE claim_status NOT IN ('pending', 'approved', 'rejected');

-- EC-04: Invalid policy type
-- check_id: EC-04
-- name: Invalid policy type
-- category: Enum Check
SELECT policy_id, patient_id, policy_type
FROM policies
WHERE policy_type NOT IN ('basic', 'standard', 'premium');


-- =====================
-- REGEXP CHECKS
-- =====================

-- RX-01: Invalid patient email
-- check_id: RX-01
-- name: Invalid patient email
-- category: REGEXP Check
SELECT patient_id, full_name, email
FROM patients
WHERE email NOT REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$';

-- RX-02: Invalid patient phone
-- check_id: RX-02
-- name: Invalid patient phone
-- category: REGEXP Check
SELECT patient_id, full_name, phone
FROM patients
WHERE phone NOT REGEXP '^[0-9]{10}$';

-- RX-03: Invalid license number
-- check_id: RX-03
-- name: Invalid license number
-- category: REGEXP Check
SELECT provider_id, provider_name, license_no
FROM providers
WHERE license_no NOT REGEXP '^MED-[0-9]{4}$';

-- RX-04: Invalid diagnosis code
-- check_id: RX-04
-- name: Invalid diagnosis code
-- category: REGEXP Check
SELECT claim_id, policy_id, diagnosis_code
FROM claims
WHERE diagnosis_code NOT REGEXP '^[A-Z][0-9]{2}(\\.[0-9]{1,2})?$';


-- =====================
-- DUPLICATE CHECKS
-- =====================

-- DC-01: Duplicate patient records
-- check_id: DC-01
-- name: Duplicate patient records
-- category: Duplicate Check
SELECT full_name, age, gender, COUNT(*) AS dup_count
FROM patients
GROUP BY full_name, age, gender
HAVING COUNT(*) > 1;

-- DC-02: Duplicate claim submissions
-- check_id: DC-02
-- name: Duplicate claim submissions
-- category: Duplicate Check
SELECT policy_id, claim_date, claim_amount, COUNT(*) AS dup_count
FROM claims
GROUP BY policy_id, claim_date, claim_amount
HAVING COUNT(*) > 1;

-- DC-03: Duplicate policy per patient
-- check_id: DC-03
-- name: Duplicate policy per patient
-- category: Duplicate Check
SELECT patient_id, policy_type, COUNT(*) AS dup_count
FROM policies
GROUP BY patient_id, policy_type
HAVING COUNT(*) > 1;


-- =====================
-- DATE LOGIC CHECKS
-- =====================

-- DL-01: Policy end before start
-- check_id: DL-01
-- name: Policy end before start
-- category: Date Check
SELECT policy_id, patient_id, policy_start, policy_end
FROM policies
WHERE policy_end < policy_start;

-- DL-02: Claim before policy start
-- check_id: DL-02
-- name: Claim before policy start
-- category: Date Check
SELECT c.claim_id, c.policy_id, c.claim_date, p.policy_start
FROM claims c
JOIN policies p ON c.policy_id = p.policy_id
WHERE c.claim_date < p.policy_start;

-- DL-03: Claim after policy end
-- check_id: DL-03
-- name: Claim after policy end
-- category: Date Check
SELECT c.claim_id, c.policy_id, c.claim_date, p.policy_end
FROM claims c
JOIN policies p ON c.policy_id = p.policy_id
WHERE c.claim_date > p.policy_end;


-- =====================
-- JOIN-BASED CHECKS
-- =====================

-- JN-01: Claims with no valid policy
-- check_id: JN-01
-- name: Claims with no valid policy
-- category: JOIN Check
SELECT c.claim_id, c.policy_id
FROM claims c
LEFT JOIN policies p ON c.policy_id = p.policy_id
WHERE p.policy_id IS NULL;

-- JN-02: Claims with no valid provider
-- check_id: JN-02
-- name: Claims with no valid provider
-- category: JOIN Check
SELECT c.claim_id, c.provider_id
FROM claims c
LEFT JOIN providers pr ON c.provider_id = pr.provider_id
WHERE pr.provider_id IS NULL;

-- JN-03: Patients with no policy
-- check_id: JN-03
-- name: Patients with no policy
-- category: JOIN Check
SELECT pt.patient_id, pt.full_name
FROM patients pt
LEFT JOIN policies po ON pt.patient_id = po.patient_id
WHERE po.policy_id IS NULL;

-- JN-04: Claim amount exceeds coverage
-- check_id: JN-04
-- name: Claim amount exceeds coverage
-- category: JOIN Check
SELECT c.claim_id, c.claim_amount, p.coverage_amount
FROM claims c
JOIN policies p ON c.policy_id = p.policy_id
WHERE c.claim_amount > p.coverage_amount;


-- JN-05: Claim amount exceeds coverage
-- check_id: JN-05
-- name: Claim amount exceeds coverage
-- category: JOIN Check

SELECT c.claim_id, c.claim_amount, p.coverage_amount
FROM claims c
JOIN policies p ON c.policy_id = p.policy_id
WHERE c.claim_amount > p.coverage_amount;