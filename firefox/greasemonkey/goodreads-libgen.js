// ==UserScript==
// @name     goodreads-libgen
// @include https://www.goodreads.com/*
// @version  1
// @grant    none
// ==/UserScript==
const libgenUrl = 'https://libgen.is/fiction/?sort=filesize:a&language=English&format=epub&q='

const getUrl = (title, author) => {
    title = title.replace('…', '') + ' ' + author
    title = title.replaceAll(/\(.*\)/g, '')
    title = title.trim()
    return libgenUrl + encodeURIComponent(title);
}

const addDownloadLink = (bookElem) => {
    if (bookElem == null || !bookElem.innerText) {
        return;
    }
    const title = bookElem.innerText;
    const authorElem = document.querySelector(".ContributorLinksList")
    const author = authorElem ? authorElem.innerText : ''
    let link = document.createElement('a');
    link.href =  getUrl(title, author)
    link.innerHTML = " ⬇️"
    bookElem.appendChild(link)
}

const selectors = [
    "h1#bookTitle",
    "div.gr-book__title",
    "div.bookTitle",
    "a.bookTitle",
  	// new book page
    "h1.Text.Text__title1",
    "div.BookCard__title",
];

const addBookLinks = () => {
  selectors.forEach(selector => {
  	document.querySelectorAll(selector).forEach(book => {
    	addDownloadLink(book)
  	})
	})
}

setTimeout(addBookLinks, 2500)
