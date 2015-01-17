##master-page:FeatureTemplate
#format wiki
#language en

## This is a Feature documentation template. Remove this comment and replace  placeholder questions with the actual information about the feature.

= Feature: Faster HTTP parser =

 * '''Goal''':  Improve non-caching Squid3 performance by 20+%
 * '''Version''': 3.6
 * '''Status''': started
 * '''ETA''': 2016
 * '''Priority''': 1
 * '''Developer''': AmosJeffries

= Details =
Avoid parsing the same HTTP header several times. Possibly implement incremental header parsing.

See ../StringNgHttpParser

=== current state ===

After initial structural updates to the Http::Parser hierarchy.

The ''request'' parsing systems in Squid-3.6+ the parser stack is as follows:

{i} the stack is asynchronous, now with incremental parse checkpoints resumed after read operation.

 1. scan to skip over garbage prefix
   . incremental checkpoint wherever it halts, (start of request-line or empty buffer)
 2. parse request line to find LF / SP positions, and invalid CR and NIL (Http::RequestParser::parse)
   . use found SP and LF positions to record method, URL, version
   . incremental checkpoint at end of request-line
 5. char* loop scan for end of header chunk (headersEnd)
   . incremental checkpoint at end of mime headers block
 8. strcmp / scanf / char* loops for parsing URL (urlParse)
 9. char* loop scan for end of each header line (Http::One::Parser::findMimeBlock / headersEnd)
 10. strcmp scan for : delimiter on header name and generate header objects
 11. strListGet scan for parse of header content options

No changes yet in mainstream response parsing.

=== the baseline situation ===

Initial analysis of the ''request'' parsing systems in Squid-3 showed the parser stack to be as follows:

/!\ the entire stack is asynchronous with a full reset to step 1 after read operation where the message was incompletely received.

 1. scan to skip over garbage prefix
 2. parse request line to find LF, and invalid CR and NIL (HttpParser::parseRequestLine)
   . discard prior parse information !!
 3. and again, parse request line to find SP positions (HttpParser::parseRequestLine)
   . discard prior parse information !!
 4. parse inside each request-line token to check method/URL/version syntax (HttpParser::parseRequestLine)
   . discard prior parse information !!
 5. char* loop scan for end of header chunk (headersEnd)
 6. sscanf re- scan and sanity check request line (HttpRequest::sanityCheck)
   . incomplete, duplicates step 1 and 2, partially duplicates step 4.
 7. strcmp parse out request method,url,version (HttpRequest::parseFirstLine)
   . duplicates step 2 and 3
 8. strcmp / scanf / char* loops for parsing URL (urlParse)
 9. char* loop scan for end of each header line (headersEnd)
 10. strcmp scan for : delimiter on header name and generate header objects
 11. strListGet scan for parse of header content options


The parse sequences join at header line parsing (step 6), with some crossover at sanity checks (step 3).
''response'' parsing is as follows:

 i. processReplyHeader calls HttpMsg::parse
    . discarding all previous parse information !!
  1. char* loop scan for end of header chunk (headersEnd)
  2. sscanf re- scan and sanity check first line (HttpReply::sanityCheck)
    . on fail skip to stage ii below
  3. strcspn scan for end of header line
  4. char* loop scan for end of header chunk (HttpMSg::httpMsgIsolateStart)
  5. strcmp parse out response version, status message (HttpReply::parseFirstLine)
  6. strcspn scan for end of header line
  7. char* loop scan for end of header chunk (wow 6 in a row!) (HttpMSg::httpMsgIsolateStart)
  8. strcmp scan for : delimiter on header name and generate header objects
  9. strListGet scan for parse of header content options

 ii. check for special case missing "HTTP" and "ICY" protocol versions
  * generates a fake HTTP/0.9 reply
  * packs it into a buffer
  * parses the fake reply !!
   . discarding all previous parse information !!
   . repeat all of stage i

 iii. char* loop scan for end of header chunk (headersEnd)
   . because we seem not to have scanned enough times in stage i

----
CategoryFeature | CategoryWish
