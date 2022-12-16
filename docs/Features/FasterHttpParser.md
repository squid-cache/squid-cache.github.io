---
categories: WantedFeature
---
# Feature: Faster HTTP parser

- **Goal**: Improve non-caching Squid3 performance by 20+%
- **Version**: 3.6
- **Status**: started
- **ETA**: 2016
- **Priority**: 1
- **Developer**:
  [AmosJeffries](/AmosJeffries)
  and
  [FrancescoChemolli](/FrancescoChemolli)
- **Feature Branch**: lp:\~squid/squid/parser-ng (old:
  lp:\~kinkie/squid/http-parser-ng)

# Details

Avoid parsing the same HTTP header several times. Implement incremental
header parsing.

One of the main expected gains from this and
[StringNg](/Features/BetterStringBuffer/StringNg)
is increased clarity and performance in HTTP parsing. The (as of
[Squid-3.1](/Releases/Squid-3.1))
implementation of the HTTP parser (below "baseline situation") is a bit
byzantine and also benefits from a makeover. The code shows that
attempts have been made in the pasts but have not been completed.

## Code Architecture

Parsing handled by an `Http::Parser` child class which has an SBuf
buffer and virtual `parse` method which splits the buffer content into
message segments for followup processing.

Parsing of mime header block is (for now) handled as char\* strings by
`HttpMsg` objects in turn using `{HttpHeader` objects outside the
`Parser` hierarchy. This object and all the logics it uses need to be
refactored to operate on the SBuf presented by Http::One::Parser method
`mimeHeaders`

The `HttpMsg` hierarchy objects are currently overloaded with two
purposes;

1. as general purpose HTTP message state storage objects
1. as HTTP and ICAP response message parsing objects

### going forward

Under review:

- conversion of ICAP I/O read buffer to SBuf

Underway:

- add HTTP/2 frame parser
- add ICAP response parser

TODO:

- use the parsed ICAP response to interpret how the ICAP payload
    segments need to be parsed instead of attempting (badly) to
    auto-detect by throwing the `HttpMsg` parser at it.
- code using the `HttpMsg` parser needs to be refactored to use the
    `Http::Parser` API instead and the duplicate parser removed from
    Squid.
- refactor the `HttpHeader` parsing logics to use `SBuf` and
    `::Parser::Tokenizer` API. Possibly run by the new `Parser` child
    classes.
- refactor `ChunkedDecoder::parse` to use `SBuf` and
    `::Parser::Tokenizer`.

### current state

After initial structural updates to the Http::Parser hierarchy.

> :information_source:
  the stack is asynchronous, now with incremental parse checkpoints
  resumed after read operations.

The *request* parsing system `Http1::RequestParser::parse` in Squid-3.6+
is as follows:

1. scan to skip over garbage prefix
1. incremental checkpoint wherever it halts, (start of request-line
    or empty buffer)
1. scan to find method
1. incremental checkpoint at end of method
1. scan to find URI and version
    - in relaxed parser scan to find LF then work backwards
    - in strict parsser scan for SP delimiters with extra checkppoint
        after URI
    - incremental checkpoint at end of request-line
1. char\* loop scan for end of header chunk
    (Http1::Parser::findMimeBlock / headersEnd)
1. incremental checkpoint at end of mime headers block
1. strcmp / scanf / char\* loops for parsing URL (urlParse)
1. char\* loop scan for end of each header line
    (`HttpHeader::parse`)
1. strcmp scan for : delimiter on header name and generate header
    objects
1. strListGet scan for parse of header content options

The *response* parsing system `Http1::ResponseParser::parse` in
Squid-3.6+ is as follows:

1. scan for message version field
    - accepting both "HTTP/1.x" and "ICY" protocol versions
    - if necessary generates a fake HTTP/0.9 reply and terminates
        parsing.
1. incremental checkpoint at end of version label
1. scan for message status code field
1. incremental checkpoint at end of status code
1. scan for end of first line
1. incremental checkpoint at end of line
1. char\* loop scan for end of header chunk
    (Http1::Parser::findMimeBlock / headersEnd)
1. incremental checkpoint at end of mime headers block
1. char\* loop scan for end of header chunk
    (`HttpMsg::httpMsgIsolateStart`)
