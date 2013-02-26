##master-page:SquidTemplate
#format wiki
#language en

= Squid Architecture =

[[TableOfContents]]

== Broad Overview ==

Squid is operating at layers 4-7 on the [[http://wikipedia.org/wiki/OSI_model|OSI data model]]. So unlike most networking applications there is no relationship between packets (a layer 3 concept) and the traffic received by Squid. Instead of packets HTTP operates on a '''message''' basis (called segments in the OSI model definitions), where an HTTP request and response can each be loosely considered equivelent to one "packet" in a transport architecture. Just like IP packets HTTP messages are stateless and the delivery is entirely optional for process. See the RFC RFC:2616 texts for a better description on HTTP specifics and how it operates.


At the broad level Squid consists of four generic processing areas;

 * a client-side which implements HTTP, HTTPS, ICP and HTCP protocols to communicate with clients, and

 * a server-side which implements HTTP, HTTPS, FTP, Gopher and WAIS to communicate with web servers, and

 * between them is the cache storage. Which in broad terms provides the buffering mechanisms for data transit, and provides switching logic to determine data source between disk, memory, and server-side.

 * there is also a set of components performing extra support tasks; security (authentication and access control), DNS client, IDENT client, and WHOIS client.

  {{attachment:BroadOverview.png}}

== General Overview ==

 . {i} The general design level is where Squid-2 and Squid-3 differ. With Squid-2 being composed purely of event callback chains, Squid-3 adds the model of task encapsulation within Jobs.

## TODO embed data overview flow images.

## TODO pull in descriptions of I/O event model, AsyncJob model

## TODO data processing diagram with color-coded for display of AsyncJob vs Event callback coverage.


----
Discuss this page using the "Discussion" link in the main menu

<<Include(/Discussion)>>
