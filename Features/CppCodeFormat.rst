##master-page:FeatureTemplate
#format wiki
#language en
#faqlisted no

= Feature: C++ code formatting =

 * '''Goal''': Minimize patch conflicts, reduce commit noise, and improve code readability.
 * '''Status''': completed
 * '''Version''': Squid 3.1
 * '''Developer''': AlexRousskov AmosJeffries

== Details ==

Squid-2 code has a specific format which is enforced on CVS commit.

This project adds a similar format to Squid-3 code. Starting with 3.1. To format the source correctly you require astyle version 1.22 and an md5sum (binary or script equivalent).

=== When to format. ===

 (!) If you don't have the astyle 1.22 and md5sum tools to do a format correctly. Particularly the right version of astyle. We would rather you didn't do a format yourself.

That said. if you do have the right tools. You should reformat before sending a [PATCH] or [MERGE] request to squid-dev for auditing. Or before committing code. A global reformat is repeated every so often on trunk. But it saves everybody trouble and keeps bundlebuggy happy if patches have the right format to start with.

=== Doing a Reformat ===
Given the right tools to use. The ~/scripts/srcformat.sh script can be run over a [[../../Squid3VCS|Bazaar Repository]] checkout of the Squid-3 code to format it correctly.

=== Limiting the reformat area ===
The srcformat script is recursive from the current working directory down into its sub-directories. If run normally from the top level of a source checkout it will format the entire squid code.

To speed things up and limit the files checked, simply run it from the sub-directory where you have made changes. It does not go up levels, only down.

For example:
{{{
cd ~/squid-3/src
~/squid-3/scrips/srcformat.sh
}}}
will only format the src/* area of the checkout.

=== Handling Errors ===

It will abort on first syntax change leaving a file fubar.h.astylebad (bad reformat). So a manual diff like so:
{{{
diff -wu fubar.h fubar.h.astylebad
}}}
is needed to check whether the reformat worked.

Sometimes code comments get re-arranged. These are picked up as errors and can be ignored.
Simply accept the change by moving the fubar.h.astylebad into place over the unformatted one and run the formatter again. It will continue past and locate the next problem.

== astyle ==

  http://astyle.sourceforge.net/

----
CategoryFeature
