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

const addBookID = () => {
    // Add copy button to copy book ID if we're on a book page
    // Book detail urls match this regex: https://www.goodreads.com/book/show/(\d+)
    // After the number, there can be a dash or a dot and any other characters, or nothing
    // Before the /book/ there can be a language code, e.g. /en/book/show/12345
    const bookIdRegex = /\/book\/show\/(\d+)[-.]?/
    const bookIdMatch = bookIdRegex.exec(window.location.href)
    if (bookIdMatch) {
        const bookId = bookIdMatch[1]
        const bookTitleElem = document.querySelector('.BookPageTitleSection__title')
        const bookIdElem = document.createElement('span')
        bookIdElem.innerText = "ID: " + bookId
        bookIdElem.style = 'margin-left: 10px; font-size: 0.8em;'
        bookTitleElem.appendChild(bookIdElem)
        const copyButton = document.createElement('button')
        copyButton.innerText = 'Copy'
        copyButton.style = `
            margin-left: 10px;
            font-size: 11px;
            padding: 4px 12px;
            border-radius: 3px;
            border: 1px solid #D6D0C4;
            background-color: #F4F1EA;
            color: #333;
            cursor: pointer;
            line-height: 1;
        `
        copyButton.onclick = () => {
            navigator.clipboard.writeText(bookId)
            copyButton.innerText = 'Copied!'
        }
        bookTitleElem.appendChild(copyButton)
    }
}

setTimeout(addBookLinks, 2500)
setTimeout(addBookID, 2500)
