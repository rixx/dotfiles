// ==UserScript==
// @name         AO3 Arrow Navigation
// @namespace    https://rixx.de
// @match        https://archiveofourown.org/*
// @version      1.0.0
// @description  Adds arrow key navigation to AO3 works
// @icon         https://archiveofourown.org/images/ao3_logos/logo_42.png
// @grant        none
// @author       Tobias 'rixx' Kunze
// @homepageURL  https://github.com/rixx/dotfiles
// @downloadURL  https://github.com/rixx/dotfiles/raw/refs/heads/master/firefox/userscripts/ao3-arrows.js
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
