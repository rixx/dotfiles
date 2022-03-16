// ==UserScript==
// @name     twitter-nitter-link
// @include https://twitter.com/*
// @version  1
// @grant    none
// ==/UserScript==

function updateLink () {
  const element = document.querySelector("a[href='/home']")
  if (element) {
    console.log("WHEEEE FOUND IT")
    console.log(element)
    const url = "https://nitter.net" + window.location.pathname
    const newElement = element.cloneNode(true)  // gets rid of sneaky event listeners
    newElement.href = url
    element.parentNode.replaceChild(newElement, element)
  } else {
    window.setTimeout(updateLink, 100)
  }
}
updateLink()
