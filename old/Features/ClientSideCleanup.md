# Feature: Client side cleanup

  - **Goal**: Improve code quality and maintainability.

  - **Status**: started;

  - **ETA**: Two-three months once started

  - **Version**: Squid 3.4 and later

  - **Developer**:
    [AmosJeffries](/AmosJeffries)

  - **More**: [squid-dev
    thread](http://www.mail-archive.com/squid-dev@squid-cache.org/msg07889.html)

## Details

We need thin and clean HTTP server code that makes sense to developers.
Clear interaction with Comm, Store, and Forward APIs (which should
probably be cleaned up before this project). The current code
accumulated many serious design flaws that make changes difficult and
risky. Most (perhaps all) developers cannot even grasp all the
interactions and inner dependencies, which causes the snowball effect of
degrading code quality.

Affected client_side\* classes may be renamed to reflect the fact that
they implement an HTTP server. This code communicates with Squid clients
and, hence, has been called *client side*.

### Progress

Done:

  - Comm::TcpAcceptor separated out
    
      - \- class to handle the Comm level operations of accept() and
        following socket state lookups

  - Defined the scope and purpose for ConnStateData
    
      - \- class to manage a client TCP connection. - reading HTTP/1.1
        frames (request headers block, body blocks) - writing HTTP/1.1
        frames (response headers block, 1xx headers block, body blocks)
        
        \- generate HttpParser, ClientSocketContext and other AsyncJobs
        to operate on teh above frames types as needed

In Progress:

  - Create a master transaction state object for relaying data easily

  - Refactor ConnStateData to meet the above criteria

Future steps:

  - Define the scope and purpose for ClientSocketContext

  - Define the scope and purpose for ClientHttpRequest

[CategoryFeature](/CategoryFeature)
[CategoryWish](/CategoryWish)
