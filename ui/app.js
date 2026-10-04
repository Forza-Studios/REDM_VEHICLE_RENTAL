let vehicles = [];
let activeCat = "All";
let minutes = 15;
let minMinutes = 1;
let maxMinutes = 120;

const board = document.getElementById("rental-board");
const grid = document.getElementById("vehicle-grid");
const minutesInput = document.getElementById("minutes");
const minutesRange = document.getElementById("minutes-range");
const denied = document.getElementById("denied");

function clampMinutes(v) {
  v = Math.floor(Number(v) || minMinutes);
  return Math.max(minMinutes, Math.min(maxMinutes, v));
}

function totalFor(v) {
  return (Number(v.base) || 0) + (Number(v.perMin) || 0) * minutes;
}

function render() {
  denied.classList.add("hidden");
  grid.innerHTML = "";
  vehicles
    .filter((v) => activeCat === "All" || v.category === activeCat)
    .forEach((v) => {
      const card = document.createElement("div");
      card.className = "vehicle-card";
      card.innerHTML =
        '<span class="veh-cat">' + v.category + '</span>' +
        '<span class="veh-name">' + v.label + '</span>' +
        '<span class="veh-model">' + v.model + '</span>' +
        '<span class="veh-price">Base $' + Number(v.base).toFixed(2) +
        ' + $' + Number(v.perMin).toFixed(2) + '/min</span>' +
        '<span class="veh-total">' + minutes + ' min = $' + totalFor(v).toFixed(2) + '</span>';
      const btn = document.createElement("button");
      btn.className = "rent-btn";
      btn.textContent = "RENT FOR $" + totalFor(v).toFixed(2);
      btn.onclick = () => {
        btn.disabled = true;
        btn.textContent = "PROCESSING...";
        fetch("https://coi_rental/rent", {
          method: "POST",
          headers: { "Content-Type": "application/json; charset=UTF-8" },
          body: JSON.stringify({ model: v.model, minutes: minutes }),
        });
        setTimeout(() => { btn.disabled = false; render(); }, 2500);
      };
      card.appendChild(btn);
      grid.appendChild(card);
    });
}

function syncMinutes(v) {
  minutes = clampMinutes(v);
  minutesInput.value = minutes;
  minutesRange.value = minutes;
  render();
}

minutesInput.addEventListener("change", (e) => syncMinutes(e.target.value));
minutesRange.addEventListener("input", (e) => syncMinutes(e.target.value));
document.querySelectorAll(".quick-btn").forEach((b) => {
  b.addEventListener("click", () => syncMinutes(b.dataset.min));
});
document.querySelectorAll(".filter-btn").forEach((b) => {
  b.addEventListener("click", () => {
    document.querySelectorAll(".filter-btn").forEach((x) => x.classList.remove("active"));
    b.classList.add("active");
    activeCat = b.dataset.cat;
    render();
  });
});

document.getElementById("btn-close").addEventListener("click", () => {
  fetch("https://coi_rental/close", {
    method: "POST",
    headers: { "Content-Type": "application/json; charset=UTF-8" },
    body: JSON.stringify({}),
  });
  board.classList.add("hidden");
});

window.addEventListener("message", (e) => {
  const d = e.data || {};
  if (d.action === "open") {
    vehicles = d.vehicles || [];
    minMinutes = d.minMinutes || 1;
    maxMinutes = d.maxMinutes || 120;
    minutesInput.min = minMinutes;
    minutesInput.max = maxMinutes;
    minutesRange.min = minMinutes;
    minutesRange.max = maxMinutes;
    syncMinutes(d.defaultMinutes || 15);
    board.classList.remove("hidden");
  } else if (d.action === "close" || d.action === "expired") {
    board.classList.add("hidden");
  } else if (d.action === "denied") {
    denied.classList.remove("hidden");
  }
});

document.addEventListener("keydown", (e) => {
  if (e.key === "Escape") {
    fetch("https://coi_rental/close", {
      method: "POST",
      headers: { "Content-Type": "application/json; charset=UTF-8" },
      body: JSON.stringify({}),
    });
    board.classList.add("hidden");
  }
});
