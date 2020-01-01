// ==UserScript==
// @name     twitter-paranoia
// @namespace https://twitter.com/rixxtr
// @version  1
// @grant    none
// ==/UserScript==
function hideFollowers () {
  let l = document.querySelector("div.r-ku1wi2:nth-child(2) > div:nth-child(5) > div:nth-child(2) > a:nth-child(1) > span:nth-child(1)");
  if (l) {
    l.style.display = "none";
  } else {
    window.setTimeout(hideFollowers, 100)
  }
}
hideFollowers()
