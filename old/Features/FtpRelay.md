# Feature: Native FTP proxying

  - **Goal**: Apply existing access control and content adaptation
    features to native FTP (port 21) traffic. Build framework for future
    caching of native FTP responses.

  - **Status**: completed.

  - **Version**: 3.5

  - **Developer**:
    [AlexRousskov](/AlexRousskov)
    and Dmitry Kurochkin

  - **More**: lp
    [branch](https://code.launchpad.net/~measurement-factory/squid/ftp-gw);
    squid-dev discussions in
    [August](http://www.squid-cache.org/mail-archive/squid-dev/201208/0178.html)
    and
    [September](http://www.squid-cache.org/mail-archive/squid-dev/201209/0021.html)
    2012

# Functionality

This project adds an ftp_port option to squid.conf. Squid acts as an
FTP-to-FTP gateway for TCP traffic sent to that port:

1.  Squid listens for native FTP requests sent to the configured port.

2.  Squid converts received FTP commands to internal HTTP wrapper
    requests,

3.  Squid forwards those internal requests from the client to server
    side (while subjecting them to access controls and optional content
    adaptation, as usual)

4.  In the future, Squid may even forward those HTTP wrapper requests to
    peers, but that functionality is outside the initial implementation
    scope.

5.  On the server side, Squid converts HTTP wrapper requests to FTP
    commands, forwarding those commands to the FTP server.

6.  Similarly, FTP server responses are forwarded back to the FTP
    client, wrapped in HTTP responses.

7.  Squid logs the FTP transaction using HTTP wrappers and existing
    access logging code.

# Mapping

## FTP command to HTTP request mapping

Each FTP command, whether understood by Squid or not, is mapped to an
HTTP request.

|                              |                                                                                                                                                                                  |
| ---------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **HTTP Request property**    | **Mapping algorithm**                                                                                                                                                            |
| Request method               | "PUT" for FTP STOR. Otherwise GET?                                                                                                                                               |
| Request URI                  | `ftp://host/` (for now; see Future Enhancement)                                                                                                                                  |
| Request protocol and version | HTTP/1.1 (That is what these wrapper messages are to Squid core. Also, some ICAP services may fail on FTP/x.y)                                                                   |
| Host header                  | FTP server name followed by non-standard port if any                                                                                                                             |
| FTP-Command                  | FTP command name                                                                                                                                                                 |
| FTP-Arguments                | FTP command arguments (i.e., everything after the FTP command name and before CRLF). Not present if CRLF follows command name. Present but empty of SP CRLF follow command name. |

## FTP reply to HTTP response mapping

|                                        |                                                                                                                             |
| -------------------------------------- | --------------------------------------------------------------------------------------------------------------------------- |
| **HTTP Response property**             | **Mapping algorithm**                                                                                                       |
| Response status code and reason phrase | 100 Continue for any grokked FTP 1xx response; 200 OK for any other grokked FTP server response; 500 Server Error otherwise |
| Request protocol and version           | HTTP/1.1 (so that ICAP services do not fail on FTP/x.y)                                                                     |
| Date                                   | FTP reply start date                                                                                                        |
| Cache-Control                          | "private" (Squid cannot cache these until we track Request URIs)                                                            |
| Content-Length                         | none if there is an associated file transfer; zero otherwise                                                                |
| FTP-Status                             | FTP reply code (e.g., 431)                                                                                                  |
| FTP-Reason                             | FTP explanatory text (e.g., "No such directory")                                                                            |

## Mapping of FTP body transfer

Squid does not forward HTTP bodies using HTTP constructs internally. The
code will have to use existing Squid body forwarding APIs (BodyPipe for
request bodies and Store for response bodies).

### Transfer failures

Terminate body transmission as in the case of HTTP body transmission
failure. In case of reply body, send an 1xx control message to the
client side indicating the final FTP status code.

## Mapping example

|                               |                 |                                  |                 |                                  |
| ----------------------------- | --------------- | -------------------------------- | --------------- | -------------------------------- |
| **Label**                     | **FTP-C**       | **Squid-C**                      | **FTP-S**       | **Squid-S**                      |
| **Sends what**                | FTP command     | HTTP Request                     | FTP reply       | HTTP response                    |
| **sender(s) and receiver(s)** | client to Squid | Squid client-side to server-side | server to Squid | Squid server-side to client-side |
| Squid to server               | Squid to client |                                  |                 |                                  |

    FTP client <--> Squid             Squid client-side <--> Squid server-side     Squid <--> FTP server
    -------------------------------   ------------------------------------------   -------------------------------
    
    USER anonymous@ftp.example.com    
    
                                      GET ftp://ftp.example.com/ HTTP/1.1
                                      Host: ftp.example.com
                                      FTP-Command: USER
                                      FTP-Arguments: anonymous@ftp.example.com
    
                                                                                   USER anonymous@ftp.example.com
    
                                                                                   331 User name okay, need password.
    
                                      HTTP/1.1 200 OK
                                      Date: ...
                                      Cache-Control: private
                                      Content-Length: 0
                                      FTP-Status: 331
                                      FTP-Reason: User name okay, need password.
    
    331 User name okay, need password.
    ...
    RETR test.gz
    
                                      GET ftp://ftp.example.com/ HTTP/1.1
                                      Host: ftp.example.com
                                      FTP-Command: RETR
                                      FTP-Arguments: test.gz
    
                                                                                   RETR test.gz
    
                                                                                   150 File status okay; about to open data...
    
                                      HTTP/1.1 100 Continue
                                      Date: ...
                                      Cache-Control: private
                                      FTP-Status: 150
                                      FTP-Reason: File status okay; about to open data...
    
    150 File status okay; about to open data...

# Logging

Individual FTP transactions (commands and replies) are logged as HTTP
transactions (with HTTP-specific information missing) and using existing
access logging facilities. The following details should be available in
the access log:

  - Client IP address

  - Remote server name and IP address

  - Remote user name

  - FTP command sent by the client including arguments (passwords
    stripped, just like Squid strips URI query terms)

  - FTP status sent by the server to Squid

  - FTP status sent by Squid to to the client

  - FTP transaction response time (from the start of receiving FTP
    command to the end of sending the reply)

  - Size of the transferred file

Note that Squid does not map FTP status codes to HTTP status codes in
HTTP wrapper messages so FTP and/or logging code may need to adjust
logged values to reflect the true FTP status and not the HTTP status of
the wrapping HTTP message.

# Future enhancements

One very useful but difficult to support feature is tracking of FTP
current or requested directory across CD and similar commands. Such
tracking would allow simple access controls based on request URIs. While
primitive tracking is not very difficult to support, FTP directory
*links* make proper support very tricky (and impossible in some cases):
In FTP, "foo/bar/.." path (i.e., a sequence of "CD foo", "CD bar", and
"CD .." commands) may result in current location different than "foo"
(i.e., the "PWD" command will not print "foo"). Eventually, Squid will
probably track the URI using one or more algorithms, but this project
does not include such support or the decision which URI tracking
algorithm to implement.

[CategoryFeature](/CategoryFeature)
