##master-page:KnowledgeBaseTemplate
##Page-Creation-Date:<<Date(2008-10-01T07:40:20Z)>>
##Page-Original-Author:[[Amos Jeffries]]
#format wiki
#language en

= Guidelines for Translating Squid =

How to use the translation tools is covered in [[../Basics]].
This page covers the details involved with translating a specific piece of text.

== HTML Tags ==

The translation of Squid is currently just a translation of the various HTML pages produced by Squid.
This means; the error pages seen when things go wrong, most of the FTP pages dealing with file transfers (not directory listings yet).

The text shown for translation may contain HTML markup. You should be careful to leave these codes in the translation. You should not be translating the text in a way that makes them removable.

== Protocol Terminology ==

Squid deals with Internet Protocols. Sometimes pieces of these are shown in the text. They should not be removed.

There is an Internet RFC somewhere which requires each of these things to have a certain '''exact''' text. Some admin may be stuck trying to read the raw protocol and not find the '''se-no-stor''' tag anywhere when he should have been searching for '''if-not-cached'''.

If a language has other words which describe it meaningfully the best translations include a language description in brackets () or equivalent, immediately after the term itself.

Some examples of these actually seen in the pages are:
 * '''GET'''
 * '''PUT'''
 * '''Content-Length:'''
 * '''if-not-cached'''
Others may appear anytime.

So an english translation might look like this:
{{{
Original:   PUT failed

Translated: PUT (upload) failed
}}}


== % Code Tags ==

Squid uses codes starting with % to insert certain items into the text.

Please leave these in the translated message as they are important for accurate error reporting. Remember that the final translation is going to be installed in many different systems, your preferences for showing certain things may not apply elsewhere.

I have found that in most messages where they mix with text, the code usually represents a singular noun. (IP Address, URL,or Hostnames)

A reference of the available tags if you need to know what one means to translate it properly is available in the [[SquidFaq/MiscFeatures#head-fd8f5559ec842b21e1acb06823eaa9b83897fcc3|FAQ]]



= Submissions Outside the System =

If you are truly against using the existing translation toolkit system we run. You have the option of locating the '''dictionary.pot''' file in the squid source code. Translating it and sending it to the translation maintainer. (AmosJeffries at present).

 /!\ Please note submissions are only considered for new languages or ones without a translator at the time of submission.

 /!\ There is no guarantee that your work will make it into Squid until another translator can be found to verify it and enter it into the system for you.

 /!\ You still need to meet all the translation guidelines listed above about codes and content.

 {i} '''.PO''' files need to have ISO-639 code information to indicate the language, and if possible the country ISO-3166 variant code as well. If you don't know these, an indication of that info may be just as useful (ie american english, or british english, not just english).

----
CategoryKnowledgeBase
