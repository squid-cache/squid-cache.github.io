##master-page:SquidTemplate
#format wiki
#language en

## add some descriptive text. A title is not necessary as the WikiPageName is already added here.

## if you want to have a table of comments remove the heading hashes from the next line
## <<TableOfContents>>

Spoon Feeding is an optimization obtained by deploying a [[SquidFaq/ReverseProxy|Reverse Proxy]]. Its purpose is to free up valuable computation resources by allowing them to quickly complete the network part of their work to a very close and fast intermediary (the reverse proxy), which can then send the data to the remote clients as the network congestion conditions allow (spoon feed the clients).

This is highly effective as the number of application threads is often a limiting factor for high-volume websites, and they can be tied up for a significant time by the need to actually send the data to the clients.

----
Discuss this page using the "Discussion" link in the main menu

<<Include(/Discussion)>>
