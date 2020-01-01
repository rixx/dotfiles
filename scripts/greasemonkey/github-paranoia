// ==UserScript==
// @name     github-paranoia
// @namespace https://github.com/rixx
// @version  1
// @grant    none
// ==/UserScript==
function hideTimeline () {
  let l = document.querySelector(".js-yearly-contributions")
  if (l) {
    l.style.display = "none";
  } else {
    window.setTimeout(hideTimeline, 100)
  }
}
hideTimeline()
