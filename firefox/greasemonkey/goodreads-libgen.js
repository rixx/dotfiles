// ==UserScript==
// @name     goodreads-libgen
// @include https://www.goodreads.com/*
// @version  1
// @grant    none
// ==/UserScript==
const libgenUrl = 'https://libgen.is/fiction/?q='

const getUrl = (title) => {
    title = title.replace('…', '')
    title = title.replaceAll(/\(.*\)/g, '')
    title = title.trim()
    return encodeURI(libgenUrl + encodeURIComponent(title));
}

const addDownloadLink = (bookElem) => {
    if (bookElem == null || !bookElem.innerText) {
        return;
    }
    const title = bookElem.innerText;
    let link = document.createElement('a');
    link.href =  getUrl(title)
    link.innerHTML = "⬇️"
    bookElem.appendChild(link)
}

const selectors = [
    "h1#bookTitle",
    "div.gr-book__title",
    "div.bookTitle",
    "a.bookTitle",
];

selectors.forEach(selector => {
  document.querySelectorAll(selector).forEach(book => {
    addDownloadLink(book)
  })
})
