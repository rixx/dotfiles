// ==UserScript==
// @name     github-ui
// @include https://github.com/*
// @version  1
// @grant    none
// ==/UserScript==


/* Hide the annoying and useless Action Graph from the results page, and reorder the page.
*/

const fixActionPage = () => {
    // check if we are on an actions page: /:org/:repo/actions/runs/:id
    const path = window.location.pathname.split('/')
    if (path.length < 5 || path[4] !== 'runs') {
        return
    }

    // remove action graph
    document.querySelector("action-graph").style.display = "none"

    /* reorder page: All entries of .PageLayout-region are reordered to:
     * 1. aria-label="Workflow run summary"
     * 2. <job-summaries>
     * 3. aria-label="Annotations"
     * 4. everything else
     */
    const regions = document.querySelectorAll('.PageLayout-region.PageLayout-content > div > *')

    const sortedRegions = Array.from(regions).sort((a, b) => {
        if (a.getAttribute('aria-label') === 'Workflow run summary') {
            return -1
        }
        if (b.getAttribute('aria-label') === 'Workflow run summary') {
            return 1
        }
        if (a.tagName === 'JOB-SUMMARIES') {
            return -1
        }
        if (b.tagName === 'JOB-SUMMARIES') {
            return 1
        }
        if (a.getAttribute('aria-label') === 'Annotations') {
            return -1
        }
        if (b.getAttribute('aria-label') === 'Annotations') {
            return 1
        }
        return 0
    })

    const parentElement = regions[0].parentNode
    sortedRegions.forEach((region) => {
        region.remove()
        parentElement.appendChild(region)
    })
}

// Actions will be run on load and on page navigation
const ACTIONS = [fixActionPage]

/*** SCAFFOLDING CODE ***/
const observeUrlChange = () => {
  // from https://stackoverflow.com/questions/3522090/event-when-window-location-href-changes
  let oldHref = document.location.href;
  const body = document.querySelector("body");
  const observer = new MutationObserver(mutations => {
    if (oldHref !== document.location.href) {
      oldHref = document.location.href;
      for (const action of ACTIONS) {
        // we're running the action with a bit of delay to ensure the page is fully loaded
        setTimeout(action, 500)
      }
    }
  });
  observer.observe(body, { childList: true, subtree: true });
};

window.onload = observeUrlChange;

for (const action of ACTIONS) {
  document.addEventListener('DOMContentLoaded', action)
}

if (document.readyState === 'complete') {
  for (const action of ACTIONS) {
    action()
  }
}
