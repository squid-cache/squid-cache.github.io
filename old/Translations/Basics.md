# Contributing to Squid Translations

We use the Pootle Toolkit to manage the Squid translations. Being an
open-source project we have public access, but in order to protect our
users against abuse we also have a layer of moderation between the
general public and the official translation releases.

It can be a little hard to grasp whats happening so this page covers how
the system works for people and how Squid project makes use of it.

## Basic Overview

To ensure good quality results there is a short process you need to be
aware of.

1.  People register and **suggest** new text. This gets stored until
    someone with the right knowledge can identify whether its right or
    not.
    
      - ℹ️
        if you find you want to do more than suggest we are always
        looking for moderators.

2.  When an new piece of text is checked it may be discarded as wrong or
    saved as a translation for everyone to see.

3.  At some point not too long after saving all current translations are
    bundled up and committed to the official packages for distribution.

Further details about these steps are covered below. Along with hints
and examples of the tools used.

  - ![(\!)](https://wiki.squid-cache.org/wiki/squidtheme/img/idea.png)
    Step \#2 above is done manually by a volunteer translator for the
    Squid Project. So things like timing are variable.

  - ![(\!)](https://wiki.squid-cache.org/wiki/squidtheme/img/idea.png)
    links if provided below in the instructions can be used as
    shortcuts.

### Registration

Registration is free and only involves providing a Name and contact
email address.

We do this mainly so we can acknowledge your contribution in the
official TRANSLATORS credits. It also helps to prevent drive-by spamming
of the public web tools.

If you don't want to be acknowledged, thats fine, just let the
translation maintainer know. That is presently
[AmosJeffries](/AmosJeffries)

  - **How-To**

  - Visit [](http://translate.squid-cache.org/accounts/register/)

### Public Suggestions

Being open source we want anybody to contribute. Once you have
registered, choose the language(s) you know and want to help with.

  - **How-To**

  - [Log in](http://translate.squid-cache.org/accounts/login/)

  - Click on your name in the top right-hand corner of the page

  - Click on
    **[Settings](http://translate.squid-cache.org/accounts/edit/)** tab

  - Click **Save changes** button at the bottom of the page.

Now you can send in a suggestion for missing translations.

  - **How-To**

  - [Log in](http://translate.squid-cache.org/accounts/login/) (if you
    haven't already)

  - Visit [](http://translate.squid-cache.org/projects/squid/)

  - Either, Click on the link saying how many words are untranslated.

At this point you can see whats there. You are normally taken straight
to the first missing text.

You can also send in alterations to existing texts.

  - **How-To**

  - [Log in](http://translate.squid-cache.org/accounts/login/) (if you
    haven't already)

  - Visit [](http://translate.squid-cache.org/projects/squid/)

  - Click on the name of your language.

  - Click on the **Translate** tab.

  - Click on **Translate All** which comes up.

  - You may want to make a shortcut of the page here so you can come
    back easily.

At this point you can see whats there. You are normally taken straight
to the first text.

  - Navigate around the using the **Next** and **Previous** links to
    move up or down the list of translation texts.

  - Click on the number in the first column to select an entry for
    editing.

Don't expect any suggestions to be included in the sources or even
visible until its been checked. All you have done at this point is add a
new piece of text to the list of things to be processed into Squid.

See [Translation
Guidelines](/Translations/Guidelines)
for what sort of things are needed to get your suggestion accepted.

  - ![(\!)](https://wiki.squid-cache.org/wiki/squidtheme/img/idea.png)
    Special characters which standard PC keyboards may not provide
    easily are listed. Leaving the mouse cursor in the text box, and
    clicking on a character adds it to the text.

  - ![(\!)](https://wiki.squid-cache.org/wiki/squidtheme/img/idea.png)
    If you are not fully certain you got the text right. Clicking the
    fuzzy checkbox can help the language moderator know they need to
    double-check it.

### Translators

Some wonderful people have been willing to go further than just sending
us suggestions. They have agreed to spend a few minutes a week checking
a bunch of those suggestions.

  - ![(\!)](https://wiki.squid-cache.org/wiki/squidtheme/img/idea.png)
    Only the languages listed as
    [verified](/Translations)
    are checked. All the other suggestions just pile up waiting for
    someone who can do the job.

#### Weekly Notices

  - ![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png)
    This feature is on hold for now.

Once a week each language is checked for missing text, new suggestions,
and a few other things. The results of these checks are counted up and a
summary TODO list is sent to the language translator.

The translators then have a week to check the things on that list before
they get another reminder TODO summary.

The notice emails contain helpful links which go direct to the page
where the needed task can be completed. Saving much time locating things
in the maze of job links.

  - ℹ️
    If there is no translator the list gets sent to the Squid project
    team as a digest. We usually don't know the language so it's only an
    indication of where we need to track down new helpers from.

#### Suggestion Checks

New suggestions are likely to come in at some point. They need to be
checked

  - **How-To**

  - [Log in](http://translate.squid-cache.org/accounts/login/) (if you
    haven't already)

  - Visit [](http://translate.squid-cache.org/projects/squid/)

  - Click on the name of your language.

  - Click on the **Translate** tab.

  - Click on **Review Suggestions** which comes up.

Each phrase with suggestions will come up with all current details about
that text. Changes from existing translation are highlighted to quickly
see what the issue is.

Each is listed with two buttons:

  - Click on **green
    ![(./)](https://wiki.squid-cache.org/wiki/squidtheme/img/checkmark.png)**
    (accept) to replace existing translation with the suggested one.

  - Click on **red X** (reject) to remove the suggestion.

#### Adding New Translations

Translators are also encouraged to make sure there are no untranslated
entries in the language.

The **Translate** tab also contains a link to **Show Untranslated**.

This provides a form same as the public suggestions. But since the
translators are expected to know what they are writing. Allows direct
entry of new text straight into the system.

### Translation Project Maintenance

Supporting the translators is the translation maintainer. Presently
[AmosJeffries](/AmosJeffries).

Like any software package maintenance position this position has a few
tasks:

  - Finding new translators for languages which need one.

<!-- end list -->

  - Contact point about any issues or changes to the system.

<!-- end list -->

  - [CategoryKnowledgeBase](/CategoryKnowledgeBase)
