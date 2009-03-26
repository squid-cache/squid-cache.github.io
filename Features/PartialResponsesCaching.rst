##master-page:Features/FeatureTemplate
#format wiki
#language en
##
## Change to 'yes' for a listing under Features in the Squid FAQ.
#faqlisted no

## This is a Feature documentation template. Remove this comment and replace  placeholder questions with the actual information about the feature.

= Feature: Support caching of partial responses =

## Move this down into the details documentation when feature is complete.
 * '''Goal''': Enable the caching of partial responses, and obsolete the range_offset_limit configuration option.

 * '''Status''': ''Not started''

 * '''ETA''': ''unknown''

 * '''Version''':

 * '''Priority''':

 * '''Developer''':

 * '''More''': Originally from [[http://www.squid-cache.org/bugs/show_bug.cgi?id=1337|Bug 1337]]

= Details =

(from the bug report):
When range_offset_limit is set to -1, Squid tries to fetch the entire object in
response to an HTTP range request. However, the entire file is fetched even when
it is not cacheable (e.g. because it is larger than maximum_object_size). Squid
should revert to fetching just the range if the entire file cannot be cached.
Otherwise, a patch fetching mechanism such as Windows Update, which fetches a
patch file in N chunks, will cause the file to be fetched in its entirety N
times. This can cause huge inefficiencies. Squid should always check for
cacheability before fetching the entire file.

The proper fix for this is to add caching of partial responses, eleminating the
need for range_offset_limit.


----
CategoryFeature
