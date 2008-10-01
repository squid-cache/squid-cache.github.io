##master-page:KnowledgeBaseTemplate
##Page-Creation-Date:2008-10-01
##Page-Original-Author:Amos Jeffries
#format wiki
#language en

<<TableOfContents>>

= Contributing to Squid Translations =

We use the Pootle Toolkit to manage the Squid translations.
Being an open-source project we have public access, but in order to protect our users against abuse we also have a layer of moderation between the general public and the official translation releases.

It can be a little hard to grasp whats happening so this page covers how the system works for people and how Squid project makes use of it.

== Basic Overview ==

To ensure good quality results there is a short process you need to be aware of.

 1. People register and '''suggest''' new text. This gets stored until someone with the right knowledge can identify whether its right or not.

 1. When an new piece of text is checked it may be discarded as wrong or saved as a translation for everyone to see. From this point it's in the Squid Code.

 1. At some point not too long after all current translations are bundled up and committed to the official packages for distribution.

Further details about these steps are covered below. Along with hints and examples of the tools used.

 (!) Each of the steps above is done manually by a member of the Squid Project. So things like timing are variable.

 (!) (!) links if provided below in the instructions can be used as shortcuts.


=== Registration ===

Registration is free and only involves providing a Name and contact email address.

We do this mainly so we can acknowledge your contribution in the official TRANSLATORS credits. It also helps to prevent drive-by spamming of the public web tools.

If you don't want to be acknowledged, thats fine, just let the translation maintainer know. That is presently AmosJeffries

 ''' How-To '''
 * Visit http://translate.treenet.co.nz/register.html


=== Public Suggestions ===

Being open source we want anybody to contribute. Once you have registered, choose the language(s) you know and want to help with.

 ''' How-To '''
 * [[http://translate.treenet.co.nz/login.html|Log in]]
 * Visit the '''My account''' page.
 * Click on '''[[http://translate.treenet.co.nz/home/options.html|Change Options]]'''
 * Make sure the '''Squid 3''' project is highlighted under '''My Projects'''.
 * Highlight any languages you want to help with in the '''My Languages''' box.
 * Click '''Save changes''' button at the bottom of the page.


Now you can send in a suggestion to add or correct translations.

 ''' How-To '''
 * [[http://translate.treenet.co.nz/login.html|Log in]] (if you haven't already)
 * Visit http://translation.treenet.co.nz/project/squid/
 * Click on the name of your language.
 * Click on '''Show Editing Functions''' just under the language name.
 * Click on '''View Untranslated''' which comes up in the '''dark grey box'''
 * You may want to make a shortcut of the page here so you can come back easily.

At this point you can see whats there. You are normally taken straight to the first missing text. But you can also send in alterations:

 * Locate the text entry to be fixed.
 * Hold the mouse over the text and wait.
 * Click on the little '''Edit''' link which appear to one side.

But don't expect any suggestions to be included in the sources or even visible until its been checked. All you have done at this point is add a new piece of text to the list of things to be processed.

See [[../Guidelines|Translation Guidelines]] for what sort of things are needed to get your suggestion accepted.

 (!) Special characters which standard PC keyboards may not provide easily are listed. Leaving the mouse cursor in the text box, and clicking on a character adds it to the text.

 (!) If you are not fully certain you got the text right. Clicking the fuzzy checkbox can help the translator know they need to double-check it.


=== Translators ===

Some wonderful people have been willing to go further than just sending us suggestions. They have agreed to spend a few minutes a week checking a bunch of those suggestions.

 (!) Only the languages listed as [[../../Translations|verified]] are checked. All the other suggestions just pile up waiting for someone who can do the job.

==== Weekly Notices ====

Once a week each languages is checked for missing text, new suggestions, and a few other things. The results of these checks are counted up and a summary TODO list is sent to the language translator.

 {i} If there is no translator the list gets sent to the Squid project team as a digest. We usually don't know the languages so it's only an indication of where we need to track down new helpers from.

The translators then have a week to check the things on that list or they get another.


==== Suggestion Checks ====

New suggestions are likely to come in at some point. They need to be checked 

 ''' How-To '''
 * [[http://translate.treenet.co.nz/login.html|Log in]] (if you haven't already)
 * Visit http://translation.treenet.co.nz/project/squid/
 * Click on the name of your language.
 * Click on '''Show Editing Functions''' just under the language name.
 * Click on '''View Suggestions''' which comes up.

Each phrase with suggestions will come up with all current details about that text. Changes from existing translation are highlighted to quickly see what the issue is.

Each is listed with two buttons:
 * Click on '''accept''' to replace existing translation with the suggested one.
 * Click on '''reject''' to remove the suggestion.


==== Adding New Translations ====

Translators are also encouraged to make sure there are no untranslated entries in the language.

The '''Editing Functions''' also contains a link to '''Show Untranslated'''.

This provides a form same as the public suggestions. But since the translators are expected to know what they are writing. Allows direct entry of new text straight into the system.


=== Translation Project Maintenance ===

Supporting the translators is the translation maintainer. Presently AmosJeffries.

Like any software package maintenance position this position has a few tasks:
 * Finding new translators for languages which need one.
 * Checking the special codes and markup needed by Squid are not changed or dropped in translation.
 * Committing the changes to Squid-3 HEAD for public release in the [[http://www.squid-cache.org/Versions/langpack/|Language Package]].
 * Contact point about any issues or changes to the system.

----
CategoryKnowledgeBase
