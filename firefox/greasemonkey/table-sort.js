// ==UserScript==
// @name        Sort tables
// @version     1
// @description Make tables sortable
// @match       *://*/*
// ==/UserScript==

const icons = {
    unsorted: `<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="#000">
        <path d="M15 8H1l7-8zm0 1H1l7 7z" opacity=".2"/>
    </svg>`,
    ascending: `<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="#000">
        <path d="M15 8H1l7-8z"/>
        <path d="M15 9H1l7 7z" opacity=".2"/>
    </svg>`,
    descending: `<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="#000">
        <path d="M15 8H1l7-8z" opacity=".2"/>
        <path d="M15 9H1l7 7z"/>
    </svg>`,
    makeSortable: `<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="#000">
        <path d="M15 8H1l7-8zm0 1H1l7 7z" opacity=".2"/>
        <path d="M15 8H1l7-8z"/>
        <path d="M15 9H1l7 7z" opacity=".2"/>
    </svg>`,
};
 
function getIcon(type) {
    return "data:image/svg+xml;charset=UTF-8," + encodeURIComponent(icons[type]);
}

function sortTable(table, col, reverse) {
    const tbody = table.querySelector("tbody");
    const rows = Array.from(tbody.querySelectorAll("tr"));
    const dir = reverse ? -1 : 1;
    // if the column is numeric, then sort by number, otherwise sort by text
    const sorted = rows.sort(
        (a, b) => dir * (
            isNaN(a.children[col].textContent) || isNaN(b.children[col].textContent) ?
            a.children[col].textContent.localeCompare(b.children[col].textContent) :
            a.children[col].textContent - b.children[col].textContent
        )
    );
    tbody.innerHTML = "";
    tbody.append(...sorted);
}

function handleTableClick(ev) {
    const th = ev.target;
    const table = th.closest("table");
    const dir = th.getAttribute("aria-sort") === "ascending" ? "descending" : "ascending";
    th.setAttribute("aria-sort", dir);
    // Reset all other headers
    table.querySelectorAll("th").forEach(col => {
        if (col !== th) {
            col.setAttribute("aria-sort", "none");
        }
    });
    const col = Array.from(th.parentNode.children).indexOf(th);
    sortTable(table, col, dir === "descending");
}

function makeSortable(table) {
    table.querySelectorAll("th").forEach(th => addEventListener("click", handleTableClick));
    table.classList.add("rixx-sortable-active");
    table.querySelector(".rixx-sortable-button").remove();
}

function handleTable(table) {
    if (table.classList.contains("rixx-sortable")) return;
    // check if the table has more than one row
    if (table.querySelectorAll("tr").length < 2) return;

    // Add a button/icon to turn the table into a sortable table
    const button = document.createElement("button");
    button.classList.add("rixx-sortable-button");
    button.addEventListener("click", () => makeSortable(table));
    table.classList.add("rixx-sortable");
    // prepend the button to the first cell of the first row
    table.querySelector("tr").querySelector("td, th").prepend(button);
}

function findTables() {
    document.querySelectorAll("table").forEach(handleTable);
}

// Start once DOM is ready
document.addEventListener("DOMContentLoaded", () => {
    const style = document.createElement("style");
    style.textContent = `
        table.rixx-sortable-active th {
            cursor: pointer;
            padding-right: 20px;
            background-repeat: no-repeat;
            background-position: right center;
            background-size: 16px 16px;
            background-image: url("${getIcon("unsorted")}");
        }
        table.rixx-sortable-active th[aria-sort="ascending"] {
            background-image: url("${getIcon("ascending")}");
        }
        table.rixx-sortable-active th[aria-sort="descending"] {
            background-image: url("${getIcon("descending")}");
        }
        table.rixx-sortable .rixx-sortable-button {
            width: 20px;
            height: 20px;
            background-image: url("${getIcon("makeSortable")}");
            background-repeat: no-repeat;
            background-color: transparent;
            border: none;
        }
    `
    document.head.appendChild(style);
    findTables();
    // run a second time when the page is fully loaded, hopefully
    setTimeout(findTables, 3000);
});
