"""
Health Insurance QC System - Flask Backend
Connects to MySQL, runs validation queries, serves JSON API.
"""

import re
import os
from flask import Flask, jsonify
from flask_cors import CORS
import mysql.connector

app = Flask(__name__)
CORS(app)

# ---- Database Configuration ----

from dotenv import load_dotenv
load_dotenv()

DB_CONFIG = {
    "host": os.getenv("DB_HOST"),
    "user": os.getenv("DB_USER"),
    "password": os.getenv("DB_PASSWORD"),
    "database": os.getenv("DB_NAME")
}

# ---- Parse checks.sql ----
def parse_checks_file():
    """Read checks.sql and extract individual queries with metadata."""
    sql_path = os.path.join(os.path.dirname(__file__), "sql", "checks.sql")
    with open(sql_path, "r", encoding="utf-8") as f:
        content = f.read()

    checks = []
    # Split by the metadata comment blocks
    blocks = re.split(r'(?=-- check_id:)', content)

    for block in blocks:
        # Extract metadata from comments
        check_id_match = re.search(r'-- check_id:\s*(.+)', block)
        name_match = re.search(r'-- name:\s*(.+)', block)
        category_match = re.search(r'-- category:\s*(.+)', block)

        if not check_id_match:
            continue

        # Extract the SQL query (everything after the metadata comments)
        lines = block.strip().split('\n')
        sql_lines = []
        for line in lines:
            stripped = line.strip()
            if stripped.startswith('--'):
                continue
            if stripped:
                sql_lines.append(line)

        query = '\n'.join(sql_lines).strip().rstrip(';')

        if query:
            checks.append({
                "check_id": check_id_match.group(1).strip(),
                "name": name_match.group(1).strip() if name_match else "Unknown",
                "category": category_match.group(1).strip() if category_match else "Unknown",
                "query": query
            })

    return checks


def run_checks():
    """Execute all QC checks and return results."""
    checks = parse_checks_file()
    results = []

    conn = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor(dictionary=True)

    for check in checks:
        try:
            cursor.execute(check["query"])
            rows = cursor.fetchall()

            # Get the first column name to use as the ID column
            id_column = cursor.column_names[0] if cursor.column_names else None

            # Extract affected IDs from the first column
            affected_ids = []
            if id_column and rows:
                for row in rows:
                    val = row[id_column]
                    if val is not None:
                        affected_ids.append(val)

            # Convert any non-serializable types
            clean_ids = []
            for aid in affected_ids:
                if isinstance(aid, (int, float, str)):
                    clean_ids.append(aid)
                else:
                    clean_ids.append(str(aid))

            results.append({
                "check_id": check["check_id"],
                "name": check["name"],
                "category": check["category"],
                "status": "PASS" if len(rows) == 0 else "FAIL",
                "count": len(rows),
                "affected_ids": clean_ids
            })
        except Exception as e:
            results.append({
                "check_id": check["check_id"],
                "name": check["name"],
                "category": check["category"],
                "status": "ERROR",
                "count": 0,
                "affected_ids": [],
                "error": str(e)
            })

    cursor.close()
    conn.close()
    return results


# ---- API Endpoints ----

@app.route("/api/results", methods=["GET"])
def get_results():
    """Return all QC check results as JSON."""
    results = run_checks()
    return jsonify(results)


@app.route("/api/summary", methods=["GET"])
def get_summary():
    """Return pass/fail counts and overall status."""
    results = run_checks()

    total = len(results)
    passed = sum(1 for r in results if r["status"] == "PASS")
    failed = sum(1 for r in results if r["status"] == "FAIL")
    errors = sum(1 for r in results if r["status"] == "ERROR")

    return jsonify({
        "total_checks": total,
        "passed": passed,
        "failed": failed,
        "errors": errors,
        "overall_status": "PASS" if failed == 0 and errors == 0 else "FAIL"
    })


if __name__ == "__main__":
    app.run(debug=True, port=5000)
