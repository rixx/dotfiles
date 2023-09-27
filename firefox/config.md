# Plugins

- ClearURLs: removes tracking bs from URLs
  https://addons.mozilla.org/en-US/firefox/addon/clearurls/
- Consent-O-Matic: hides cookie banners, by Aarhus University
  Settings: run in private windows
  https://addons.mozilla.org/en-US/firefox/addon/consent-o-matic/
- Django Docs version switcher: remembers last selected docs version and switches there. Great for following old Google
  or StackOverflow links
  https://addons.mozilla.org/en-US/firefox/addon/django-docs-version-switcher/
- FediAct: seamless Fediverse integration with home server
  Settings: NOT muted/blocked, NOT ignore sessions, NOT prompt, everything else on
  https://addons.mozilla.org/en-US/firefox/addon/fediact/
- Greasemonkey: user scripts
  https://addons.mozilla.org/en-US/firefox/addon/greasemonkey/
- Kagi
  Allow in anonymous.
  https://addons.mozilla.org/en-US/firefox/addon/kagi-search-for-firefox/
- PassFF
  Settings: Ctrl-y, Handle HTTP, Enter key fills, Shift-enter is goto, fill, submit, Ctrl-enter is goto fill sumbit in
  new tab, try to auto-fill login forms, do NOT auto submit, exclude feeds.rixx.de/i/, warn about phishing, url field
  names url,http, default password length 32, do not show a status bar, list directories first
  https://addons.mozilla.org/en-US/firefox/addon/passff/
- Reddit Enhancement Suite: makes reddit usable
  Allow in anonymous.
  https://addons.mozilla.org/en-US/firefox/addon/reddit-enhancement-suite/
- Refined GitHub: makes github usable
  Generate token.
  https://addons.mozilla.org/en-US/firefox/addon/refined-github-/
- SponsorBlock: crowdsourced skipper for intros, outtros and sponsorship segments on YouTube
  https://addons.mozilla.org/en-US/firefox/addon/sponsorblock/
- Tree Style Tab: makes firefox usable.
  Config in configs-treestyletab@piro.sakura.ne.jp.json And add styling from treestyletabs.css
  Allow in anonymous.
  https://addons.mozilla.org/en-US/firefox/addon/tree-style-tab/
- uBlacklist: remove domains from Google results.
  https://addons.mozilla.org/en-US/firefox/addon/ublacklist/
  Filters and subscriptions: ublacklist_filters.txt
- uBlock Origin: makes the whole internet usable.
  Extra script: https://github.com/pixeltris/TwitchAdSolutions/blob/master/README.md
  Extra filters: ublock_filters.txt
  Allow in anonymous.
  https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/
- vue.js devtools: makes development usable
  https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/
- Wayback Machine: offers archives on 404 pages, "archive now" button etc
  https://addons.mozilla.org/en-US/firefox/addon/wayback-machine_new/

# Search engines

