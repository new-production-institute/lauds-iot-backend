const API_URL = "http://localhost:9000";

const machineSelect = document.getElementById("machineSelect");
const machineFieldsSection = document.getElementById("machineFieldsSection");
const machineFieldsList = document.getElementById("machineFieldsList");
const electricalFieldsSection = document.getElementById("electricalFieldsSection");
const electricalFieldsList = document.getElementById("electricalFieldsList");
const analyzeBtn = document.getElementById("analyzeBtn");
const correlationResults = document.getElementById("correlationResults");
const timeSelection = document.getElementById("timeSelection");
const startTimeSelect = document.getElementById("startTime");
const stopTimeSelect = document.getElementById("stopTime");

// --- Load machine list ---
async function loadMachines() {
  try {
    const res = await fetch(`${API_URL}/get_machines`);
    const data = await res.json();

    machineSelect.innerHTML = '<option value="">-- Select a machine --</option>';
    data.machines.forEach(machine => {
      const opt = document.createElement("option");
      opt.value = machine;
      opt.textContent = machine;
      machineSelect.appendChild(opt);
    });
  } catch (err) {
    machineSelect.innerHTML = '<option value="">⚠️ Failed to load machines</option>';
    console.error(err);
  }
}

// --- When machine selected ---
machineSelect.addEventListener("change", async (e) => {
  const machine = e.target.value;
  correlationResults.classList.add("hidden");
  if (!machine) {
    machineFieldsSection.classList.add("hidden");
    electricalFieldsSection.classList.add("hidden");
    timeSelection.classList.add("hidden");
    analyzeBtn.classList.add("hidden");
    return;
  }

  try {
    const res = await fetch(`${API_URL}/get_machine_fields?machine_name=${machine}`);
    const data = await res.json();

    // --- Machine parameters ---
    machineFieldsList.innerHTML = "";
    data.fields.forEach(field => {
      const label = document.createElement("label");
      const checkbox = document.createElement("input");
      checkbox.type = "checkbox";
      checkbox.value = field;
      label.appendChild(checkbox);
      label.append(` ${field}`);
      machineFieldsList.appendChild(label);
    });
    machineFieldsSection.classList.remove("hidden");

    // --- Electrical parameters ---
    const electricalFields = ["apower", "current", "voltage"];
    electricalFieldsList.innerHTML = "";
    electricalFields.forEach(field => {
      const label = document.createElement("label");
      const checkbox = document.createElement("input");
      checkbox.type = "checkbox";
      checkbox.value = field;
      label.appendChild(checkbox);
      label.append(` ${field}`);
      electricalFieldsList.appendChild(label);
    });
    electricalFieldsSection.classList.remove("hidden");

    // --- Show time selection and analyze button ---
    timeSelection.classList.remove("hidden");
    analyzeBtn.classList.remove("hidden");

  } catch (err) {
    console.error(err);
    correlationResults.innerHTML = "<p>Error fetching machine parameters.</p>";
  }
});

// --- Analyze Button Click ---
analyzeBtn.addEventListener("click", async () => {
  const machine = machineSelect.value;
  if (!machine) return;

  const machineFields = Array.from(machineFieldsList.querySelectorAll("input:checked")).map(cb => cb.value);
  const electricalFields = Array.from(electricalFieldsList.querySelectorAll("input:checked")).map(cb => cb.value);

  if (machineFields.length === 0 || electricalFields.length === 0) {
    correlationResults.innerHTML = "<p>Please select at least one machine field and one electrical parameter.</p>";
    correlationResults.classList.remove("hidden");
    return;
  }

  const start = startTimeSelect.value;
  const stop = stopTimeSelect.value;

  correlationResults.innerHTML = "<p>Analyzing correlations...</p>";
  correlationResults.classList.remove("hidden");

  const params = new URLSearchParams();
  params.append("machine_device", machine);
  machineFields.forEach(f => params.append("machine_fields", f));
  params.append("energy_device", "SPPS-04");
  electricalFields.forEach(f => params.append("energy_fields", f));
  params.append("start", start);
  params.append("stop", stop);

  try {
    const res = await fetch(`${API_URL}/machine_energy_correlation?${params.toString()}`);

    if (!res.ok) {
      const errData = await res.json();
      correlationResults.innerHTML = `<p>Error fetching correlation data: ${errData.detail || res.statusText}</p>`;
      return;
    }

    const data = await res.json();

    if (!data.correlations || typeof data.correlations !== "object" || Object.keys(data.correlations).length === 0) {
      correlationResults.innerHTML = "<p>No correlation data found.</p>";
      return;
    }

    renderCorrelationTable(data.correlations);

  } catch (err) {
    console.error("Fetch error:", err);
    correlationResults.innerHTML = `<p>Error fetching correlation data: ${err.message}</p>`;
  }
});

// --- Render Correlation Table with Color-coded Cells ---
function renderCorrelationTable(correlations) {
  correlationResults.classList.remove("hidden");

  const machineFields = Object.keys(correlations);
  const electricalFields = Object.keys(correlations[machineFields[0]]);

  let html = `<table class="correlation-table">
    <thead>
      <tr>
        <th>Machine Field</th>`;
  electricalFields.forEach(f => html += `<th>${f}</th>`);
  html += `</tr></thead><tbody>`;

  machineFields.forEach(mField => {
    html += `<tr><td>${mField}</td>`;
    electricalFields.forEach(eField => {
      const value = correlations[mField][eField];
      const displayValue = value !== undefined ? value.toFixed(3) : "-";

      // Color-code based on value
      let bgColor = "#f0f0f0"; // near zero
      if (value > 0) {
        const intensity = Math.floor(255 - value * 128);
        bgColor = `rgb(${intensity}, 255, ${intensity})`; // green shade
      } else if (value < 0) {
        const intensity = Math.floor(255 - Math.abs(value) * 128);
        bgColor = `rgb(255, ${intensity}, ${intensity})`; // red shade
      }

      html += `<td style="background-color:${bgColor}">${displayValue}</td>`;
    });
    html += `</tr>`;
  });

  html += `</tbody></table>`;
  correlationResults.innerHTML = html;
}

// --- Initialize ---
loadMachines();
