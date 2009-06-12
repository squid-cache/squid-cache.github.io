##master-page:CategoryTemplate
#format wiki
#language en

= Internationalization of Squid =

 * '''Goal''': To make Squid error pages available in many languages.
 * '''Status''': Translations needed.
 * '''Version''': 2.5+ (langpacks), 3.1+ (auto-negotiate, CSS)
 * '''Download''': [[http://www.squid-cache.org/Versions/langpack/]]
 * '''Coordinator''': AmosJeffries. Anyone can contribute translations.

Several people have volunteered their time to check and confirm translations to keep their language(s) updated.

||<-2> '''Language''' || '''Translations verified by:''' ||
|| Bulgarian || bg || Evgeni Gechev ||
|| German || de || Constantin Rack and  Robert Förster ||
|| English || en, en-au, en-gb || AmosJeffries (Squid Project) ||
|| Persian || fa || Mohsen Saeedi (Fedora Project) ||
|| Italian || it || FrancescoChemolli (Squid Project) ||
|| Dutch (Nederland) || nl || Rene Wijninga ||
|| Portuguese (Brazil) || pt-br || Aecio F. Neto ||
|| Swedish || sv || HenrikNordstrom (Squid Project) ||
## || Turkish || tr || Umut Çinar ||
||<|99> Others || ||<|99> '''Unverified''', If you are familiar with any of these or other languages, please volunteer. It is a short spare-time activity taking only a few minutes in the occasional week. Without a moderator we cannot fix any bad language errors. ||
|| Arabic (ar) ||
|| Azerbaijani (az) ||
|| Catalan (ca) ||
|| Czech (cs) ||
|| Danish (da) ||
|| Greek (el) ||
|| Finnish (fi) ||
|| French (fr) ||
|| Spanish (es) ||
|| Estonian (et) ||
|| Armenian (hy) ||
|| Indonesian (id) ||
|| Japanese (ja) ||
|| Latvian (lv) ||
|| Romanian (ro) ||
|| Russian (ru) ||
|| Serbian (sr) ||
|| Turkish (tr) ||
|| Ukrainian (uk) ||
|| Uzbek  (uz) ||
|| Chinese (zh-cn) ||
|| ||


== Why? Squid already has translated error pages ==

Older Squid releases are provided with a fixed set of pre-translated pages which have been gathered from many contributors over a long period. These pages naturally have a mixed set of HTML standards (mostly obsolete or deprecated) and an ever more mixed amount of information available. The format tags (%) for embedding details about the error have not always been kept in the right places, and have changed in various releases.

This project brings all the error pages into an easily maintained structure for translation and future upgrades. The commonly used .PO/.POT translation format has been chosen for the dictionaries due to the wide existing community support and tools. They also allow automated translation from a single set of template files which can be easily updated.

== How can I contribute? ==

=== Suggest a translation fix ===
  How we do translations and who you can join in is detailed at [[Translations/Basics]]

  What you need to know to make useful translations is at [[Translations/Guidelines]]

=== Become a language moderator ===

We really need people familiar enough with each language listed above to verify and approve/reject the general suggestions. Please contact AmosJeffries directly about becoming a moderator.

== How does this affect my installed Squid? ==

Any Squid is able to use the pre-translated [[http://www.squid-cache.org/Versions/langpack/|langpack]] tarballs, but the auto-negotiate and CSS features are not planned for back-porting.

Any existing Squid which have been configured with ''error_directory'' in their squid.conf will not be affected. If you have used this method to provide your own language translations please consider joining the translation effort by submitting your language as outlined above, and then upgrading to the langpack or 3.1 with auto-negotiate.

== What has been done? ==

 * More languages and new page translations
 * HTML 4.01 strict standards compliance
 * Provides error pages matched to visitors own browser language settings.
 * Provides direct control of error page display using CSS.

== So how can I do this upgrade? ==

[[Squid-3.1]] admin just need to follow these steps:

 * Check that your preferred default language is available for auto-translated pages. The ones installed can be seen in your squid error directory as a bunch of folders named after their ISO codes: (en, en-gb, etc.).
 * Add ''error_default_language'' option to squid.conf with the code/folder-name for the language. This will provide a suitable default language if none can be negotiated with the browser.
 * Remove ''error_directory'' from squid.conf
 * Optional: download newest translations and languages [[http://www.squid-cache.org/Versions/langpack/|package]]
 * Make any CSS changes you need to /etc/squid/errorpage.css for display.

Reconfigure or restart squid.

 {i} Languages specified by their full name (ie ''English'') are not able to be auto-negotiated. They are now deprecated and due for removal as soon as ISO coded versions are made available.

=== Now I keep getting: "Unable to load default error language files. Reset to backups." ===

The language code you have entered in squid.conf for ''error_default_language'' does not match any of the currently installed error page translations.

Check that you spelled it correctly, it must match the ISO codes used for one of the sub-directory names in your squid errors directory.

 {i} This only affects the backup language, the one used if the users preferred is not available.

=== What about the custom ERR_MY_PAGE files I made? ===

Yes Squid can still present them. Even while presenting localized copies of the basic error pages.

Your custom templates should for now go into the '''templates/''' directory when using the localization. They will need unique names, so as not to clash with the default pages.

----
CategoryFeature
