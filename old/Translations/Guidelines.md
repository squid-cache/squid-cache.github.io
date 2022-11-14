# Guidelines for Translating Squid

How to use the translation tools is covered in
[Translations/Basics](/Translations/Basics#).
This page covers the details involved with translating a specific piece
of text.

## HTML Tags

The translation of Squid is currently just a translation of the various
HTML pages produced by Squid. This means; the error pages seen when
things go wrong, most of the FTP pages dealing with file transfers and
directory listings.

The text shown for translation may contain HTML markup. You should be
careful to leave these codes in the translation unchanged. You should
not be translating the text in a way that makes them removable.

## Protocol Terminology

Squid deals with Internet Protocols. Sometimes pieces of these are shown
in the text. They should not be removed.

There is an Internet RFC somewhere which requires each of these things
to have a certain **exact** text. Some admin may be stuck trying to read
the raw protocol and not find the **se-no-stor** tag anywhere when he
should have been searching for **if-not-cached**.

If a language has other words which describe it meaningfully the best
translations include a language description in brackets () or
equivalent, immediately after the term itself.

Some examples of these actually seen in the pages are:

  - **GET**

  - **PUT**

  - **Content-Length:**

  - **if-not-cached**

Others may appear any time.

So an english translation might look like this:

    Original:   PUT failed
    
    Translated: PUT (upload) failed

## % Code Tags

Squid uses codes starting with % to insert certain items into the text.

Please leave these in the translated message as they are important for
accurate error reporting. Remember that the final translation is going
to be installed in many different systems, your preferences for showing
certain things may not apply elsewhere.

I have found that in most messages where they mix with text, the code
usually represents a singular noun. (IP Address, URL,or Hostnames)

A reference of the available tags, if you need to know what one means to
translate it properly. Can be found at [Custom Errors
Feature](http://wiki.squid-cache.org/Features/CustomErrors)

## Language Dialects

The messages from Squid which you are looking at translating, are
automatically negotiated with website visitors during their creation.

This means that the language they are translated into is very specific
and we cannot accept a mix of dialects within a single coded .po
translation file. Each dialect whether within a language or between
countries needs to be given its own code and translated separately. See
the various English or Dutch codes for an example of what this means.

If you have any unusual situation with language and country combination
or language variant combinations that is not already solved, please
contact the translation maintainer for assistance.
([AmosJeffries](/AmosJeffries#)
at present).

## Special Language Display

Some languages require Right-to-Left or otherwise altered display
instead of the standard HTML English Left-to-Right settings. This is
currently achieved through the use of **:lang()** attributes in CSS.

To ensure compatibility with Squid-2 which does not natively perform the
same CSS insertion as
[Squid-3.1](/Releases/Squid-3.1#)
these language settings are embedded directly into the templates and
alterations need to be brought to the attention of the Squid Developers.

# Submissions Outside the System

If you are truly against using the existing translation toolkit system
we run. You have the option of locating the **errpages.pot** file in the
squid source code. Translating it and sending it to the translation
maintainer.
([AmosJeffries](/AmosJeffries#)
at present).

  - ![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png)
    Please note submissions are only considered for new languages or
    ones without a translator at the time of submission.
    
    ![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png)
    There is no guarantee that your work will make it into Squid until
    another translator can be found to verify it and enter it into the
    system for you.
    
    ![/\!\\](https://wiki.squid-cache.org/wiki/squidtheme/img/alert.png)
    You still need to meet all the translation guidelines listed above
    about codes and content.
    
    ℹ️
    **.PO** files need to have ISO-639 code information to indicate the
    language, and if possible the country ISO-3166 variant code as well.
    
      - Alhpabet used if there are a range of alphabets used for the
        language (ie Latin and Cyrillic)
    
      - If you don't know these codes, an indication of that info may be
        just as useful (ie american english, or british english, not
        just english).

[CategoryKnowledgeBase](/CategoryKnowledgeBase#)
