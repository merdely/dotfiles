/* override recipe: enable session restore ***/
user_pref("browser.startup.page", 3); // 0102
  // user_pref("browser.privatebrowsing.autostart", false); // 0110 required if you had it set as true
  // user_pref("browser.sessionstore.privacy_level", 0); // 1003 optional to restore cookies/formdata
// user_pref("privacy.clearOnShutdown_v2.historyFormDataAndDownloads", false); // 2811 FF128-135
// user_pref("privacy.clearOnShutdown_v2.browsingHistoryAndDownloads", false); // 2812 FF136+

// optional to match when you use settings>Cookies and Site Data>Clear Data
  // user_pref("privacy.clearSiteData.historyFormDataAndDownloads", false); // 2820 FF128-135
  // user_pref("privacy.clearSiteData.browsingHistoryAndDownloads", false); // 2821 FF136+

// optional to match when you use Ctrl-Shift-Del (settings>History>Custom Settings>Clear History)
  // user_pref("privacy.clearHistory.historyFormDataAndDownloads", false); // 2830 FF128-135
  // user_pref("privacy.clearHistory.browsingHistoryAndDownloads", false); // 2831 FF136+

// Enable ability to add search engines
user_pref("browser.urlbar.update2.engineAliasRefresh", true);

// Do not prompt where to download files
user_pref("browser.download.useDownloadDir", true);

// Load custom stylesheets from chrome directory
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

// Enable compact mode
user_pref("browser.compactmode.show", true);

// Disable pressing alt-key bringing up menu
user_pref("ui.key.menuAccessKeyFocuses", false);

// 5003 disable saving passwords
user_pref("signon.rememberSignons", false);

// 5017: disable Form Autofill
user_pref("extensions.formautofill.addresses.enabled", false);
user_pref("extensions.formautofill.creditCards.enabled", false);

// Send daily usage ping to Mozilla
usage_pref("datareporting.usage.uploadEnabled", false);

