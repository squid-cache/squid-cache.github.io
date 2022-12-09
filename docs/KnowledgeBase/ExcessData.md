---
categories: ReviewMe
published: false
---
# Excess Data

**Symptoms**

  - httpReadReply: Excess data from "GET <http://example.com>"

**Explanation**

HTTP transactions contain headers specifying the sizes of objects
transferred. When these are present Squid will validate the object
actually does match the size it is supposed to. This message is what
gets logged when the object received back is larger than it is supposed
to be.

It is a sign that the transfer has been altered somewhere between the
website and your Squid.

  - It could be a cache-poisoning security attack on your traffic.
    Attempting to inject false replies into your cache, spreading an
    embedded infection to other clients on the network.

  - It could be a broken proxy (other than yours) failing to update the
    reply headers correctly after re-validation.
    :one:

  - It could be a broken adaptation service failing to adjust the new
    size of the object.
    :one:

  - It could be a service somewhere sending length header on chunked
    replies.
    :one:

Squid protects itself and your other clients against these possibilities
by erasing the broken received copy and not sharing it out to other
clients.

The specific client who received the bad response is unfortunately left
to handle broken reply itself. Squid will try to assist by aborting the
connection with a RESET, indicating that the something nasty has gone
on. Not all clients handle this cleanly.

**Workaround**

There is no generally usable workaround for this problem. Fixes for this
are very specific to your installation and which of the above problems
is causing it.

Some of the options include:

  - ACLs blocking access to the problem website

  - Bypassing the proxy for that specific site (unsafe if it really is
    an attack).

  - Tracking down which of the causes is occurring and reporting the
    problem.

  - In the cases labelled
    :one:
    software upgrades for the relevant middleware might help.

NP: if you track it down to some other cause not mentioned above, we
would like to know so this article gets updated.

[CategoryKnowledgeBase](/CategoryKnowledgeBase)
[CategoryErrorMessages](/CategoryErrorMessages)
