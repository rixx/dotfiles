// ==UserScript==
// @name     Sort pollunit lists
// @version  1
// @grant    none
// @namespace https://pollunit.com/
// @include https://pollunit.com/polls/*
// ==/UserScript==

function sortByDots() {
  	const parent = document.querySelector("#pollList")
    Array.from(document.querySelectorAll("#pollList .box")).sort((a, b) => {
      const aNum = parseInt(a.querySelector(".iconBox.rating span").textContent)
      const bNum = parseInt(b.querySelector(".iconBox.rating span").textContent)
      if (aNum < bNum) return 1
      if (aNum > bNum) return -1
      return 0
    }).forEach(e => parent.appendChild(e))
    
}


const button = document.createElement("div");
button.id = "sortButton"
button.textContent = "Sort by dots"
button.classList = "iconBox iconBox-truncate"
document.querySelector("#subHeader .centered-content").appendChild(button)
button.addEventListener("click", sortByDots)