- [Kagi](https://kagi.com), default
- [Google](https://google.com), keyword `g`
- [Wikipedia](https://en.wikipedia.org), keyword wiki
- [OpenBSD manual](http://man.openbsd.org/), keyword man
- [dict.cc](https://www.dict.cc/), keyword en
- [YouTube](https://youtube.com), keyword y
- [PyPI](https://pypi.org/search/), keyword pypi
- [Amazon](https://amazon.de), keyword ama
- [MDN Web Docs](https://developer.mozilla.org/), keyword mdn
- [DWDS](https://www.dwds.de/), keyword dwds

# about.config

## Display

```
accessibility.typeaheadfind.flashBar 0  # Don't flash the search bar when auto-completing
browser.download.alwaysOpenPanel false  # Don't always open the download panel when downloading a file
browser.download.autohideButton false
browser.download.panel.shown true  # Don't pop out downloads as they are happening
browser.search.widget.inNavBar true
browser.slowStartup.notificationDisabled true
browser.toolbars.bookmarks.visibility never
browser.urlbar.showSearchSuggestionsFirst false
findbar.highlightAll true
full-screen-api.warning.timeout 0  # Remove full-screen warning
layout.css.has-selector.enabled  # required for ublock functioning
reader.content_width 4
security.dialog_enable_delay 100  # Remove most of the delay on showing download prompts
sidebar.position_start false  # sidebar on right side
```


## Tab handling

Tab handling is mostly provided by Tree Style Tab (config in configs-treestyletab@piro.sakura.ne.jp.json). Additional
settings:

```
browser.ctrlTab.sortByRecentlyUsed true
```

These settings are used to make all links open in the current tab, UNLESS they come from external applications:

```
browser.link.open_newwindow 1
browser.link.open_newwindow.override.external 3
browser.link.open_newwindow.restriction 0
```

And finally, we disable tab unloading, because it's hella annoying:

```
browser.tabs.unloadOnLowMemory false
```

## Downloading files

```
browser.download.dir /home/rixx/tmp/downloads
browser.download.viewableInternally.previousHandler.alwaysAskBeforeHandling.svg true
browser.download.viewableInternally.previousHandler.alwaysAskBeforeHandling.xml true
browser.download.viewableInternally.previousHandler.preferredAction.svg 0
browser.download.viewableInternally.previousHandler.preferredAction.xml 0
```

## Security

```
geo.enabled false
geo.wifi.uri
network.IDN_show_punycode true  # helps to spot spoofing attacks
pdfjs.enableScripting false
security.ssl.require_safe_negotiation true
security.ssl3.rsa_des_ede3_sha false
```

## Privacy: Telemetry, bloat and updates

Disable ALL the shit. Wtf.

```
app.update.auto false
beacon.enabled false
browser.discovery.enabled false
browser.newtabpage.activity-stream.feeds.telemetry false
browser.newtabpage.activity-stream.section.highlights.includePocket false
browser.newtabpage.activity-stream.showSearch false
browser.newtabpage.activity-stream.showSponsored false
browser.newtabpage.activity-stream.telemetry false
browser.newtabpage.activity-stream.telemetry.structuredIngestion false
browser.newtabpage.activity-stream.telemetry.structuredIngestion.endpoint
browser.newtabpage.activity-stream.telemetry.ut.events false
browser.ping-centre.telemetry false
datareporting.healthreport.uploadEnabled false
datareporting.policy.dataSubmissionEnabled false
devtools.onboarding.telemetry.logged false
dom.battery.enabled false
dom.security.unexpected_system_load_telemetry_enabled false
extensions.formautofill.creditCards.enabled false
extensions.pocket.enabled false
identity.fxaccounts.enabled false
network.dns.disablePrefetch true
network.predictor.enabled false
network.prefetch-next false
network.trr.confirmation_telemetry_enabled false
privacy.trackingprotection.enabled true
privacy.trackingprotection.origin_telemetry.enabled false
security.app_menu.recordEventTelemetry false
security.certerrors.recordEventTelemetry false
security.identitypopup.recordEventTelemetry false
security.protectionspopup.recordEventTelemetry false
services.sync.prefs.sync.browser.newtabpage.activity-stream.section.highlights.includePocket false
toolkit.telemetry.archive.enabled false
toolkit.telemetry.bhrPing.enabled false
toolkit.telemetry.firstShutdownPing.enabled false
toolkit.telemetry.newProfilePing.enabled false
toolkit.telemetry.pioneer-new-studies-available false
toolkit.telemetry.reportingpolicy.firstRun false
toolkit.telemetry.server
toolkit.telemetry.shutdownPingSender.enabled false
toolkit.telemetry.unified false
toolkit.telemetry.updatePing.enabled false
```

## Development

```
devtools.chrome.enabled true
devtools.command-button-measure.enabled true
devtools.command-button-rulers.enabled true
devtools.debugger.event-listeners-visible true
devtools.debugger.expressions-visible true
devtools.gridinspector.showGridAreas true
devtools.gridinspector.showGridLineNumbers true
devtools.inspector.showAllAnonymousContent true
devtools.inspector.showUserAgentStyles true
devtools.inspector.show_pseudo_elements true
devtools.netmonitor.persistlog true
devtools.whatsnew.enabled true
```
