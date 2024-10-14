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

// Add stylesheet to make Mastodon look more bearable, particularly in column layout

const css = `
:root {
  --color-links: #6bc1ff;
  --color-links-button: color-mix(in hsl, var(--color-links), black 30%);
  --color-background: #282c37;
  --color-background-light: #393f4f;
  --color-text-mid: #9baec8;
  --color-text-muted: color-mix(in hsl, var(--color-text-mid), black 30%);
  --color-background-lighter: #4a5266;

  --background-border-color: var(--color-background-light);
}

.layout-multiple-columns .column,
.layout-multiple-columns .drawer {
  flex: 1 1 auto;
}

.about__section:nth-of-type(4),
.about__section:nth-of-type(5),
.compose-form .spoiler-input__border,
.navigation-panel__logo,
.notification-group__actions > .button {
  display: none;
}

.column-header__back-button,
.hashtag-bar a,
.notification-ungrouped--direct .notification-ungrouped__header,
.notification-ungrouped--direct .status__prepend,
.status__content a,
.status__content a.unhandled-link,
.status__wrapper-direct .notification-ungrouped__header,
.status__wrapper-direct .status__prepend,
.timeline-hint a {
  &,
  &:hover {
    color: var(--color-links);
  }
}

.status-card__title {
  font-size: 18px;
  line-height: 22px;
}

.column > .scrollable,
.column-subheading,
#tabs-bar__portal {
  background: var(--color-background);
}

.account__section-headline,
.column .column-header,
.column .notification__filter-bar,
.drawer__header,
.drawer__inner,
.drawer__inner__mastodon {
  background-color: var(--color-background-light);
}

.column .column-header {
  border-bottom: 1px solid var(--color-background-lighter);
  box-shadow: 0 1px 2px rgba(255, 255, 255, 0.07);
}

.account .account__display-name,
.account__section-headline a,
.account__section-headline button,
.character-counter,
.column-header .column-header__back-button,
.column-header__button,
.column-subheading,
.compose-form .dropdown-button
.compose-form .icon-button,
.drawer__tab,
.getting-started__trends h4 a,
.icon-button,
.link-button,
.link-footer p a,
.link-footer p,
.notification-group__main__header__label,
.notification__filter-bar a,
.notification__filter-bar button,
.reply-indicator__content,
.search__input,
.search__popout h4,
.search__popout__menu__item,
.status__prepend a,
.timeline-hint,
.trends__item__name a,
.trends__item__name,
:link {
  color: var(--color-text-mid);
}

.detailed-status__meta a,
.detailed-status__meta,
.notification-group--follow .notification-group__icon,
.notification-group--follow-request .notification-group__icon,
.notification-group__embedded-status .reply-indicator__attachments,
.notification-group__embedded-status__account,
.notification-group__main__additional-content,
.notification-ungrouped__header,
.status__prepend,
.status__relative-time {
  color: var(--color-text-muted);
}

.compose-form__actions .icon-button,
.column-header__button,
.icon-button {
  &:active, &:focus, &:hover {
    color: var(--color-links);
  }
}
.icon-button.star-icon {
  &:active, &:focus, &:hover {
    color: #ca8f04;
  }
}

.content-warning,
.compose-form .spoiler-input .autosuggest-input {
  background-color: var(--color-background);
  border-color: var(--color-background-lighter);
}
.content-warning:after,
.content-warning:before {
  content: unset;
}

.content-warning {
  display: flex;
  flex-direction: row-reverse;
  align-items: flex-start;
  justify-content: flex-end;
  p {
    margin-bottom: 0;
  }
  button span {
    visibility: hidden;
    width: 70px;
    height: 20px;
    display: block;
    overflow: hidden;
    text-align: left;
    &:before {
      content: "▸ Subject:";
      display: block;
      visibility: visible;
    }
  }
}
.compose-form .autosuggest-textarea__textarea,
.compose-form .spoiler-input__input {
  color: #ebeff4;
  font-size: 16px;
}

.button,
.dropdown-button.active,
.privacy-dropdown__option.active,
.privacy-dropdown__option:focus {
  background-color: var(--color-links-button);
  color: white;
  &:hover {
    background-color: color-mix(in hsl, var(--color-links-button), black 10%);
  }
}
.dropdown-button {
  border-color: var(--color-text-mid);
}

.notification-group--unread::before,
.notification-ungrouped--unread::before {
  border-color: var(--color-links-button);
}
.notification-ungrouped {
  padding: 16px;
}

.compose-form__highlightable {
  border: 1px solid var(--color-background-lighter);
}

.reply-indicator {
  border: 1px solid var(--color-background-lighter);
  border-radius: 4px;
  padding: 8px;
}

.account__section-headline a.active::before,
.account__section-headline button.active::before,
.notification__filter-bar a.active::before,
.notification__filter-bar button.active::before {
  background: var(--color-text-mid);
}

.trends__item__sparkline path:first-child {
  fill: var(--color-background-light) !important;
}
.trends__item__sparkline path:last-child {
  stroke: var(--color-text-mid) !important;
}
`

const addStyle = (css) => {
    const style = document.createElement('style');
    style.textContent = css;
    document.head.append(style);
}
addStyle(css);
