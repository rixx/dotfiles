// ==UserScript==
// @name     man-page-toc
// @include https://man.openbsd.org/*
// @version  1
// @grant    none
// ==/UserScript==
function buildContents () {
  let headings = document.querySelectorAll(".manual-text h1")
  let htmlList = document.createElement("ol")
  headings.forEach(heading => {
    let entry = document.createElement("li")
    let link = document.createElement("a")
    link.classList = ["permalink"]
    link.href = "#" + heading.id
    link.appendChild(document.createTextNode(heading.querySelector("a").innerHTML))
    entry.appendChild(link)
    htmlList.appendChild(entry)
  })
  
  let contentsTitle = document.createElement("h1")
  contentsTitle.appendChild(document.createTextNode("TABLE OF CONTENTS"))
  
  let parent = document.querySelector("hr").parentElement
  parent.insertBefore(htmlList, document.querySelector("hr"))
  parent.insertBefore(document.createElement("hr"), htmlList)
  parent.insertBefore(contentsTitle, htmlList)
}
buildContents()
