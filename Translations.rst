##master-page:CategoryTemplate
#format wiki
#language en

= Internationalization of Squid =

 * '''Goal''': To make Squid error pages available in many languages.
 * '''Status''': Translations needed. Code being tested.
 * '''Version''': 3.1 and later
 * '''Coordinator''': AmosJeffries. Anyone can contribute translations.
 * '''Verified''': Several people have volunteered their time to check and confirm translations to keep their language(s) updated.

|| '''Language''' || '''Translations verified by:''' ||
|| English || AmosJeffries ||
|| German || Constantin Rack and Robert Dessa ||
|| Italian || FrancescoChemolli ||
|| Others || '''Unverified''', If you are familiar with any other language, please volunteer. It does not take very much time. ||


== Why? Squid already has translated error pages ==

Older Squid releases are provided with a fixed set of pre-translated pages which have been gathered from many contributors over a long period. These pages naturally have a mixed set of HTML standards (mostly obsolete or deprecated) and an ever more mixed amount of information available. The format tags (%) for embedding details about the error have not always been kept in the right places, and have changed in various releases.

We are hopping to bring all the error pages into an easily maintained structure for language translation and future upgrades. The commonly used .PO/.POT translation format has been chosen for the dictionaries due to the wide existing community support and tools. They also allow automated translation from a single set of template files which can be easily updated.

== How can I contribute? ==

'''The easy way:'''
 Join the group effort at [[http://translate.treenet.co.nz/projects/squid/]]. Accounts are automatic, fill out the register form, then when you can login select any language and start suggesting translations.

If you are interested in longer contribution we do need people familiar enough with a language to approve/reject differences in suggestions. Please contact AmosJeffries about becoming an admin, or to get new languages added.

There are a few items specific to the squid dictionary which everyone needs to be careful of:

 * HTML tags may surround some words. Please do not alter or remove the tag itself. Moving it about to suit the translation words is fine though.
 * Squid uses codes starting with % to insert certain items. Please leave these in the translated message as they are important for accurate error reporting. I have found that in messages where they mix with text to be translated, the code usually represents a singular noun.


'''Hard(er) way:'''
  To do lone translations, you will need the [[http://translate.sourceforge.net/|Translate Toolkit]], or a good text editor.

You can get the dictionary template in a few ways:
 * Join the group effort at [[http://translate.treenet.co.nz/projects/squid/]]
 * Contact the squid-dev mailing list and ask for a current dictionary template (.POT file).
 * Download the latest [[http://www.squid-cache.org/Versions/v3/HEAD/|Squid-3 HEAD source code]] and grab the '''errors/dictionary.pot''' file.

When you have done the translation submit the resulting .PO file to squid-dev mailing list for approval. We need them with ISO-639 code information to indicate the language, and if possible the country ISO-3166 variant code as well. If you don't know these, an indication of that info may be just as useful (ie american english, or british english, not just english).

How-To's on translating are widely available, so I won't cover those details here.

|| /!\ || The current translation templates assume ISO-8859-1 character set. We will still accept other character translations. But until we get that bug sorted out there may be a short delay in merging. ||


== How does this affect my installed Squid? ==

Squid earlier than 3.1 won't be affected by this just yet. Sorry. I intend to provide pre-translated page sets for drop-in to older Squid, like custom errors. But thats as far as planned on back porting.

Any existing Squid which have been configured with ''error_directory'' in their squid.conf will not be affected. If you have used this method to provide your own language translations please consider joining the translation effort by submitting your language as outlined above, and then upgrading to the auto-language settings.

|| /!\ || Code portion is still awaiting squid-dev final approval for merge. Will be out very, very soon. The rest of the page is currently FYI so you can all see where this is going... ||

When the code portion of this project has merged. Squid 3.1 will have gained the capability not only of providing better translated error pages, but pages matched to visitors own browser language settings. Currently they only see one language from squid.conf, whether they can read it or not.

== So how can I do this upgrade? ==

Squid built with:
{{{
 --enable-auto-locale
}}}

will have the capability of loading any translated templates for the visitors browser. Squid admin just need to follow these steps:

 * Check that your preferred language is available for auto-translated pages. The ones installed can be seen in your squid error directory as a bunch of folders named after their ISO codes: (en, en_US, etc.) .
 * Add ''error_default_language'' option to squid.conf with the code/folder-name for the language. This will provide a suitable default language if none can be negotiated with the browser.
 * Remove ''error_directory'' from squid.conf

Reconfigure or restart squid and Hey presto, its going.

=== Now I keep getting: "Unable to load default language. Reset to 'en' (English)" ===

The language code you have entered in squid.conf for ''error_default_language'' does not match any of the currently installed error page translations.

Check that you spelled it correctly, it must match the ISO code used for one of the directory names in your squid errors directory.

----
CategoryFeature
