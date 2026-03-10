// =============================================
// Health Insurance QC Dashboard - Frontend Logic
// =============================================

const API_URL = "http://localhost:5000";

// ---- Fetch & Render ----
async function loadResults() {
    const loading = document.getElementById("loading");
    const grid = document.getElementById("card-grid");

    try {
        const response = await fetch(`${API_URL}/api/results`);
        if (!response.ok) throw new Error(`HTTP ${response.status}`);
        const results = await response.json();

        // Update summary
        updateSummary(results);

        // Clear loading message
        loading.remove();

        // Render cards
        results.forEach((check) => {
            grid.appendChild(createCard(check));
        });

        // Set up tab filtering
        setupTabs(results);
    } catch (err) {
        loading.textContent = `Error loading results: ${err.message}. Make sure the Flask server is running on port 5000.`;
        loading.style.color = "#f44336";
    }
}

// ---- Summary Bar ----
function updateSummary(results) {
    const total = results.length;
    const passed = results.filter((r) => r.status === "PASS").length;
    const failed = results.filter((r) => r.status === "FAIL").length;

    document.getElementById("total-count").textContent = total;
    document.getElementById("pass-count").textContent = passed;
    document.getElementById("fail-count").textContent = failed;

    const overallEl = document.getElementById("overall-status");
    const overallVal = document.getElementById("overall-value");

    if (failed === 0) {
        overallVal.textContent = "PASS";
        overallEl.classList.add("overall-pass");
    } else {
        overallVal.textContent = "FAIL";
        overallEl.classList.add("overall-fail");
    }

    // Update pass rate gauge
    updatePassRate(total, passed);
}

// ---- Pass Rate Gauge ----
function updatePassRate(total, passed) {
    if (total === 0) return;

    const rate = (passed / total) * 100;
    const rounded = Math.round(rate * 10) / 10; // one decimal place

    // Determine colour tier
    let tier, label;
    if (rate < 80)       { tier = "rate-red";    label = "Critical"; }
    else if (rate < 90)  { tier = "rate-orange";  label = "Warning";  }
    else if (rate < 95)  { tier = "rate-yellow";  label = "Good";     }
    else                 { tier = "rate-green";   label = "Excellent"; }

    // Update percentage text
    document.getElementById("gauge-percent").textContent = `${rounded}%`;

    // Animate the SVG ring
    // circumference of r=48 circle ≈ 301.6
    const circumference = 301.6;
    const offset = circumference - (rate / 100) * circumference;
    const ring = document.getElementById("gauge-ring");
    // Apply colour class
    ring.classList.remove("rate-red", "rate-orange", "rate-yellow", "rate-green");
    ring.classList.add(tier);
    // Trigger animation after a short delay (lets the page paint first)
    setTimeout(() => { ring.style.strokeDashoffset = offset; }, 100);

    // Update status label
    const statusEl = document.getElementById("pass-rate-status");
    statusEl.textContent = label;
    statusEl.className = `pass-rate-status ${tier}`;
}

// ---- Card Builder ----
function createCard(check) {
    const card = document.createElement("div");
    const statusClass = check.status.toLowerCase();
    card.className = `qc-card ${statusClass}`;
    card.dataset.category = check.category;

    const idsText =
        check.affected_ids.length > 0
            ? `IDs: ${check.affected_ids.join(", ")}`
            : "";

    card.innerHTML = `
        <div class="card-header">
            <span class="check-id">${check.check_id}</span>
            <span class="badge">${check.status}</span>
        </div>
        <div class="card-body">
            <div class="check-name">${check.name}</div>
            <div class="check-category">Category: ${check.category}</div>
            <div class="affected-count">Affected rows: <strong>${check.count}</strong></div>
            ${idsText ? `<div class="affected-ids">${idsText}</div>` : ""}
        </div>
    `;

    return card;
}

// ---- Tab Filtering ----
function setupTabs() {
    const tabs = document.querySelectorAll(".tab");
    const cards = () => document.querySelectorAll(".qc-card");

    tabs.forEach((tab) => {
        tab.addEventListener("click", () => {
            // Update active tab
            tabs.forEach((t) => t.classList.remove("active"));
            tab.classList.add("active");

            const category = tab.dataset.category;

            // Filter cards
            cards().forEach((card) => {
                if (category === "all" || card.dataset.category === category) {
                    card.style.display = "";
                } else {
                    card.style.display = "none";
                }
            });
        });
    });
}

// ---- Init ----
document.addEventListener("DOMContentLoaded", loadResults);
