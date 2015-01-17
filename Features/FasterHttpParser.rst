##master-page:FeatureTemplate
#format wiki
#language en

= Feature: Faster HTTP parser =

 * '''Goal''':  Improve non-caching Squid3 performance by 20+%
 * '''Version''': 3.6
 * '''Status''': started
 * '''ETA''': 2016
 * '''Priority''': 1
 * '''Developer''': AmosJeffries and FrancescoChemolli
 * '''Feature Branch''': lp:~squid/squid/parser-ng (old: lp:~kinkie/squid/http-parser-ng)

= Details =

Avoid parsing the same HTTP header several times. Implement incremental header parsing.

One of the main expected gains from this and [[Features/BetterStringBuffer/StringNg|StringNg]] is increased clarity and performance in HTTP parsing. The (as of [[Squid-3.1]]) implementation of the HTTP parser (below "baseline situation") is a bit byzantine and also benefits from a makeover. The code shows that attempts have been made in the pasts but have not been completed.

== Code Architecture ==

Parsing handled by an {{{Http::Parser}}} child class which has an SBuf buffer and virtual {{{parse}}} method which splits the buffer content into message segments for followup processing.

Parsing of mime header block is (for now) handled as char* strings by {{{HttpMsg}} objects in turn using {{{HttpHeader}}} objects outside the {{{Parser}}} hierarchy. This object and all the logics it uses need to be refactored to operate on the SBuf presented by Http::One::Parser method {{mimeHeaders}}}

The {{{HttpMsg}} hierarchy objects are currently overloaded with two purposes;
 1. as general purpose HTTP message state storage objects
 2. as HTTP and ICAP response message parsing objects

=== going forward ===

 * Http::One::RequestParser has a {{{parseRequestFirstLine}}} method that needs to be refactored to use Parser::Tokenizer API for incremental processing of values out of the SBuf buffer.

 * add Http::One::ResponseParser for HTTP/1 reply parse

 * add ICY response parser

 * add HTTP/2 frame parser

 * add ICAP response parser

 * use the parsed ICAP response to interpret how the ICAP payload segments need to be parsed instead of attempting (badly) to auto-detect by throwing the {{{HttpMsg}}} parser at it.

 * code using the {{{HttpMsg}} parser needs to be refactored to use the Http::Parser API instead and the duplicate parser removed from Squid.

 * rewrite the request-line parse method using {{{SBuf}}} and {{{Tokenizer}}}

 * the {{{HttpHeader}}} parsing logics need to be converted to SBuf and Tokenizer API. Possibly run by the new {{{Parser}}} child classes.

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

 . ''Saved for comparison.''

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
   . incomplete, duplicates step 2 and 3, partially duplicates step 5.
 7. strcmp parse out request method,url,version (HttpRequest::parseFirstLine)
   . duplicates step 3 and 4
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

TODO: document the ICAP response parsing sequence. Despite visible efforts to make it simple that is even worse than HTTP response parsing due to its need to run the whole of the response AND request parsing chains above on payloads to auto-detect which will succeed.

----
CategoryFeature | CategoryWish
