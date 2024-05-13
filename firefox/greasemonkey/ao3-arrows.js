// ==UserScript==
// @name     ao3-arrows
// @include https://archiveofourown.org/*
// @version  1
// @grant    none
// ==/UserScript==

// Add global keybinds for arrow-right and arrow-left

document.addEventListener('keydown', (event) => {
    // Only trigger if the user is not typing in a text box or text area or pressing a modifier key
    if (event.target.tagName === 'INPUT' || event.target.tagName === 'TEXTAREA' || event.ctrlKey || event.altKey || event.metaKey || event.shiftKey) {
        return
    }
    if (event.key === 'ArrowRight') {
        document.querySelector('li.chapter.next a').click()
    }
    if (event.key === 'ArrowLeft') {
        document.querySelector('li.chapter.previous a').click()
    }
})

document.querySelector("#workskin").style.maxWidth = "64em"
