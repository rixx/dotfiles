// ==UserScript==
// @name     mastodon-layout
// @include https://chaos.social/*
// @version  1
// @grant    none
// ==/UserScript==

// Mastodon changed its behaviour wrt layouts: If you set the advanced web interface to
// be preferred, the simple one will still be used for incoming links, and there is not
// even a link back to your preferred version.
// https://github.com/mastodon/mastodon/issues/27092

// If the URL path starts with "@", change it to /deck/@…
// This doesn't handle search, hashtags etc, but it usually won't need to, as
// 95% of the problem is following incoming links to posts.

if (window.location.pathname.startsWith("/@")) {
    window.location.pathname = "/deck/" + window.location.pathname.substr(1);
}
