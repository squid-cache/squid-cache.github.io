##master-page:CategoryTemplate
#format wiki
#language en
##
## Change to 'yes' for a listing under Features in the Squid FAQ.
#faqlisted no



= Feature: Progress of the HTTP/1.1 conversion of Squid? =
 * '''Goal''': To make Squid a full HTTP/1.1 proxy

 * '''Status''': Underway

## * '''Version''': What Squid version(s) will get this feature?

## * '''Priority''': How important on a scale of 0 to 5 is this for the developer working on it?

## * '''Developer''': Who is responsible for this feature? Use wiki names for developers who have a home page on this wiki.

== Details ==
|| '''2.x''' || '''3.x''' || '''ID''' || '''Requirement type''' || '''section''' || '''requirement''' || '''squid status''' || '''notes''' ||
|| || || 1 || REQUIRED || 2.1 || handle implied LWS            = [CRLF] 1*( SP | HT ) || should do now || ||
|| || || 2 || REQUIRED || 2.2 || fold CRLF in headers into one long header before interpreting || should do now || ||
|| || || 3 || MUST || 3.1 || parse HTTP-Version as two multi-digit integers || unknown || ||
|| || || 4 || SHOULD || 3.1 || send HTTP/1.1 in messages once we are conditionally compilent || not done || ||
|| || || 5 || MUST || 3.1 || send HTTP/1.1 in messages that are not compatible with HTTP/1.0 || not done || ||
||Y ||Y || 6 || MUST NOT || 3.1 || send HTTP versions greater than that of squid itself. (squid will be 1.1 when and only when it is conditionally compliant with rfc 2616 || || when we support all of http/1.1 send http/1.1 ||
|| || || 7 || MUST || 3.1 || downgrade requests from greater than squid supports to what squid supports, return an error, or switch to tunnel behaviour || not done || hno - 7: Done, by simply downgrading the protocol number. No attempts in downgrading the request is done ||
||Y ||Y || 8 || MUST || 3.1 || upgrade client requests to the highest version of HTTP supported by squid. || || conversion may involve altering header fields in ways that break the versions involved; HNO - 8: HTTP/0.9 is upgraded to HTTP/1.0 if support for 0.9 is enabled (and fixed). ||
|| || || 9 || MUST || 3.1 || respond to old client requests with HTTP in the same major version. Ie a 1.x client must get a 1.x reponse, regardless if squid is a 2.x proxy by that point || || hno - all responses from squid are in squids current http version ||
||Y ||Y || 10 || MUST || 3.2.1 || handle the URI of any resource served out (read proxied) || || ||
||4KB ||8KB || 11 || SHOULD || 3.2.1 || handle unbounded length URI's if we allow long GET requests || || we set an upper limit on URI's ||
|| || || 12 || SHOULD || 3.2.1 || return 414 for URI's longer than we can actually handle || not done || use caution handling URI's more than 255 bytes long - old clients or downstream proxies may break. Hno - we currently return some other error code ||
||Y ||Y || 13 || SHOULD || 3.2.2 || avoid using ip address's in generated URL's || || squids host name is used ||
|| || || 14 || MUST || 3.2.2 || add / to http urls that have no abs_path; and if generating requests include the / || || done when sending to origin, not when sending to another proxy ||
|| || || 15 || MUST NOT || 3.2.2 || change the hostname in a request with a FQDN in it || not done || redirectors can violate this ||
||Y ||Y || 16 || MAY || 3.2.2 || add squids domain to the hostname that are not fully qualified in requests received by squid || || configure squid with append_domain ||
|| || || 17 || SHOULD || 3.2.3 || compare URI's by case-sensitive octet-by-octet comparison of the entire URI. || || empty or absent ports are equivalent to the default for that resource; empty abs_path ="/" ||
|| || || 18 || MUST || 3.2.3 || compare hostnames in URI's case-insensitively || not done || ||
|| || || 19 || MUST || 3.2.3 || compare scheme names in URI's case-insensitively || not done || ||
|| || || 20 || MUST || 3.2.3 || match % HEX HEX encoded characters with those outside the reserved and unsafe sets when comparing URI's || unknown || ie http://abc.com:80/~smith/home.html; [[http://ABC.com/~smith/home.html;|http://ABC.com/%7Esmith/home.html;]] [[http://ABC.com:/~smith/home.html|http://ABC.com:/%7esmith/home.html]] match ||
||Y ||Y || 21 || MUST || 3.3.1 || handle the three date formats of HTTP/1.0 || || robustness is encouraged :-] ||
||Y ||Y || 22 || MUST || 3.3.1 || only generate dates in rfc 1123 format || || ||
||Y ||Y || 23 || MUST || 3.3.1 || generate all dates in GMT (UTC) time. || || ||
||Y ||Y || 24 || MUST || 3.3.1 || assume GMT time when reading asctime format || || ||
|| || || 25 || MUST || 3.3.1 || not add LWS to the HTTP-date format other than that specifically included in the grammer || should do now || ||
|| || || 26 || MUST || 3.4 || specify the mapping associated with a MIME character set name when using MIME character sets || not done || error pages specify the charset & possibly other places ||
|| || || 27 || SHOULD || 3.4 || limit the use of MIME character sets to IANA registry defined character sets || not done || ||
|| || || 28 || MAY || 3.4.1 || include a charset parameter even when the charset is ISO-8559-1 || not done || ||
|| || || 29 || SHOULD || 3.4.1 || include a charset parameter even when the charset is ISO-8559-1 when we know we will not confuse the client || not done || ||
|| || || 30 || MUST || 3.4.1 || for the 'client' respect the charset label provided by the sender. || not done || ||
|| || || 31 || SHOULD NOT || 3.5 || create responses with Content-Encoding: identity || should do now || ||
||N/A ||N/A || 32 || SHOULD || 3.5 || register new content-coding value tokens with IANA || || ||
||N/A ||N/A || 33 || SHOULD || 3.5 || make publicly available specifications for new content-coding value tokens which conform to the purpose of content coding as per section 3.5 || || ||
|| || || 34 || MUST || 3.6 || when a transfer-coding is applied, include "chunked" in the set of transfer codings unless the message is terminated by closing the connection. || not done || hno - check the te branch ||
|| || || 35 || MUST NOT || 3.6 || applied "chunked" more than once to a message-body || not done || hno - check the te branch ||
||N/A ||N/A || 36 || SHOULD || 3.6 || register new transfer-encodings with IANA (as per section 3.5 for content-codings || || ||
|| || || 37 || SHOULD || 3.6 || return 501 and close the connection when client entity-bodies are received that squid doesn't understand the transfer-codings of. || not done || hno - check the te branch ||
|| || || 38 || MUST NOT || 3.6 || send transfer-codings (TE or Transfer-Encoding headers) to HTTP/1.0 clients || not done || hno - check the te branch ||
|| || || 39 || OPTIONAL || 3.6.1 || send a trailer after sending chunked transfer encoded messages || not done || hno - check the te branch ||
|| || || 40 || MUST NOT || 3.6.1 || put headers in the trailer unless a) the request included a TE header that indicates trailers is acceptable in the transfercoding (see 14.39) or b) the server is the origin, (and paraphrasing) the trailers are not needed to use the response) || not done || hno - check the te branch ||
|| || || 41 || MUST || 3.6.1 || understand "chunked" transfer-coding || not done || hno - check the te branch ||
|| || || 42 || MUST || 3.6.1 || ignore chunk-extensions not understood || not done || hno - check the te branch ||
|| || || 43 || MUST NOT || 3.7 || use LWS between the type and sub type in media-types, or between attribute and values || does now || for squid generated headers ||
|| || || 44 || SHOULD || 3.7 || when sending to older applications (< HTTP/1.1) only use media types when required by the type/subtype definition || not done || ||
|| || || 45 || MUST || 3.7.1 || represent entity-bodies in canonical media-type form (except "text" types). || does now || see rfc 2616 section 3.7.1 ||
|| || || 46 || MUST || 3.7.1 || represent entity-bodies in canonical media-type form (except "text" types) prior to content-coding them || does now || see rfc 2616 section 3.7.1 ||
|| || || 47 || MUST || 3.7.1 || label data in charsets other than ISO-8859-1" with an appropriate charset value. || not done || see rfc 2616 section 3.4.1 for compatability notes ||
|| || || 48 || MUST || 3.7.2 || include a boundary parameter as part of the media type value for multipart media types || unknown || hno - squid does not generate or touch mulipart entries. Rbc - we may need to with TE content. Ermm, ||
|| || || 49 || MUST || 3.7.2 || only use CRLF in multipart messages to represent line breaks between body-parts. || unknown || hno - squid does not generate or touch mulipart entries. Rbc - we may need to with TE content. Ermm, ||
|| || || 50 || MUST || 3.7.2 || have the epilogue of multipart messages empty || unknown || hno - squid does not generate or touch mulipart entries. Rbc - we may need to with TE content. Ermm, ||
|| || || 51 || MUST NOT || 3.7.2 || transmit the epligoue of multipart messages (even if given one) || unknown || hno - squid does not generate or touch mulipart entries. Rbc - we may need to with TE content. Ermm, ||
|| || || 52 || SHOULD || 3.7.2 || follow the same behaviour as a MIME agent when receiving a multipart message-body. || unknown || ||
|| || || 53 || MUST || 3.7.2 || treat unrecognized multipart subtypes as "multipart/mixed" || unknown || nb see rfc 1867 for multipart/form-data definition ||
|| || || 54 || SHOULD || 3.8 || use short to the point product-tokens || unknown || ||
|| || || 55 || MUST NOT || 3.8 || use product tokens for advertising or non-essential info || unknown || ||
|| || || 56 || MAY || 3.8 || use any token character in  a product-version || unknown || ||
|| || || 57 || SHOULD || 3.8 || only use product-version tokens for a specific version || unknown || ||
|| || || 58 || SHOULD || 3.8 || only change the product-version portion of a product value when changing version numbers || unknown || ||
|| || || 59 || MUST NOT || 3.9 || generate more than 3 digits after the decimal point in quality values || unknown || ||
|| || || 60 || SHOULD || 3.9 || limit user configuration to 3 digits on quality values || unknown || ||
|| N || 3.1 || 61 || MUST || 3.10 || use rfc 1766 language tags in the accept-language and content-language fields ||
|| || || 62 || MAY || 3.11 || provide the same "strong" entity tag for two resources only if they are equivalent by octet equality || unknown || ||
|| || || 63 || MAY || 3.11 || provide the same "weak" entity tag for two resources only if they are equivalent and can be substituted with no significant semantic changes || unknown || ||
|| || || 64 || MUST || 3.11 || when giving entity tags provide unique entity tags for all versions of entities associated with a particular resource || unknown || ||
|| || || 65 || MAY || 3.11 || provide the same entity tag value for different resource URIs  - note that this does no imply entity equivalence across resources || unknown || ||
|| || || 66 || MAY || 3.12 || ignore unrecognized ranges specified with units other than "bytes" || unknown || ||
|| || || 67 || SHOULD || 4.1 || ignore empty lines where the Request-Line is expected || unknown || ||
|| || || 68 || MUST NOT || 4.1 || preface or follow a request with an extra CRLF || unknown || ||
|| || || 69 || MAY || 4.2 || precede header field values with LWS - although a single SP is preferred || unknown || ||
|| || || 70 || MUST || 4.2 || precede extra lines in header fields with a  single SP or HT || unknown || ||
|| || || 71 || MAY || 4.2 || replace LWS in field values with a single SP || unknown || ||
|| || || 72 || MAY || 4.2 || remove leading or trailing LWS on header fields || unknown || ||
|| || || 73 || recommendation || 4.2 || send general-headers, then request/response headers, and then entity-headers || unknown || ||
|| || || 74 || MUST || 4.2 || when generating multiple message header fields with the same field-name, be possible for the client or downstream to combine by appending ", field-value" in the order received to generate one long header-field || unknown || ||
|| || || 75 || MUST NOT || 4.2 || alter the order on multiple message headers with the same field-name || unknown || ||
|| || || 76 || MUST || 4.3 || use Transfer-Encoding to indicate any transfer encodings used when transmitting messages. || unknown || ||
|| Y || 3.1 || 77 || MAY || 4.3 || add or remove Transfer-Encoding along the request chain (ie receive a message as a plain entity-body and transfer-encode via gzip for transmission downstream ||
|| || || 78 || MUST NOT || 4.3 || include a message-body in a request if the request-method does not allow it || unknown || ||
|| || || 79 || SHOULD || 4.3 || read and forward message-bodies on any request || unknown || ||
|| || || 80 || SHOULD || 4.3 || ignore message-bodies when semantics for the requests method do not define a message-body || unknown || ||
|| || || 81 || MUST NOT || 4.3 || include a message-body in a response to a HEAD request || unknown || ||
|| || || 82 || MUST NOT || 4.3 || include a message body in 1xx, 204 and 304 reponses || unknown || ||
|| || || 83 || MUST || 4.3 || include a message body in all other responses, although it MAY be zero length || unknown || ||
|| || || 84 || MUST || 4.4 || assume message termination by the first empty line after the header fields in responses that "MUST NOT" have message bodies (ie 1xx, 204, 304 and HEAD requests) || unknown || ||
|| || || 85 || MUST NOT || 4.4 || send a Content-Length header if the entity-length and the transfer-length are not equal || unknown || ||
|| || || 86 || MUST || 4.4 || ignore the Content-Length header if a Transfer-Encoding header is received || unknown || ||
|| || || 87 || MUST NOT || 4.4 || send media type multipart/byteranges unless we know the recipient can parse it. || unknown || the presence of a Range header with multiple byte-range specifiers from a 1.1 client implies that the client can parse these reponses ||
|| || || 88 || MUST || 4.4 || delimit the reponse message by one of 1) the first empty line if no message body defined(see 4.3), 3) Content-Length header or 5) close the connection when sending a response of type multipart/byteranges to a 1.0 Proxy which forwarded the request from a client that does understand || unknown || ||
|| || || 89 || MUST || 4.4 || include a Content-Length header in requests containing a message body unless the server is known to be 1.1 compliant. || unknown || ||
|| || || 90 || SHOULD || 4.4 || return 400 bad request if it cannot determine the length of a request message or 411 if we wish to enforce receiving a valid content-length || unknown || ||
|| || || 91 || MUST NOT || 4.4 || include both Content-Length and a non-identity transfer coding. || unknown || ||
|| || || 92 || MUST || 4.4 || ignore the Content-Length header if a non-identity Transfer-Encoding is received. (perhaps covering for TE instead of Transfer-Encoding??) || unknown || ||
|| || || 93 || MUST || 4.4 || IF we are acting like a user agent - ie 'client' - notify the user when an invalid length is received and detected - ie Content-Length does not match the number of octects in the message-body. || unknown || ||
|| || || 94 || MUST || 4.4 || when sending a reponse where a message body is allowed and we include Content-Length, it's value must match the number of OCTECTS in the message-body || unknown || ||
|| || || 95 || MUST || 4.5 || treat unrecognized header fields as enitity header fields || unknown || ||
|| || || 96 || SHOULD || 5.1.1 || return 405 if a request method is recognized but not allowed || unknown || ||
|| || || 97 || SHOULD || 5.1.1 || return 501 if a request method is not implemented || unknown || ||
|| || || 98 || MUST || 5.1.1 || support GET and HEAD for squid generated pages || unknown || ||
|| || || 99 || MUST || 5.1.1 || implementh other methods beyond GET and HEAD in accordance with rfc 2616 || unknown || ||
|| || || 100 || MUST || 5.1.1 || recognize all squid server names, including any aliases, local variations, and the numeric IP address || unknown || ||
|| || || 101 || MUST || 5.1.1 || accept absolute URI's for all requests. || unknown || ||
|| || || 102 || MAY || 5.1.1 || forward requests to other proxies or to the origin server. || should do now || ||
|| || || 103 || MUST || 5.1.2 || decode URI's with % HEX HEX format before interpreting the request. || unknown || ||
|| || || 104 || SHOULD || 5.1.2 || return appropriate status codes to invalid Request-URIs || unknown || ||
|| || || 105 || MUST NOT || 5.1.2 || in transparent mode; rewrite the abs_path in thr Request-URI (ither than replacing a null abs_path with "/") || unknown || ||
|| || || 106 || MUST || 5.2 || for absolute Request-URI's ignore any host header field in the request || unknown || ||
|| || || 107 || MUST || 5.2 || for non-absolute Request-URI's with a host header use the host head field value || unknown || ||
|| || || 108 || MUST || 5.2 || for non-absolute Request-URI's with no host header return 400 || unknown || ||
|| || || 109 || MUST NOT || 5.2 || generate responses with CR or LF except at the end of the status line || unknown || ||
|| || || 110 || MUST || 6.1 || understand the class of status codes (the 1st digit) and treat unrecognized responses as x00. || unknown || ||
|| || || 111 || MUST NOT || 6.1 || cache responses with unrecognized status codes || unknown || ||
|| || || 112 || MAY || 7 || transmit an entity if not otherwise restricted by the request method or response code || unknown || ||
|| || || 113 || MUST || 7.1 || in transparent mode: forward unrecognized header fields || unknown || ||
|| || || 114 || SHOULD || 7.2.1 || include a Content-Type header for generated HTTP/1.1 messages w/entity bodies || unknown || ||
|| || || 115 || SHOULD || 7.2.1 || treat unknown media-types as application/octet-stream || unknown || ||
|| || || 116 || SHOULD || 8.1.1 || implement HTTP/1.1 persistent connections || unknown || ||
|| || || 117 || SHOULD || 8.1.2 || assume http/1.1 servers will maintain persistent connections even after error responses from the server || unknown || ||
|| || || 118 || MUST NOT || 8.1.2 || send more requests on a connection afer a close is signaled || unknown || ||
|| || || 119 || MAY || 8.1.2.1 || Assume a HTTP/1.1 client intends to maintain a persistent connection unless a Connection header with token close was received in the request || unknown || ||
|| || || 120 || SHOULD || 8.1.2.1 || Send a Connection header with token close if we want to close the client side connection immediately after sending the response || unknown || ||
|| || || 121 || MAY || 8.1.2.1 || expect a connection to remain open - but decide based on the server response (does it have a connection header with token close)? || unknown || ||
|| || || 122 || SHOULD || 8.1.2.1 || send a Connection header with token close if we want to only send one request and then close the server side connection || unknown || ||
|| || || 123 || SHOULD NOT || 8.1.2.1 || assume a persistent connection is maintained for pre-HTTP/1.1 versions unless it is explicitly signlaed. || unknown || ||
|| || || 124 || MUST || 8.1.2.1 || always create messages with self-defined message lengths || unknown || ||
|| || || 125 || MAY || 8.1.2.2 || pipeline requests to upstream servers || unknown || ||
|| || || 126 || MUST || 8.1.2.2 || send reponses to pipelined requests in the order that the requests were received || unknown || ||
|| || || 127 || SHOULD || 8.1.2.2 || if we assume persistent connections to servers, and pipeline immediately after connection, be prepared to retry the connection if the first pipelined attempt fails || unknown || ||
|| || || 128 || MUST NOT || 8.1.2.2 || when retrying a failed (if we assume persistent connections to servers, and pipeline immediately after connection, be prepared to retry the connection if the first pipelined attempt fails) pipeline before we know the connection is persistent || unknown || ||
|| || || 129 || MUST || 8.1.2.2 || be prepared to resend requests if a server closes the connection before sending all the pipelined requests || unknown || ||
|| || || 130 || SHOULD NOT || 8.1.2.2 || pipeline non idempotent methods or non-idempotent sequences of methods. || unknown || ||
|| || || 131 || SHOULD || 8.1.2.2 || wait to send non-idempotent requests after receiving the reponse status for the previous request || unknown || note: this may be a non-issue for us. ||
|| || || 132 || recommendation || 8.1.3 || implement the Connection header field properly || unknown || ||
|| || || 133 || MUST || 8.1.3 || signal persistent connections separately with clients and upstream servers || unknown || ||
|| || || 134 || MUST NOT || 8.1.3 || establish a HTTP/1.1 persistent connection with a HTTP/1.0 client || unknown || ||
|| || || 135 || SHOULD || 8.1.4 || issue a graceful close on the transport connection when timing out persistent connections || unknown || ||
|| || || 136 || SHOULD || 8.1.4 || watch persistent connections for close signals and respond to it as appropriate || unknown || ||
|| || || 137 || MAY || 8.1.4 || close any connection at any time. || unknown || ||
|| || || 138 || MUST || 8.1.4 || be able to recover from asynchronous close events. || unknown || ||
|| || || 139 || SHOULD || 8.1.4 || after an asynchronous close event reopen the transport connection and retransmit the aborted sequence automatically as long as the request is idempotent || unknown || ||
|| || || 140 || MUST NOT || 8.1.4 || after an asynchronous close event reopen the transport connection and retransmit the aborted sequence automatically if the request is non-idempotent || unknown || ||
|| || || 141 || SHOULD || 8.1.4 || always respond to at least one request per connection if possible || unknown || ||
|| || || 142 || SHOULD NOT || 8.1.4 || close a connection in the middle of transmitting a response, unless network or client failure is suspected || unknown || ||
|| || || 143 || SHOULD || 8.1.4 || for the client program - limit the number of silmutaneous connections maintained to a given server. || unknown || ||
|| || || 144 || SHOULD NOT || 8.1.4 || for the client program - maintain more than 2 connections with any given server or proxy || unknown || ||
|| || || 145 || SHOULD || 8.1.4 || for the proxy - use up to 2*N with another server or proxy, when N is the number of simultaneous connected active users || unknown || ||
|| || || 146 || SHOULD || 8.2.1 || maintain persistent connections and use TCP flow control to resolve link congestion rather than terminating connections abruptly || unknown || ||
|| || || 147 || SHOULD || 8.2.2 || when sending message-bodies monitor the net connection for error's. || unknown || ||
|| || || 148 || SHOULD || 8.2.2 || when sending message-bodies and a net error is detected immediately cease transmitting the body. || unknown || ||
|| || || 149 || MAY || 8.2.2 || when sending message-bodies using "chunked" encoding and a net error is detected immediately cease transmitting the body & mark the termination with a zero length chunk and an empty trailer || unknown || ||
|| || || 150 || MUST || 8.2.2 || when sending message-bodies preceded by a content-length header and a net error is detected immediately cease transmitting the body and close the connection || unknown || ||
|| || || 151 || MUST || 8.2.3 || for the client program - if waiting for 100 before sending the request body send an Expect request-header with the "100-continue" expectation || unknown || ||
|| || || 152 || MUST NOT || 8.2.3 || for the client program - send an Expect request-header with the "100-continue" expectation if we do not intend to send a request body || unknown || ||
|| || || 153 || SHOULD NOT || 8.2.3 || for the client program - if waiting for 100 before sending the request body, do not wait for an indefinate period before sending the request body || unknown || ||
|| || || 154 || MUST || 8.2.3 || for the squid 'server' - when we receive a request with an Expect request-header with the 100-continue expectation, respond with status 100 and continue reading from the input stream, or response with a final status code || unknown || ||
|| || || 155 || MUST NOT || 8.2.3 || for the squid 'server' - when we receive a request with an Expect request-header with the 100-continue expectation, wait for the request body before sending the 100 response. || unknown || ||
|| || || 156 || MAY || 8.2.3 || for the squid 'server' - when we receive a request with an Expect request-header with the 100-continue expectation and send a final status code, close the transport connection || unknown || ||
|| || || 157 || MAY || 8.2.3 || for the squid 'server' - when we receive a request with an Expect request-header with the 100-continue expectation and send a final status code, finish reading the request (and discard it) || unknown || ||
|| || || 158 || MUST NOT || 8.2.3 || for the squid 'server' - when we receive a request with an Expect request-header with the 100-continue expectation and send a final status code, finish reading the request and perform the requested method || unknown || ||
|| || || 159 || SHOULD NOT || 8.2.3 || for the squid 'server' - send a 100 continue status if the request header does not include an Expect request header with the 100-continue expectation || unknown || ||
|| || || 160 || MUST NOT || 8.2.3 || for the squid 'server' - send a 100 continue status if the request comer from a pre HTTP/1.1 client. || unknown || ||
|| || || 161 || MAY || 8.2.3 || for the squid 'server' - send a 100 continue status in response to a (only) HTTP/1.1 PUT or POST request that does not include an expect header with the 100-continue expectation || unknown || ||
|| || || 162 || MAY || 8.2.3 || for the squid 'server' - omit a 100 continure status if some or all of the request body has already been received || unknown || ||
|| || || 163 || MUST || 8.2.3 || for the squid 'server' - send a final status code after one or more 100 codes, unless the transport connection is terminated prematurely || unknown || ||
|| || || 164 || SHOULD NOT || 8.2.3 || for the squid 'server' - close the transport connection we are receiving a request body on until the entire request is read or the client closes the connection even if we have already sent a final status code || unknown || ||
|| || || 165 || MUST || 8.2.3 || when receiving a request with an Expect header with the 100-continue expectation and the next-hop server is HTTP/1.1 or higher, or version unknown, forward the request including the Expect header field || unknown || ||
|| || || 166 || MUST NOT || 8.2.3 || when receiving a request with an Expect header with the 100-continue expectation and the next-hop server is HTTP/1.0 or lower, forward the request || unknown || ||
|| || || 167 || MUST || 8.2.3 || when receiving a request with an Expect header with the 100-continue expectation and the next-hop server is HTTP/1.0 or lower respond with 417 status || unknown || ||
|| || || 168 || SHOULD || 8.2.3 || cache the http version of recently access next hop servers || unknown || ||
|| || || 169 || MUST NOT || 8.2.3 || forward a 100 reponse if the request was received from a HTTP/1.0 or earlier client and did not include an expect header field with the 100 continue expectation || unknown || ||
|| || || 170 || SHOULD || 8.2.4 || retry requests sent when the connection closes before receiving any status from the server AND there was a request body AND the request did not have an Expect field with expectation 100-continue AND we are not "directly connected to an HTTP/1.1 origin server" || unknown || I don't know what the the "directly.. Really means" ||
|| || || 171 || MAY || 8.2.4 || Time "retry requests sent when the connection closes before receiving any status from the server AND there was a request body AND the request did not have an Expect field with expectation 100-continue AND we are not "directly connected to an HTTP/1.1 origin server" " witha  binary exponential backoff algorithm || unknown || ||
|| || || 172 || SHOULD NOT || 8.2.4 || continue retring requests as per rfc 8.2.4 when an error status is received || unknown || ||
|| || || 173 || SHOULD || 8.2.4 || close the connection if the request has not completed sending when we are (retrying requests as per rfc 8.2.4 when an error status is received) || unknown || ||
|| || || 174 || MUST || 9 || send the Host request-header field with ALL HTTP/1.1 requests || unknown || ||
|| || || 175 || SHOULD NOT || 9.1.1 || use GET and HEAD methods for anything other than retrieval (no side effects by squid) || unknown || ||
|| || || 176 || SHOULD NOT || 9.1.2 || have side effects caused when receiving requests to squid with OPTIONS or TRACE as the method || unknown || ||
|| || || 177 || MUST NOT || 9.2 || cache the results from an OPTIONS request || unknown || ||
|| || || 178 || MUST || 9.2 || for the client program - include a content type field when sending an OPTIONS request with an entity body || unknown || ||
|| || || 179 || MAY || 9.2 || for the squid 'server' - discard the request body from OPTIONS requests || unknown || ||
|| || || 180 || SHOULD || 9.2 || 200 responses to the method OPTIONS should include any header fields that indicate optional features implemented by the server and applicable to that resource (eg Allow) || unknown || ||
|| || || 181 || SHOULD || 9.2 || 200 responses to the method OPTIONS with a  message body should include information about the communications options || unknown || ||
|| || || 182 || MAY || 9.2 || use content-negotiation to select the format for information about the message body in 200 responses to the method OPTIONS || unknown || ||
|| || || 183 || MUST || 9.2 || include a Content-length header value of 0 or a reponse body in 200 responses to the method OPTIONS || unknown || ||
|| || || 184 || MAY || 9.2 || for the client program - use the Max-Forwards request-header to target a specific proxy in the request chain. || unknown || ||
|| || || 185 || MUST || 9.2 || check for a Max-Forwards field when squid recieves an OPTIONS request on an absoluteURI for which request forwarding is permitted || unknown || ||
|| || || 186 || MUST NOT || 9.2 || forward a request with a Max-Forwards field when squid recieves an OPTIONS request on an absoluteURI for which request forwarding is permitted and the value of Max-Forwards is 0. || unknown || ||
|| || || 187 || SHOULD || 9.2 || response with Squids communications options to an OPTIONS request with a Max-Forwards field on an absoluteURI for which request forwarding is permitted and the value of Max-Forwards is 0. || unknown || ||
|| || || 188 || MUST || 9.2 || decrement the Max-Forwards field-value when forwarding an OPTIONS request with a Max-Forwards field on an absoluteURI for which request forwarding is permitted and the value of Max-Forwards is a non zero integer. || unknown || ||
|| || || 189 || MUST NOT || 9.2 || add a Max-Forwards header to an OPTIONS request if non is present when squid recieves it || unknown || ||
|| || || 190 || MUST NOT || 9.3 || cache a GET response if it does not meet the HTTP caching requirements from rfc 2616 section 13 || unknown || ||
|| || || 191 || MUST NOT || 9.4 || for the squid 'server' - generate a message-body in HEAD responses || unknown || ||
|| || || 192 || SHOULD || 9.4 || for the squid 'server' - generate identical http headers for a HEAD request to the equivalent GET request. || unknown || ||
|| || || 193 || MAY || 9.4 || update previously cached entities with the headers from a HEAD requests' response || unknown || ||
|| || || 194 || MUST || 9.4 || mark as stale cached entities where a HEAD requests' response indicate a change in the entity (as indicated by a change in Content-Length, Content-MD5, Etag or Last-Modified) || unknown || ||
|| || || 195 || MUST || 9.5 || follow the section 8.2 message transmission requirements for POST requests || unknown || ||
|| || || 196 || MUST NOT || 9.5 || cache POST responses unless they include appropriate cache-control or Expires headers || unknown || ||
|| || || 197 || SHOULD || 9.6 || for the squid 'server' - handling PUT requests - I skipped these as the cachmgr interface has not file storage capability || unknown || ||
|| || || 198 || SHOULD || 9.6 || treat any cached entities that match the Request URI of a PUT request as stale || unknown || ||
|| || || 199 || MUST || 9.6 || follow the section 8.2 message transmission requirements for PUT requests || unknown || ||
|| || || 200 || MUST NOT || 9.6 || cache responses to PUT Method requests || unknown || ||
|| || || 201 || SHOULD || 9.7 || for the squid 'server' - handling DELETE requests - I skipped these as the cachmgr interface has not file storage capability || unknown || maybe we could use DELETE squid-server/http///originaluri to allow removal of cached entities via the web? ||
|| || || 202 || SHOULD || 9.7 || treat any cached entities that match the Request URI of a DELETE request as stale || unknown || ||
|| || || 203 || MUST NOT || 9.7 || cache responses to DELETE Method requests || unknown || ||
|| || || 204 || MUST NOT || 9.8 || for the squid client - create TRACE requests with an entity || unknown || ||
|| || || 205 || SHOULD || 9.8 || reflect back to the client the TRACE message received (when the Max-forwards value is 0) as the entity-body of a 200 response. The entity body is to have content type message/http || unknown || ||
|| || || 206 || MUST NOT || 9.8 || cache responses to TRACE Method requests || unknown || ||
|| || || 207 || MUST NOT || 10.1 || for the squid 'server' - send 1xx response codes to < HTTP/1.1 clients || unknown || ||
|| || || 208 || MUST || 10.1 || for the client - be prepared to accept one or more 1xx status responses prior to a regular response, even if the client does not expect a 100 status message || unknown || ||
|| || || 209 || MUST || 10.1 || forward 1xx responses unless the connection squid-client has been closed, or squid requested the generation of the 1xx response. (I.e, squid added expect: 100-continue then squid does not need to forward the 100 response || unknown || ||
|| || || 210 || SHOULD || 10.1.1 || for the client when getting a 100-continue reponses should continue with the request or ignore if the request has been completed. || unknown || ||
|| || || 211 || MUST || 10.1.1 || for the squid 'server' - send a final reponse after handling the request || unknown || ||
|| || || 212 || SHOULD || 10.1.2 || only upgrade protocols when it is advantageous to do so. || unknown || ||
|| || || 213 || MUST || 10.2.2 || for the squid 'server' - handling PUT requests - I skipped these as the cachmgr interface has not file storage capability || unknown || ||
|| || || 214 || MUST || 10.2.5 || teminate 204 responses by the first empty line after the header field || unknown || ||
|| || || 215 || MUST NOT || 10.2.6 || include entities in 205 responses || unknown || ||
|| || || 216 || MUST NOT || 10.2.7 || combine 206 responses with older content for the same entity unless the Etag or Last-Modified headers match exacly || unknown || ||
|| || || 217 || MUST NOT || 10.2.7 || cache 206 reponses unless we support Range and Content-Range headers || unknown || ||
|| || || 218 || MUST || 10.2.7 || include the following headers in 206 reponses downstream - Content-Range or a multipart/byteranges content-type with content-range for each part.; Date ; Etag and/or Content-Location; Expires/cache0control and/or vary if the field value might differ from that send in any previous request for the same variant || unknown || ||
|| || || 219 || MUST || 10.2.7 || 206 responses to requests with if-range & strong validator - should not have other entity headers; if-range and weak validator - MUST NOT have other entity headers; other wise include all entity headers a 200 response would have given to the same request || unknown || ||
|| || || 220 || SHOULD || 10.3.2 || cache 301 responses unless otherwise indicated || unknown || ||
|| || || 221 || MUST NOT || 10.3.2 || cache 301 responses to requests other than GET or HEAD || unknown || ||
|| || || 222 || MUST NOT || 10.3.3 || cache 302 responses unless indicated by a Cache-Control or Expires header || unknown || ||
|| || || 223 || MUST NOT || 10.3.3 || cache 302 responses to requests other than GET or HEAD || unknown || ||
|| || || 224 || MUST NOT || 10.3.4 || cache 303 responses || unknown || ||
|| || || 225 || MUST || 10.3.5 || for the squid 'server' - in 304  responses include the Date (unless rfc 2616 ection 14.18.1 requires its omission); Etag and/or Content-Location (if a 200 response to same would have those fields); Expires, Cache-Control and/or Vary if the field value might differ from that sent in any previous request || unknown || ||
|| || || 226 || MUST || 10.3.5 || when a 304 response indicates a not-currently-cached entity, disregard the response and repeat the request with no conditions || unknown || ||
|| || || 227 || MUST || 10.3.5 || when a 304 response is received for a currently cached entity, update the entry with new field values given in the response || unknown || ||
|| || || 228 || MUST || 10.3.6 || when a 305 response is received, repeat that _single_ request via the proxy in 'Location' || unknown || note: is this mean for squid to do , or only for the client? What about clients behind firewalls that can only use squid? ||
|| || || 229 || MUST NOT || 10.3.6 || generate 305 responses except from the squid 'server' || unknown || ||
|| || || 230 || MUST NOT || 10.3.7 || use the 306 status code || unknown || ||
|| || || 231 || SHOULD NOT || 10.4.1 || retry requests where 400 was returned unless the client retries || unknown || ||
|| || || 232 || SHOULD NOT || 10.4.4 || retry requests where 403 was returned || unknown || ||
|| || || 233 || MUST || 10.4.6 || include an Allow header listing valid methods for requests where squid creates a 405 method to the client || unknown || ||
|| || || 234 || MUST || 10.4.8 || return a Proxy-Authenticate header containing a challenge applicable to squid for the requested resource. || unknown || ||
|| || || 235 || MAY || 10.4.9 || retry 408 requests || unknown || ||
|| || || 236 || SHOULD NOT || 10.4.10 || retry 409 responses automatically || unknown || ||
|| || || 237 || SHOULD || 10.4.11 || cache 410 responses || unknown || we should purge cached entity bodies that receive 410 responses. ||
|| || || 238 || MAY || 10.4.12 || automatically retry a request with a Content-Length header in response to a 411 error || unknown || ||
|| || || 239 || MAY || 10.4.12 || return a 411 error to the client if we want to be able to filter easily on put and post requests and the client did not use a Content-Length header || unknown || ||
|| || || 240 || MAY || 10.4.14 || return a 413 error when the request entity is too large. || unknown || ||
|| || || 241 || SHOULD || 10.4.14 || When returning a 413 error when the request entity is too large and it is a time based (or temporary) restriction, include a Retry-After header indicating when it should be ok || unknown || ||
|| || || 242 || SHOULD || 10.4.18 || return 417 when we have unambigous evidence that the expectation given in a request can not be met by the next hop server || unknown || ||
|| || || 243 || SHOULD || 10.5 || include an entity body when we create 5xx error reponses explaining the issue (other than to HEAD requests) || unknown || ||
|| || || 244 || SHOULD || 10.5.2 || return a 501 if we don't implement a given method and can't just proxy it an hope || unknown || ||
|| || || 245 || SHOULD || 10.5.3 || return a 502 if we get an invalid upstream response || unknown || ||
|| || || 246 || SHOULD || 10.5.4 || return a 503 if we are overloaded, or unable to serve requests due to maintenance. || unknown || ||
|| || || 247 || MAY || 10.5.4 || return a Retry-After when returning a 503 if we are overloaded, or unable to serve requests due to maintenance. (the header would indicate when the maintenance should finish || unknown || ||
|| || || 248 || SHOULD || 10.5.5 || return a 504 on an upstream timeout, or timeout on an auxilary server - ie DNS/authentication helper || unknown || nb we may be returning 400 or 500 presently ||
|| || || 249 || MUST || 10.5.6 || return a 505 if we don't support, (or have #defed it out) the HTTP major version in the request message || unknown || ||
|| || || 250 || OPTIONAL || 11 || implement basic and or digest authentication || unknown || ||
|| N || Y || 251 || MAY || 12 || use content-negotiation on any entity body request/response - ie in selecting what language the error should be in || || 3.1 and later ||
|| || || 252 || MAY || 12.1 || for the squid client - include request header fields (Accept, Accept-Language, Accept-Encoding etc) in requests || unknown || ||
|| || || 253 || MAY || 12.3 || develop transparent negotiation capabilities within HTTP/1.1 || unknown || ||
|| || || 254 || recommendation || 13 || Note: The server, cache, or client implementor might be faced with design decisions not explicitly discussed in this specification. If a decision might affect semantic transparency, the implementor ought to err on the side of maintaining transparency unless a careful and complete analysis shows significant benefits in breaking transparency. || unknown || ||
|| || || 255 || MUST || 13.1.1 || respond to a request with the most up-to-date response held by squid which is appropriate to the request (see 13.2.5,13.2.6,13.12) and meets one of : 1) it has been revalidated with the origin, 2) it is "fresh enough (see 13.12) & 14.9 or 3) it is an appropriate 304/305/ 4xx/5xx response || unknown || ||
|| || || 256 || MAY || 13.1.1 || If a stored response is not "fresh enough" by the most restrictive freshness requirement of both the client and the origin server, in carefully considered circumstances the cache MAY still return the response with the appropriate Warning header (see section 13.1.5 and 14.46), unless such a response is prohibited (e.g., by a "no-store" cache-directive, or by a "no-cache" cache-request-directive; see section 14.9). || unknown || ||
|| || || 257 || SHOULD || 13.1.1 || forward received responses even if the response itself is stale without adding a new Warning header || unknown || ||
|| || || 258 || SHOULD NOT || 13.1.1 || attempt to revalidate responses that become stale in transit to squid || unknown || ||
|| || || 259 || SHOULD || 13.1.1 || respond as per the 13.1.1 respond rules even if the origin server cannot be contacted. || unknown || ||
|| || || 260 || MUST || 13.1.1 || return an error or warning to the client if the origin server can't be contacted, and no response can be served under the 13.1.1 rules || unknown || ||
|| || || 261 || MUST || 13.1.2 || attach a warning noting when returning a response that is neither first-hand nor "fresh enough" using the Warning header || unknown || ||
|| || || 262 || MUST || 13.1.2 || delete 1xx warnings from cached responses after successful revalidation || unknown || ||
|| || || 263 || MAY || 13.1.2 || generate 1xx warnings when validating a cached entry || unknown || ||
|| || || 264 || MUST NOT || 13.1.2 || delete 2xx warning from cached responses after successful revalidation || unknown || ||
||  ||  || 265 || MAY || 13.1.2 || choose the warning text description language (perhaps based on Accept headers) ||
|| || || 266 || MAY || 13.1.2 || allow/create responses with multiple warnings, including multiple warnings with the same code || unknown || ||
|| || || 267 || recommendation || 13.1.3 || use the most restrictive interpretation of caching issue /spec conflicts || unknown || ||
|| Y || Y || 268 || MAY || 13.1.5 || have squid configurable to return stale responses even when not requested by clients ||
|| || || 269 || MUST || 13.1.5 || mark stale responses with a Warning header || unknown || ||
|| || || 270 || SHOULD NOT || 13.1.5 || return a stale response if the client explicitly requests a first-hand or fresh one, unless technical or policy reasons require returning a stale response || unknown || ie: offline mode, refresh to IMS are allowed but MUST require deliberate configuration by the admin ||
|| || || 271 || SHOULD || 13.2.3 || be running on a host that uses NTP or equivalent for clock synchronization || na || ||
|| || || 272 || MUST || 13.2.3 || calculate corrected_received_age as max(now-date_value, age_value) || unknown || ||
|| || || 273 || MUST || 13.2.3 || interpret Age header values (age_value) relative to the time the request was initiated, not the response time. || unknown || ||
|| || || 274 || MUST || 13.2.3 || calculate corrected_initial_age as corrected_received_age +(now - request_time) ; request_time = time the request was sent upstream || unknown || ||
|| || || 275 || MUST || 13.2.3 || when sending responses from cached entries include a single Age header with a value equal to current_age (as per 13.2.3 algorithm) || unknown || ||
|| || || 276 || MAY || 13.2.4 || compute freshness lifetime using a heuristic IFF the response has no caching restrictions AND no Expires, Cache-Control: Max-age, Cache-Control: s-maxage exist in the response || unknown || ||
|| || || 277 || MUST || 13.2.4 || attach a Warning 113 to any response when the age_value is more than 24 hours if there is no 113 warning already || unknown || ||
|| || || 278 || SHOULD || 13.2.4 || use heuristics that use a fraction of the last-modified time (if it exists) - suggested setting of 10% since last-modified || unknown || ||
|| || || 279 || MUST || 13.2.5 || when two responses exist for a given representation with different validators, use the one with the more recent Date header. || unknown || ie don't naively assume an incoming response is newer than the entity it is a refresh for ||
|| || || 280 || SHOULD || 13.2.6 || When a revalidation occurs and the responses date header is older than the existing entry, repeat the request unconditionally, with the header Cache-Control: max-age=0 or Cache-Control: no-cache || unknown || note this is specced as a client requirement - but we have to implement client code as well. Does squid need to do this or let the client do it?? ||
|| || || 281 || MUST NOT || 13.3.3 || use a weak validator in anything other than simple (non-subrange) GET requests || unknown || ||
|| || || 282 || MUST || 13.3.3 || consider two validators strongly equal IFF both validators are identical, and both are NOT weak || unknown || ||
|| || || 283 || MUST || 13.3.3 || consider two validators weakly equal IFF both validators are identical, and one or both are NOT strong || unknown || ||
|| || || 284 || MUST || 13.3.3 || consider Last-Modified to be a weak validator unless we are comparing it with a cached last-modified date, and the cache entry includes a Date value, and the last-modified is at least 60 seconds before the data value || unknown || ||
|| || || 285 || MUST || 13.3.3 || when receiving conditional requests the use strong comparison (no weak compares allowed) || unknown || ||
|| || || 286 || MUST NOT || 13.3.4 || return 304 to a conditional request that includes both a last-modified (eg in a IMS or IUS header) and one or more entity tags (eg If-match / IF-None-Match/If-Range) unless the 304 is consistent with all the conditionals present in the request || unknown || ||
|| || || 287 || MUST NOT || 13.3.4 || return a locally cached response to a conditional request that includes both Last-Modified and one or more entity tags as validators unless the cached response is consistent with all present conditionals in the request || unknown || ||
|| || || 288 || MUST NOT || 13.3.5 || use other headers than entity tags and Last-Modified for validation || unknown || ||
|| || || 289 || MAY || 13.4 || always cache a successful response (unless constrained by 14.9) || unknown || ||
|| || || 290 || MAY || 13.4 || return cached responses without validation while fresh (unless constrained by 14.9) || unknown || ||
|| || || 291 || MAY || 13.4 || return cached responses after succesful validation (unless constrained by 14.9) || unknown || ||
|| || || 292 || MAY || 13.4 || cache responses with no validator or expiration time, but shouldn't do so in normal conditions || unknown || ||
|| || || 293 || MAY || 13.4 || cache and use as replies, responses with status codes 200, 203, 206, 300, 301 or 410 (subject to expiration & cache-control mechanisms) || unknown || ||
|| || || 294 || MUST NOT || 13.4 || return responses to status codes other than (200, 203, 206, 300, 301 or 410) in a reply to subesquent requests unless there are cache-control directives that explicitly allow it (eg Expires/ a max-age ,  s-maxage, must-revalidate, proxy-revalidate, puvlic or private cache-control header || unknown || ||
|| || || 295 || MUST || 13.5.1 || store end to end headers (headers other than Connection; Keep-Alive ; Proxy-Authenticate ; Proxy-Authorization ; TE ; Trailers ; Transfer-Encoding ; Upgrade) with the cached response || unknown || ||
|| || || 296 || MUST || 13.5.1 || transmit cached end to end headers in any response fromed from that cache entry || unknown || ||
|| || || 297 || MUST || 13.5.1 || list newly defined hop to hop headers under the connection header || unknown || ||
|| || || 298 || SHOULD NOT || 13.5.2 || modify end to end headers unless the definition of that header specifically allows or requires its modification || unknown || ||
|| || || 299 || MUST NOT || 13.5.2 || as a transparent proxy; modify (Content-Location; Content-MD5;- Etag; Last-Modified; Expires) headers in a request or response || unknown || ||
|| || || 300 || MAY || 13.5.2 || as a transparent proxy; add an Expires header if not already present in a reponse, and MUST give it the same value as the Date header of that response || unknown || ||
|| || || 301 || MUST NOT || 13.5.2 || as a transparent proxy; add (Content-Location; Content-MD5;- Etag; Last-Modified) headers in a request or response || unknown || ||
|| || || 302 || MAY || 13.5.2 || as a non-transparent proxy; modify or add (Content-Location; Content-MD5;- Etag; Last-Modified; Expires) headers in a request or response that does not include "no-transform" || unknown || ||
|| || || 303 || MUST || 13.5.2 || add a warning 214 (if not already present) if we choose to as a non-transparent proxy; modify or add (Content-Location; Content-MD5;- Etag; Last-Modified; Expires) headers in a request or response that does not include "no-transform" || unknown || ||
|| || || 304 || MUST || 13.5.2 || as a transaprent proxy; preserve the entity-length of the entity body in a response/request || unknown || ||
|| || || 305 || MAY || 13.5.2 || as a transaprent proxy; change the preserve the transfer-length in a response/request || unknown || ||
|| || || 306 || MAY || 13.5.3 || combine 206 responses with cached content for the same entity as long as the Etag or Last-Modified headers match exactly || unknown || ||
|| || || 307 || MUST || 13.5.3 || update any end-end headers in cache entries with those from a 304 or 206 response or remove the cache entry || unknown || ||
|| || || 308 || MUST || 13.5.3 || when combining 206 responses with cached content, remove Warning 1xx headers, retain warning 2xx headers, and use the 206 responses end to end headers in preference to the cached headers || unknown || ||
|| || || 309 || MAY || 13.5.4 || combine byte ranges if both the incoming response and the cache entry have validotrs, and the validators match using the strong comparison || unknown || ||
|| || || 310 || MUST || 13.5.4 || if a subrange response is received, and with either the incoming response or the cache entry has no validator, or the validators do no compare strongly, only use the most recent (check Date header else the incoming response) partial response and discard the previous partial information || unknown || ||
|| || || 311 || MUST NOT || 13.5.6 || use a cache entry to construct a response to a request when the response had a Vary header, unless all the listed (by the vary field) request headers match the corresponding cached request headers (match by transforming by insertion of LWS as allowed by the BNF's and or combining message-header fields with the same name as per 4.2 || unknown || ||
|| || || 312 || MUST NOT || 13.5.6 || use a cache entry to construct a response to a request when the response had a Vary header of * without validation by the origin server || unknown || ||
|| || || 313 || SHOULD || 13.5.6 || if an entity tag is assigned to a cached representation, the forwarded request should be conditional and include the entity tags in an If-None-Match header field from _all_ the cache entries for the resource || unknown || ||
|| || || 314 || SHOULD NOT || 13.5.6 || include the entity-tag for a cache entry that only contains partial content in the If-None-Match header unless the request could be satisfied from the cache || unknown || ||
|| || || 315 || SHOULD || 13.5.6 || delete cache entries when a successful response with a matching Content-Location field, a differing entity-tag and a more recent Date || unknown || ||
|| || || 316 || SHOULD NOT || 13.5.6 || use cache entries when a successful response with a matching Content-Location field, a differing entity-tag and a more recent Date to satisfy requests || unknown || ||
|| || || 317 || MAY || 13.8 || store incomplete responses || unknown || ||
|| || || 318 || MUST || 13.8 || treat incomplete responses as partial responses || unknown || ||
|| || || 319 || MUST NOT || 13.8 || return a partial response to a client without marking it as such (using 206 status code) || unknown || ||
|| || || 320 || MUST NOT || 13.8 || return a partial response to a client with status 200 || unknown || ||
|| || || 321 || MAY || 13.8 || forward 5xx responses received while revalidating entries to the client, or act as if the server failed to respond || unknown || ||
|| || || 322 || MAY || 13.8 || when a server fails to respond, return a cached response unless the cached entry inludes the must-revalidate cache-control directive || unknown || ||
|| || || 323 || MUST NOT || 13.9 || treat GET and HEAD requests with ? In the URI path as fresh UNLESS explicit exipration times are provided in the repsonse || unknown || ||
|| || || 324 || SHOULD NOT || 13.9 || cache GET and HEAD responses from HTTP/1.0 servers with ? In the URI path || unknown || ||
|| || || 325 || MUST || 13.10 || invalidate entities referred to by the Content-Location header;Location header or the Request-URI in PUT/DELETE and POST requests. This is only done for the same host hwn using the Content-Locaiton and Location headers || unknown || ||
|| || || 326 || SHOULD || 13.10 || invalidate entities referred to by the Request-URI in non understood methods if we pass them upstream || unknown || ||
|| || || 327 || MUST || 13.11 || pass upstream all methods that may cause alterations to the origin servers resources. (This means all Methods other than GET and HEAD) || unknown || ||
|| || || 328 || MUST NOT || 13.11 || respond to a client on all methods that may cause alterations to the origin servers resources. (This means all Methods other than GET and HEAD) before the reponse from the server arrives. || unknown || ||
|| || || 329 || MAY || 13.11 || respond to a client with a 100 on all methods that may cause alterations to the origin servers resources. (This means all Methods other than GET and HEAD) before the reponse from the server arrives. || unknown || ||
|| || || 330 || SHOULD || 13.12 || when a new response to an existing cached resource arrives, use the new response to reply to the current request || unknown || ||
|| || || 331 || MAY || 13.12 || when a new response to an existing cached resource arrives, update the cache with the new response || unknown || ||
|| || || 332 || MAY || 13.12 || when a new response to an existing cached resource arrives, use it to respond to future requests as appropriate || unknown || ||
|| || || 333 || MAY || 14.1 || include parameters for media types that support them || unknown || ||
|| || || 334 || MAY || 14.1 || include accept-params for media types. (q=0 to q=1) (see 3.9) || unknown || ||
|| || || 335 || SHOULD || 14.1 || for the squid 'server' send 406 if we cannot get an acceptable media type for the client request || unknown || ||
|| || || 336 || MAY || 14.2 || have q values for charsets || unknown || ||
|| || || 337 || SHOULD || 14.2 || for the squid 'server' send 406 if we cannot get an acceptable charset for the client request || unknown || ||
|| || || 338 || MAY || 14.3 || have q values for content-coding || unknown || ||
|| || || 339 || SHOULD || 14.3 || for the squid 'server' send 406 if we cannot get an acceptable content-coding for the client request. Note this is not transfer-coding so we do cannot do this on the fly for the cache || unknown || ||
|| || || 340 || MAY || 14.3 || assume the client will accept any content coding when no Accept-Encoding header is presented || unknown || ||
|| || || 341 || SHOULD || 14.3 || for the squid 'server' send identity content-coding when no Accept-Encoding header is presented || unknown || ||
|| N/A || N/A || 342 || MAY || 14.4 || have q values for preferred language ||
|| Y || Y || 343 || SHOULD || 14.4 || assume all languages are ok when there is no header ||
|| || || 344 || MAY || 14.5 || for the squid  'server' send  Accept-ranges: none to tell clients not to attempt range requests || unknown || ||
|| || || 345 || MUST || 14.6 || when an age header we receive is larger than our largest integer, or if an Age calculation overflows, transmit age of 2147483648 (2^31). || unknown || ||
|| || || 346 || SHOULD || 14.6 || use integers of at least 31 bits || unknown || ||
|| || || 347 || MUST || 14.7 || present an Allow header in 405 responses || unknown || ||
|| || || 348 || MUST NOT || 14.7 || modify the allow header || unknown || ||
|| || || 349 || SHOULD || 14.8 || have a set of credentials valid for an entire realm (including all sub-resources) (ie for web-accel operation) || unknown || ||
|| || || 350 || MUST NOT || 14.8 || return responses with Authorization headers to other requests unless a) cache-control: s-maxage is present or b) cache-control: must-revalidate is presented or c) cache-control: public is present || unknown || ||
|| || || 351 || MUST || 14.8 || always revalidate responses with cache-control: s-maxage=0 || unknown || ||
|| || || 352 || MUST || 14.9 || follow the cache-control header directives at all times || unknown || ||
|| || || 353 || MUST || 14.9 || pass cache-control directives through to the next link in the message path (ie don't eat them) || unknown || ||
|| || || 354 || MAY || 14.9.1 || cache responses with cache-control: public even of the header/method might not normally be cacheable || unknown || ||
|| || || 355 || MUST NOT || 14.9.1 || cache responses with cache-control: private || unknown || ||
|| || || 356 || MUST NOT || 14.9.1 || use responses with cache-control: no-cache to satisfy other requests without successful revalidation || unknown || ie auto GET to IMS is allowed ||
|| || || 357 || MAY || 14.9.1 || use responses with cache-control: no-cache to satisfy other requests without successful revalidation if the no-cache directive includes field-names || unknown || ||
|| || || 358 || MUST NOT || 14.9.1 || send the headers listed in responses with cache-control: no-cache (header…) to satisfy other requests without successful revalidation if the no-cache directive includes field-names || unknown || ||
|| || || 359 || MAY || 14.9.2 || use no-store on requests or responses to prevent data storage || unknown || ||
|| || || 360 || MUST NOT || 14.9.2 || store any part of a request or it's response if the cache-control: no-store directive was in the request || unknown || This directive applies to both non-shared and shared caches. "MUST NOT store" in this context means  that the cache MUST NOT intentionally store the information in  non-volatile storage, and MUST make a best-effort attempt to remove the information from volatile storage as promptly as possible after forwarding it. ||
|| || || 361 || MUST NOT || 14.9.2 || store any part of a response or the request that elicited it if the cache-control: no-store directive was in the response || unknown || This directive applies to both non-shared and shared caches. "MUST NOT store" in this context means  that the cache MUST NOT intentionally store the information in  non-volatile storage, and MUST make a best-effort attempt to remove the information from volatile storage as promptly as possible after forwarding it. ||
|| || || 362 || SHOULD || 14.9.3 || consider responses with an Expires value that is <= the response date and no cache-control header field to be non-cacheable || unknown || ||
|| || || 363 || MUST || 14.9.3 || mark stale responses with Warning 110 || unknown || ||
|| || || 364 || MAY || 14.9.3 || have squid configurable to return stale responses even when not requested by clients but responses served MUST NOT conlict with other MUST or MUST NOT requirements || unknown || ||
|| || || 365 || MUST NOT || 14.9.4 || use a cached copy to respond to a request with cache-control: no-cache or Pragma: no-cache || does now || ||
|| || || 366 || SHOULD || 14.9.4 || response with a cached copy (if possible) or a 504 to a request with cache-control: only if cached. Note we can use a cache farm to get the cached copy || unknown || ||
|| || || 367 || MUST NOT || 14.9.4 || use stale responses marked with cache-control: must-revalidate after it becomes stale without first revalidating it with the origin || unknown || ||
|| || || 368 || MUST || 14.9.4 || obey the must-revalidate directive at all times || unknown || ||
|| || || 369 || MUST || 14.9.4 || return 504 if a must-revalidate directive would need access to an unavailable origin server || unknown || ||
|| || || 370 || MUST NOT || 14.9.5 || change any headers (or part of the request specified by those headers) from section 13.5.2 when a message with cache-control: no-transform is received || unknown || ||
|| || || 371 || MUST || 14.9.6 || ignore unrecognized cache-control headers || unknown || ||
|| || || 372 || MUST || 14.10 || parse the Connection header before a message is forwarded || unknown || ||
|| || || 373 || MUST || 14.10 || remove headers from messages that match headers specified in the connection header || unknown || ||
|| || || 374 || MUST NOT || 14.10 || list end to end headers in the connection header || unknown || ||
|| || || 375 || MUST || 14.10 || for applications that do not support persistent connection (ie squid 'server' and client) include Connection: close in every message || unknown || ||
|| || || 376 || MUST || 14.10 || on pre-http/1.1 messages with a connection header, for each connection-token, remove AND ignore and header fields with the same name as the token || unknown || ||
|| || || 377 || MAY || 14.11 || as a NON-TRANSPARENT proxy modify content-coding to be more suitable to a client request || unknown || ||
|| || || 378 || MUST || 14.11 || if the content encoding of an entity is not "identity" || unknown || ||
|| || || 379 || MUST || 14.11 || list in applied order the content codings applied to an entity || unknown || ||
|| N/A || N/A || 380 || MAY || 14.12 || list multiple languages in a Content-Language header if the response is intended for multiple audiences (perhaps a multi-lingual error page?) || || only one language sent ||
|| || || 381 || SHOULD || 14.13 || use and send the Content-Length header unless prohibited by section 4.4 || unknown || ||
|| || || 382 || MUST NOT || 14.15 || generate Content-MD5 headers || unknown || ||
|| || || 383 || MAY || 14.15 || check Content-MD5 headers || unknown || ||
|| || || 384 || MUST || 14.15 || remove transfer-encodings before checking the MD5 || unknown || ||
|| || || 385 || MUST NOT || 14.15 || convert line breaks to CRLF before checking the MD5 || unknown || ||
|| || || 386 || SHOULD || 14.16 || indicate the total length of the full entity body in Content-Range headers || unknown || ||
|| || || 387 || MUST || 14.16 || only specify one range in byte-range-resp-spec || unknown || ||
|| || || 388 || MUST || 14.16 || use absolute byte positions for byte-range-resp-spec values || unknown || ||
|| || || 389 || MUST || 14.16 || ignore invalid byte-range-resp-spec and any content transferred with it || unknown || ||
|| || || 390 || MUST NOT || 14.16 || have response code 206 with a byte-range-resp-spec of * || unknown || ||
|| || || 391 || MUST || 14.18 || assign a Date header if we receive a message without one, || unknown || ||
|| || || 392 || SHOULD || 14.18 || assign the best available approximation of the date and time of message generation when we assign Date headers || unknown || ||
|| || || 393 || MAY || 14.19 || use Entity tags for comparison with other entities from the same resource || unknown || ||
|| || || 394 || MUST || 14.21 || treat invalid Expires headers (NON RFC 1123 format) as being in the past || unknown || ||
|| || || 395 || MAY || 14.22 || log the From header || unknown || ||
|| || || 396 || SHOULD NOT || 14.22 || use the From header for access-control || unknown || ||
|| || || 397 || MUST || 14.23 || for clients: include a Host header in all http/1.1 requests || unknown || ||
|| || || 398 || MUST || 14.23 || for clients: include an empty Host header in all http/1.1 requests when no host name is available || unknown || ||
|| || || 399 || MUST || 14.23 || ensure that all requests forwarded include an appropriate Host header || unknown || ||
|| || || 400 || MUST || 14.23 || respond with 400 to http/1.1 requests missing a Host header || unknown || ||
|| || || 401 || MUST || 14.24 || use the strong comparison when comparing entity tags for If-Match || unknown || ||
|| || || 402 || SHOULD || 14.25 || return a 304 to IMS requests that have not been modified (using cached data if possible) || unknown || ||
|| || || 403 || MUST || 14.31 || check and decrement (if greater than 0) the Max-Forwards header if present in TRACE and OPTIONS requests || unknown || ||
|| || || 404 || MUST || 14.31 || respond as the final recipient if the Max-Forwards header is 0 on a TRACE or OPTIONS request || unknown || ||
|| || || 405 || MAY || 14.31 || ignore the Max-Forwards header for all other methods covered by rfc 2616 || unknown || ||
|| || || 406 || SHOULD || 14.32 || forward requests with Pragme: no-cache upstream even if a cached copy exists || unknown || ||
|| || || 407 || MUST || 14.32 || pass Pragma directives up/downstream in all cases || unknown || ||
|| || || 408 || SHOULD || 14.32 || ignore pragma directives not relevant or understood by us || unknown || ||
|| || || 409 || SHOULD || 14.32 || treat pragme: no-cache as cache-control: no-cache || unknown || ||
|| || || 410 || MUST || 14.33 || include Proxy-Authenticate when sending a 407 response || unknown || note: NTLm auth requires an unrecommended order ||
|| || || 411 || SHOULD NOT || 14.33 || pass Proxy-Authenticate downstrem || unknown || ||
|| || || 412 || MAY || 14.34 || relay credentials from a client upstream to a parent cache (if that is the mechanism by which the two caches cooperatively authenticate a given request) || unknown || ||
|| || || 413 || MAY || 14.35.1 || specify a single byte range or a set of ranges within a single entity with a single byte range operation || unknown || ||
|| || || 414 || MUST || 14.35.1 || have the last-byte-pos value (if present) great than or equal to the first-byte-pos in the byte-range-spec || unknown || ||
|| || || 415 || MUST || 14.35.1 || ignore a header field with an invalid byte-range-spec || unknown || ||
|| || || 416 || SHOULD || 14.35.1 || return 416 if a byte-range-set is unsatisfiable || unknown || ||
|| || || 417 || SHOULD || 14.35.1 || return 206 when returning ranges || unknown || ||
|| || || 418 || MAY || 14.35.2 || for the client - request one or more subranges on conditional or un-conditional GET requests || unknown || ||
|| || || 419 || MAY || 14.35.2 || ignore the range header. || unknown || We should support this, and should look at caching partial responses ||
|| || || 420 || SHOULD || 14.35.2 || only return the requested range to a client even if we get given the entire entity in response to a request containing a range request || unknown || ||
|| || || 421 || SHOULD || 14.35.2 || store the entire response (if we would normally cache that object) if we get given the entire entity in response to a request containing a range request || unknown || ||
|| || || 422 || MUST NOT || 14.36 || for the client - send a referer field if the request-URI was not obtained from a source with it's own URI - ie the keyboard || unknown || ||
|| || || 423 || MAY || 14.37 || use Retry-After to indicate how long a client should wait before requesting the new location || unknown || ||
|| || || 424 || MUST NOT || 14.38 || modify the Server header on forwarded responses || unknown || ||
|| Y || Y || 425 || SHOULD || 14.38 || include a Via header on forwarded responses || || unless admin suppressed ||
|| || || 426 || MUST || 14.39 || include the TE connection token whenever we use TE on a connection || unknown || ||
|| || || 427 || SHOULD NOT || 14.40 || include header fields in the trailer with having sent a Trailer header || unknown || ||
|| || || 428 || MUST NOT || 14.40 || send Transfer-Encoding; Content-Length or Trailer as Trailer field values || unknown || ||
|| || || 429 || MUST || 14.41 || list in the order applied the transfer-encodings applied to a response (ie rsync, gzip || unknown || ||
|| || || 430 || MUST || 14.42 || use the upgrade header in a response with status code 101 || unknown || ||
|| || || 431 || MUST || 14.42 || include the Upgrade connection-token whenever we use the Upgrade header || unknown || ||
|| || || 432 || SHOULD || 14.43 || for the client - include a user-Agent field in requests || unknown || ||
|| || || 433 || SHOULD || 14.44 || include a Vary header on any cacheable response we generate that used server negotiation || unknown || ||
|| || || 434 || MAY || 14.44 || for the 'server' include a vary header with a non-cacheable response the used server negotiation || unknown || ||
|| || || 435 || MAY || 14.44 || assume the same response will be given by a server for future requests with the same request field values as those listed by the vary header in the response whilst the response is still fresh || unknown || ||
|| || || 436 || MUST NOT || 14.44 || generate a * value for a vary field || unknown || ||
|| || || 437 || MUST || 14.45 || fill in the Via header || unknown || ||
|| || || 438 || MAY || 14.45 || replace the host in the via header with a pseudonym for security/privacy || unknown || ||
|| || || 439 || MUST || 14.45 || append our details to the Via header || unknown || ||
|| || || 440 || MAY || 14.45 || remove comments from the via header before forwarding || unknown || ||
|| || || 441 || MAY || 14.45 || put comments in the via header before forwarding || unknown || ||
|| || || 442 || SHOULD NOT || 14.45 || when used as a gateway/ http firewall forward names/hosts/ports of hosts within the firewall || unknown || perhaps a config directive - firewall - turn on several things? ||
|| || || 443 || SHOULD || 14.45 || require explicit enablement of forwarding names/hosts/ports of hosts within the firewall || unknown || perhaps a config directive - firewall - turn on several things? ||
|| || || 444 || SHOULD || 14.45 || replace the received-by host with a pseudonym when used as a gateway/ http firewall forward names/hosts/ports of hosts within the firewall || unknown || ||
|| || || 445 || MAY || 14.45 || for organizations with privacy concerns: collapse multiple protocol-value entries into one entry in the via header || unknown || ||
|| || || 446 || SHOULD NOT || 14.45 || combine multiple entries unless they are all under the same organizations control and the hosts have already been pseudonymized || unknown || ||
|| || || 447 || MUST NOT || 14.45 || combine multiple entries in the via header with different protocol values || unknown || ||
|| || || 448 || MAY || 14.46 || have responses with more than 1 warning header || unknown || ||
|| || || 449 || SHOULD || 14.46 || generate warn-text in the natural language most likely to be intelligble to the user receiving the response || unknown || ||
|| || || 450 || MAY || 14.46 || decide on the language for warnings using ANY available knowledge || unknown || ||
|| || || 451 || MUST || 14.46 || if sending a warning in a charset other than ISO-8859-1 encode it as per rfc 2047 || unknown || ||
|| || || 452 || SHOULD || 14.46 || add new warning headers after existing warning headers || unknown || ||
|| || || 453 || MUST NOT || 14.46 || delete a warning it receives with a given message || unknown || ||
|| || || 454 || SHOULD || 14.46 || remove any warning headers associated with a cached response after successful validation (except as specified for some warning codes) || unknown || ||
|| || || 455 || MUST || 14.46 || add any warning headers received in validation responses to cached responses || unknown || ||
|| || || 456 || MUST || 14.46 || generate warning 110 on stale responses || unknown || ||
|| || || 457 || MUST || 14.46 || generate warning 111 on stale responses sent when revalidation failed || unknown || ||
|| || || 458 || SHOULD || 14.46 || generate warning 112 if we are offline intentionally for any length of time || unknown || ||
|| || || 459 || MUST || 14.46 || generate warning 113 if our heuristic chose a freshness lifetime > 24 hours and the response's age is >24 hours || unknown || ||
|| || || 460 || MAY || 14.46 || include and arbitrary info we want logged or presented to the user in a Warning 199 || unknown || ||
|| || || 461 || MUST || 14.46 || generate warning 214 if we change the content-coding or media-type of the response unless this warning is already in the response || unknown || ||
|| || || 462 || MAY || 14.46 || include and arbitrary info we want logged or presented to the user in a Warning 299 || unknown || ||
|| || || 463 || MUST || 14.46 || include a warn-date that matches the Date in the response in messages sent with warning headers whose version is HTTP/1.0 or lower || unknown || ||
|| || || 464 || MUST || 14.46 || delete warning-values that have a warn-date differing form the Date value in the response || unknown || ||
|| || || 465 || MUST || 14.46 || delete the warning header if it is empty || unknown || ||
|| Y || Y || 466 || MUST || 14.47 || include WWW-Authenticate in 401 responses ||
|| || || 467 || SHOULD || 15.1 || be careful not to disclose personal information of the clients || unknown || ||
|| || || 468 || SHOULD || 15.1.2 || be able to filter/alter the From field when acting as a gateway || unknown || ||
|| || || 469 || SHOULD || 19.3 || assume RC 850 dates more than 50 years in the future are in the past || unknown || ||
|| || || 470 || MAY || 19.3 || internally represent an Expires date as earlier than the proper value, but MUST NOT represent it as later than the proper value || unknown || ||
|| || || 471 || MUST || 19.3 || do date calculations in GMT || unknown || ||
|| || || 472 || MUST || 19.3 || convert HTTP header dates to GMT using the most conservative possible conversion if they are not in GMT || unknown || ||
|| || || 473 || idea || 19.5.1 || sanitize the content-disposition header by removing directory information || unknown || ||


----
 . CategoryFeature
