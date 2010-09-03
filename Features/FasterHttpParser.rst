##master-page:FeatureTemplate
#format wiki
#language en

## This is a Feature documentation template. Remove this comment and replace  placeholder questions with the actual information about the feature.

= Feature: Faster HTTP parser =

 * '''Goal''':  Improve non-caching Squid3 performance by 20+%
 * '''Version''': 3.2 or later
 * '''Status''': not started
 * '''ETA''': unknown
 * '''Developer''': 
 * '''More''': TODO: link to Squid2 parser work here.

Avoid parsing the same HTTP header several times. Possibly implement incremental header parsing.

See ../StringNgHttpParser


After initial analysis of the ''request'' parsing systems in Squid-3 the parser stack is as follows:

 1. parse request line (now single-pass, was three passes)
  . discard prior parse information !!
 2. char* loop scan for end of header chunk
 3. sscanf re- scan and sanity check request line (incomplete, partially duplicates step 2.)
 4. strcmp parse out request method,url,version
 5. strcmp / scanf / char* loops for parsing URL
 6. char* loop scan for end of each header line
 7. strcmp scan for : delimiter on header name and generate header objects
 8. strListGet scan for parse of header content options

early stages of ''reply'' parsing have yet to be detailed. The parse sequences join at header line parsing, with some crossover at sanity checks.

----
CategoryFeature | CategoryWish
