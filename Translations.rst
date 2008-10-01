##master-page:CategoryTemplate
#format wiki
#language en

= Internationalization of Squid =

 * '''Goal''': To make Squid error pages available in many languages.
 * '''Status''': Translations needed. Code being tested.
 * '''Version''': 2.5+ (langpacks), 3.1+ (auto-negotiate, CSS)
 * '''Download''': [[http://www.squid-cache.org/Versions/langpack/]]
 * '''Coordinator''': AmosJeffries. Anyone can contribute translations.
 * '''Verified''': Several people have volunteered their time to check and confirm translations to keep their language(s) updated.

||<-2> '''Language''' || '''Translations verified by:''' ||
|| German || de || Constantin Rack and  Robert Förster ||
|| English || en, en-au, en-gb || AmosJeffries ||
|| Italian || it || FrancescoChemolli ||
|| Portuguese (Brazil) || pt-br || Aecio F. Neto ||
## || Turkish || tr || Umut Çinar ||
||<|9> Others || ||<|9> '''Unverified''', If you are familiar with any other language, please volunteer. It does not take very much time. ||
|| Catalan (ca) ||
|| Danish (da) ||
|| French (fr) ||
|| Spanish (es) ||
|| Indonesian (id) ||
|| Dutch (nl) ||
|| Swedish (sv) ||
|| Ukrainian (uk) ||

== Why? Squid already has translated error pages ==

Older Squid releases are provided with a fixed set of pre-translated pages which have been gathered from many contributors over a long period. These pages naturally have a mixed set of HTML standards (mostly obsolete or deprecated) and an ever more mixed amount of information available. The format tags (%) for embedding details about the error have not always been kept in the right places, and have changed in various releases.

We are hopping to bring all the error pages into an easily maintained structure for language translation and future upgrades. The commonly used .PO/.POT translation format has been chosen for the dictionaries due to the wide existing community support and tools. They also allow automated translation from a single set of template files which can be easily updated.

== How can I contribute? ==

How we do translations and who you can join in is detailed at [[Translations/Basics]]

What you need to know to make useful translations is at [[Translations/Guidelines]]

If you are able to provide a longer contribution we do need people familiar enough with each language listed above without a current translator to approve/reject differences in suggestions. Please contact AmosJeffries about becoming a moderator, or to get new languages added.

== How does this affect my installed Squid? ==

Any Squid is able to use the pre-translated [[http://www.squid-cache.org/Versions/langpack/|langpack]] tarballs, but the auto-negotiate and CSS features are not planned for back-porting.

Any existing Squid which have been configured with ''error_directory'' in their squid.conf will not be affected. If you have used this method to provide your own language translations please consider joining the translation effort by submitting your language as outlined above, and then upgrading to the langpack or 3.1 with auto-negotiate.

Squid 3.1 has the capability not only of providing better translated error pages, but pages matched to visitors own browser language settings. Currently they only see one language defined in squid.conf, whether they can read it or not.

 {i} Coming soon: CSS control over negotiated error page display.

== So how can I do this upgrade? ==

Squid 3.1+ built with:
{{{
 --enable-auto-locale
}}}

have the capability of loading any translated templates for the visitors browser. Squid admin just need to follow these steps:

 * Check that your preferred language is available for auto-translated pages. The ones installed can be seen in your squid error directory as a bunch of folders named after their ISO codes: (en, en-gb, etc.).
 * Add ''error_default_language'' option to squid.conf with the code/folder-name for the language. This will provide a suitable default language if none can be negotiated with the browser.
 * Remove ''error_directory'' from squid.conf
 * Optional: download newest translations and languages [[http://www.squid-cache.org/Versions/langpack/|package]]

Reconfigure or restart squid.

 {i} Languages specified by their full name (ie ''English'') are not able to be auto-negotiated. They are now deprecated and due for removal as soon as ISO coded versions are made available.

=== Now I keep getting: "Unable to load default error language files. Reset to backups." ===

The language code you have entered in squid.conf for ''error_default_language'' does not match any of the currently installed error page translations.

Check that you spelled it correctly, it must match the ISO codes used for one of the directory names in your squid errors directory.

 {i} This only affects the backup language, if the users preferred is not available.

----
CategoryFeature
