// ==UserScript==
// @name     twitter-nitter-link
// @include https://twitter.com/*
// @version  1
// @grant    none
// ==/UserScript==

function copyLink () {
  const text = document.querySelector("#nitter").href

  const textArea = document.createElement("textarea");
  textArea.style.position = 'fixed';
  textArea.style.top = 0;
  textArea.style.left = 0;
  textArea.style.width = '2em';
  textArea.style.height = '2em';
  textArea.style.padding = 0;
  textArea.style.border = 'none';
  textArea.style.outline = 'none';
  textArea.style.boxShadow = 'none';
  textArea.style.background = 'transparent';
  textArea.value = text;
  document.body.appendChild(textArea);
  textArea.focus();
  textArea.select();

  try {
    var successful = document.execCommand('copy');
    var msg = successful ? 'successful' : 'unsuccessful';
    console.log('Copying text command was ' + msg);
  } catch (err) {
    console.log('Oops, unable to copy');
  }
  document.body.removeChild(textArea);
}

function updateLink () {
  let nitterLink = document.querySelector("#nitter")

  if (!nitterLink) {
    // We create our links
    const element = document.querySelector("a[href='/home']")
    if (!element) {
      window.setTimeout(updateLink, 100)
      return
    }
    nitterLink = element.cloneNode(true)  // gets rid of sneaky event listeners
    nitterLink.id = "nitter"
    element.parentNode.appendChild(nitterLink)

    nitterLink.parentElement.style.display = "flex"
    nitterLink.parentElement.style.flexDirection = "row"

    nitterCopy = element.querySelector("div").cloneNode(true)  // No need to use a link here
    nitterCopy.querySelector("svg").style.color = "grey"
    nitterCopy.id = "nitter-copy"
    element.parentNode.appendChild(nitterCopy)
    nitterCopy.addEventListener("click", copyLink)

    element.parentNode.removeChild(element)
  }

  nitterLink.href = "https://nitter.net" + window.location.pathname
}
function delayedUpdateLink () {
  window.setTimeout(updateLink, 400)
}

updateLink()
document.addEventListener("click", delayedUpdateLink)
