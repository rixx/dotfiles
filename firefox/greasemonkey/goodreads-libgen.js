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

const addDownloadLink = (bookElem, titleSelector, authorSelector) => {
    if (bookElem == null || !bookElem.innerText) {
        return;
    }
    const bookTitleElem = bookElem.querySelector(titleSelector)
    const title = bookTitleElem ? bookTitleElem.innerText : ''
    const authorElem = bookElem.querySelector(authorSelector)
    const author = authorElem ? authorElem.innerText : ''
    let link = document.createElement('a');
    link.href =  getUrl(title, author)
    link.innerHTML = " ⬇️"
    bookTitleElem.appendChild(link)
}

const selectors = [
    // main book page
    {selector: ".BookPage__mainContent", title: "h1", author: ".ContributorLinksList" },
    // series list page
    {selector: ".responsiveBook", title: "a.gr-h3", author: "[itemtype='http://schema.org/Person']" },
    // search results page, author page
    {selector: "tr[itemtype='http://schema.org/Book']", title: "a.bookTitle", author: "[itemtype='http://schema.org/Person']" },
];

const addBookLinks = () => {
    // add download links to all books on the page
    selectors.forEach(selector => {
        document.querySelectorAll(selector.selector).forEach(book => {
            addDownloadLink(book, selector.title, selector.author)
        })
    })
}

setTimeout(addBookLinks, 2500)
