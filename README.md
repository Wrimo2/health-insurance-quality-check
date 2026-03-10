# Health Insurance Data Quality Control System

A full-stack Data Quality Control (QC) system for a health insurance database. Detects, reports, and visualizes data anomalies across four related MySQL tables using SQL validation queries, a Python Flask API, and a browser-based dashboard.

## Tech Stack

| Layer | Technology | Role |
|-------|-----------|------|
| Database | MySQL 8.0 | Store data, run validation queries |
| Backend | Python 3.12.3 + Flask | Connect to DB, run checks, serve JSON API |
| Frontend | HTML + CSS + JavaScript | Fetch API results, render QC dashboard |
| Connector | mysql-connector-python | Python-to-MySQL bridge |

## Project Structure

```
health-insurance-qc/
│
├── sql/
│   ├── schema.sql          # CREATE TABLE statements + FK constraints
│   ├── seed.sql            # INSERT rows with intentional dirty data
│   └── checks.sql          # 26 QC validation queries
│
├── app.py                  # Flask app: runs queries, serves /api/results
│
└── dashboard/
    ├── index.html           # QC dashboard UI
    ├── style.css            # Styling for report cards
    └── script.js            # interactivity + Fetch API + render results
```

## System Architecture

```
[ MySQL Database ]  →  [ Python Flask API ]  →  [ HTML Dashboard ]
   schema.sql              app.py                 index.html
   seed.sql            runs checks.sql            script.js
   checks.sql          returns JSON               renders cards
```

### Database Relationships

```
patients (patient_id PK)
    │  1-to-many
    ↓
policies (policy_id PK, patient_id FK)
    │  1-to-many
    ↓
claims (claim_id PK, policy_id FK, provider_id FK)
    ↑  many-to-1
providers (provider_id PK)
```

## Database Schema

### patients
| Column | Type | Notes |
|--------|------|-------|
| patient_id | INT | PRIMARY KEY, AUTO_INCREMENT |
| full_name | VARCHAR(100) | NOT NULL |
| age | INT | Range: 0-120 |
| gender | VARCHAR(10) | Enum: M / F |
| bmi | DECIMAL(5,2) | Range: 10.0-60.0 |
| smoker | VARCHAR(5) | Enum: yes / no |
| region | VARCHAR(50) | north/south/east/west |
| email | VARCHAR(100) | REGEXP validated |
| phone | VARCHAR(20) | 10-digit number |
| created_at | DATE | Date logic check |

### providers
| Column | Type | Notes |
|--------|------|-------|
| provider_id | INT | PRIMARY KEY, AUTO_INCREMENT |
| provider_name | VARCHAR(100) | NOT NULL |
| provider_type | VARCHAR(50) | hospital / clinic / specialist |
| region | VARCHAR(50) | Should match patient region |
| license_no | VARCHAR(30) | Format: MED-XXXX |
| contact_email | VARCHAR(100) | REGEXP validated |

### policies
| Column | Type | Notes |
|--------|------|-------|
| policy_id | INT | PRIMARY KEY, AUTO_INCREMENT |
| patient_id | INT | FK to patients |
| policy_type | VARCHAR(50) | basic / standard / premium |
| premium_amount | DECIMAL(10,2) | Must be > 0 |
| coverage_amount | DECIMAL(10,2) | Must be > 0 |
| policy_start | DATE | Start date |
| policy_end | DATE | Must be after policy_start |
| status | VARCHAR(20) | active / expired / cancelled |

### claims
| Column | Type | Notes |
|--------|------|-------|
| claim_id | INT | PRIMARY KEY, AUTO_INCREMENT |
| policy_id | INT | FK to policies |
| provider_id | INT | FK to providers |
| claim_date | DATE | Must be within policy dates |
| claim_amount | DECIMAL(10,2) | Must be > 0 |
| diagnosis_code | VARCHAR(20) | ICD format |
| claim_status | VARCHAR(20) | pending / approved / rejected |
| notes | TEXT | Optional |

## QC Validation Queries

The system runs **22+ validation queries** organized into 7 categories. A query returning 0 rows = **PASS**. Any rows returned = **FAIL**.

| Category | Checks | Examples |
|----------|--------|----------|
| **Null Checks** | 4 | Null age, null claim amount, null policy dates, null provider name |
| **Range Checks** | 4 | Invalid age (< 0 or > 120), invalid BMI, negative claims/premiums |
| **Enum/Format** | 4 | Invalid gender, smoker flag, claim status, policy type |
| **REGEXP** | 4 | Invalid email, phone, license number, diagnosis code |
| **Duplicate** | 3 | Duplicate patients, claims, policies per patient |
| **Date Logic** | 3 | Policy end before start, claim outside policy dates |
| **JOIN-Based** | 4 | Orphan claims, patients with no policy, claim exceeding coverage |

## Intentional Dirty Data

The `seed.sql` file injects anomalies such as:

- NULL critical fields (age, names)
- Out-of-range values (age = -5, BMI = 999)
- Invalid formats (email = `john@`, phone = `12345`)
- Duplicate records
- Negative amounts (premium = -500)
- Date conflicts (policy end before start)
- Orphan foreign keys (policy_id = 9999)
- Invalid enum values (gender = `male`, status = `pending`)

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/results` | Returns all QC check results as JSON array |
| GET | `/api/summary` | Returns pass/fail counts and overall status |

### Response Format

```json
{
  "check_id": "NC-01",
  "name": "Null patient age",
  "category": "Null Check",
  "status": "FAIL",
  "count": 2,
  "affected_ids": [7, 19]
}
```

## Dashboard

The HTML dashboard displays:

- **Header** — Total checks, PASS count, FAIL count
- **Filter tabs** — All | Null | Range | REGEXP | JOIN | Date
- **QC Cards** — One card per check showing ID, name, category, affected row count, and row IDs
  - Green = PASS, Red = FAIL

## Setup & Run

### 1. Create the MySQL Database

```sql
mysql -u root -p
CREATE DATABASE health_insurance_qc;
USE health_insurance_qc;
source sql/schema.sql;
source sql/seed.sql;
```

### 2. Update DB Credentials in `app.py`

```python
DB_CONFIG = {
    "host": "localhost",
    "user": "root",
    "password": "your_password",
    "database": "health_insurance_qc"
}
```

### 3. Install Python Dependencies

```bash
pip install flask flask-cors mysql-connector-python
```

### 4. Run the Flask Server

```bash
python app.py
# Server starts at http://localhost:5000
```

### 5. Open the Dashboard

Open `dashboard/index.html` in your browser. The page automatically calls the Flask API and renders all QC results.


