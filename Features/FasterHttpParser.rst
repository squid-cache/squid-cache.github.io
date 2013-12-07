##master-page:FeatureTemplate
#format wiki
#language en

## This is a Feature documentation template. Remove this comment and replace  placeholder questions with the actual information about the feature.

= Feature: Faster HTTP parser =

 * '''Goal''':  Improve non-caching Squid3 performance by 20+%
 * '''Version''': 3.5 or later
 * '''Status''': started
 * '''ETA''': unknown
 * '''Developer''': AmosJeffries
 * '''More''': TODO: link to Squid2 parser work here.

Avoid parsing the same HTTP header several times. Possibly implement incremental header parsing.

See ../StringNgHttpParser


After initial analysis of the ''request'' parsing systems in Squid-3 the parser stack is as follows:

 1. parse request line (now single-pass, was three passes) (HttpParser::parseRequestLine)
  . discard prior parse information !!
 2. char* loop scan for end of header chunk (headersEnd)
 3. sscanf re- scan and sanity check request line (HttpRequest::sanityCheck)
  . incomplete, partially duplicates step 2.
 4. strcmp parse out request method,url,version (HttpRequest::parseFirstLine)
  . duplicates step 1
 5. strcmp / scanf / char* loops for parsing URL (urlParse)
 6. char* loop scan for end of each header line (headersEnd)
 7. strcmp scan for : delimiter on header name and generate header objects
 8. strListGet scan for parse of header content options


The parse sequences join at header line parsing (step 6), with some crossover at sanity checks (step 3).
''response'' parsing is as follows:

 1. processReplyHeader calls HttpMsg::parse
   . discarding all previous parse information !!
  1. char* loop scan for end of header chunk (headersEnd)
  2. sscanf re- scan and sanity check first line (HttpReply::sanityCheck)
   . on fail skip to stage 2 below
  3. strcspn scan for end of header line
  4. char* loop scan for end of header chunk (HttpMSg::httpMsgIsolateStart)
  5. strcmp parse out response version, status message (HttpReply::parseFirstLine)
  6. strcspn scan for end of header line
  7. char* loop scan for end of header chunk (wow 6 in a row!) (HttpMSg::httpMsgIsolateStart)
  8. strcmp scan for : delimiter on header name and generate header objects
  9. strListGet scan for parse of header content options

 2. check for special case missing "HTTP" and "ICY" protocol versions
  * generates a fake HTTP/0.9 reply
  * packs it into a buffer
  * parses the fake reply !!
   . discarding all previous parse information !!
   . repeat stage 1

 3. char* loop scan for end of header chunk (headersEnd)
   . because we seem not to have scanned enough times in step 1

----
CategoryFeature | CategoryWish