1. strcmp scan for : delimiter on header name and generate header
    objects
    (`HttpHeader::parse`)
1. strListGet scan for parse of header content options

The ICAP *response* parsing system
`Adaptation::Icap::ResponseParser::parse` in parser-ng-icap-pt2 branch
is as follows:

> :information_source:
class inherits from the `Http1::ResponseParser` parser, but replaces the
stage 1 version scan with an ICAP specific scan.

1. scan for message version field
    - accepting "ICAP/1.0" protocol version only
    - incremental checkpoint at end of version label
1. scan for message status code field
1. incremental checkpoint at end of status code
1. scan for end of first line
1. incremental checkpoint at end of line
1. char\* loop scan for end of header chunk
    (Http1::Parser::findMimeBlock / headersEnd)
1. incremental checkpoint at end of mime headers block
1. char\* loop scan for end of header chunk
    (`HttpMsg::httpMsgIsolateStart`)
1. strcmp scan for : delimiter on header name and generate header
    objects
    (`HttpHeader::parse`)
1. strListGet scan for parse of header content options

> :warning:
    NOTE: Parsing of ICAP response messages and payload segments still uses
    the old `HttpMsg` API documented below for HTTP responses, when the
    payload segment is a request it uses the
    `HttpMsg::parse` request-line code paths.

### the baseline situation

  - *Saved for comparison.*

Initial analysis of the *request* parsing systems in Squid-3 showed the
parser stack to be as follows:

:warning: the
entire stack is asynchronous with a full reset to step 1 after read
operation where the message was incompletely received.

1. scan to skip over garbage prefix

1. parse request line to find LF, and invalid CR and NIL
    (`HttpParser::parseRequestLine`)

      - discard prior parse information \!\!

1. and again, parse request line to find SP positions
    (`HttpParser::parseRequestLine`)

      - discard prior parse information \!\!

1. parse inside each request-line token to check method/URL/version
    syntax
    (`HttpParser::parseRequestLine`)

      - discard prior parse information \!\!

1. char\* loop scan for end of header chunk (headersEnd)

1. sscanf re- scan and sanity check request line
    (HttpRequest`::sanityCheck`)

      - incomplete, duplicates step 2 and 3, partially duplicates step
        5.

1. strcmp parse out request method,url,version
    (`HttpRequest::parseFirstLine`)

      - duplicates step 3 and 4

1. strcmp / scanf / char\* loops for parsing URL (urlParse)

1. char\* loop scan for end of each header line (headersEnd)

10. strcmp scan for : delimiter on header name and generate header
    objects

11. strListGet scan for parse of header content options

The parse sequences join at header line parsing (step 6), with some
crossover at sanity checks (step 3). *response* parsing is as follows:

1. processReplyHeader calls
    `HttpMsg::parse`

      - discarding all previous parse information \!\!

    <!-- end list -->

    1. char\* loop scan for end of header chunk (headersEnd)

    2.  sscanf re- scan and sanity check first line
        (`HttpReply::sanityCheck`)

          - on fail skip to stage ii below

    3.  strcspn scan for end of header line

    4.  char\* loop scan for end of header chunk
        (HttpMSg::httpMsgIsolateStart)

    5.  strcmp parse out response version, status message
        (`HttpReply::parseFirstLine`)

    6.  strcspn scan for end of header line

    7.  char\* loop scan for end of header chunk (wow 6 in a row\!)
        (`HttpMSg::httpMsgIsolateStart`)

    8.  strcmp scan for : delimiter on header name and generate header
        objects

    9.  strListGet scan for parse of header content options

    ii. check for special case missing "HTTP" and "ICY" protocol
    versions

      - generates a fake HTTP/0.9 reply

      - packs it into a buffer

      - parses the fake reply \!\!

          - discarding all previous parse information \!\!

          - repeat all of stage i

    iii. char\* loop scan for end of header chunk (headersEnd)

      - because we seem not to have scanned enough times in stage i

TODO: document the ICAP response parsing sequence. Despite visible
efforts to make it simple that is even worse than HTTP response parsing
due to its need to run the whole of the response AND request parsing
chains above on payloads to auto-detect which will succeed.
