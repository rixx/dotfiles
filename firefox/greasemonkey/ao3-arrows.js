// ==UserScript==
// @name     ao3-arrows
// @include https://archiveofourown.org/*
// @version  1
// @grant    none
// ==/UserScript==

// Add global keybinds for arrow-right and arrow-left

document.addEventListener('keydown', (event) => {
    if (event.key === 'ArrowRight') {
        document.querySelector('li.chapter.next a').click()
    }
    if (event.key === 'ArrowLeft') {
        document.querySelector('li.chapter.previous a').click()
    }
})
