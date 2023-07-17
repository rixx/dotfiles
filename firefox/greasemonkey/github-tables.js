// ==UserScript==
// @name        Sort GitHub tables
// @version     1
// @description Make markdown tables sortable
// @match       https://github.com/*
// @match       https://gist.github.com/*
// ==/UserScript==
// Credit to https://github.com/Mottie/GitHub-userscripts/, whose original script I deleted most of

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
    </svg>`
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

function setup() {
    const hasTable = document.querySelector(".markdown-body table th");
    if (hasTable) {
        // Add sort icons
        const style = document.createElement("style");
        // Add style to page
        document.head.appendChild(style);
        style.textContent = `
            .markdown-body table th {
                cursor: pointer;
                padding-right: 20px;
                background-repeat: no-repeat;
                background-position: right center;
                background-size: 16px 16px;
                background-image: url("${getIcon("unsorted")}");
            }
            .markdown-body table th[aria-sort="ascending"] {
                background-image: url("${getIcon("ascending")}");
            }
            .markdown-body table th[aria-sort="descending"] {
                background-image: url("${getIcon("descending")}");
            }
            `        
        // Add click event to table headers
        document.querySelectorAll(".markdown-body table th").forEach(th => addEventListener("click", handleTableClick));
    }
};

// Start once DOM is ready
document.addEventListener("DOMContentLoaded", () => {
    // We need to wait a bit, for some reason
    setTimeout(setup, 500);
});
