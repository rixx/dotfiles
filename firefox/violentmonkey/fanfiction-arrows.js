// ==UserScript==
// @name     fanfiction-arrows
// @include https://www.fanfiction.net/*
// @include https://fanfiction.net/*
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
        document.querySelector('.lc-wrapper + span button:last-of-type').click()
    }
    if (event.key === 'ArrowLeft') {
        document.querySelector('.lc-wrapper + span button:first-of-type').click()
    }
})

document.querySelector("#storytext").style.maxWidth = "60em"
