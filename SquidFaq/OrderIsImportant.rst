##master-page:SquidTemplate
#format wiki
#language en

= Order Is Important! =

 * Order is important
 * Order is critical

This is by far the No. 1 most repeated comment in the Squid user help lists.  Squid with its traditional "Bungled config line" is not exactly helpful either when it comes to notifying what the problem is.

== Why? ==

Squid process its config file from the top down. Left to right. Creating internal configuration information as it goes.

To create a metaphor there is a simple everyday procedure one performs to enter a locked door. Unlock, open, and walk through. Get them out of order. For example "unlock, walk, open" is possibly valid. But will result in some pain when actually done that way and will not result in the opener being on the far side of the doorway.

Similarly there are groups of actions which are individually configured in squid.conf. But the order determines what the final situation is.

== Modes ==

Modern Squid run multiple ''modes'' of operation simultaneously.

The order of SquidConf:http_access forward-proxy and reverse-proxy configuration options determines whether a reverse-proxy website visitor is able to reach the website. They also determine whether that website is able to perform HTTPS, AJAX, JSON, or other advanced website operations beyond plain simple HTTP. see the relevant [[SquidFaq/ReverseProxy#How_do_I_set_it_up.3F]] example for specific order details. Generally the reverse-proxy needs to be first.

The order and placement of SquidConf:debug_options directives determines what debug levels are run during processing of the configuration file and later during normal running of Squid.

== Authentication ==

The order of SquidConf:auth_param '''program''' directives determines how Squid reports the authentication options to Browsers. This has visible effects on what type of authentication is performed. see [[Features/Authentication]] for details and recommended ordering.

SquidConf:acl '''proxy_auth''' and SquidConf:external_acl_type using '''%LOGIN''' must be defined after SquidConf:auth_param. Squid will warn about authentication being used but not setup here.

SquidConf:external_acl_type using '''%LOGIN''' will trigger authentication challenges if those credentials are not present. The placement of these tests affects which rules around them require authentication.

Similarly SquidConf:acl testing authentication placement left-to-right on their line determins whether the test bypasses, fails or triggers an auth challenges.

== Access Controls ==

SquidConf:acl definition lines must be specified before any point at which they are mentioned for use.

The order of individual access controls affects other lines of the same type. For example each SquidConf:http_access is run in order and affect each other, but not any SquidConf:cache_peer_access in between.

This goes for each type of access directive. see [[SquidFaq/SquidAcl#Access_Lists]] for a list of access types.

The order of individual words on each access control line is even more critical. This can mean the difference between having an access control line match or skip. Or whether Squid can process 300 or 3 thousand requests per second. see [[SquidFaq/SquidAcl#Common_Mistakes]] for details on how ordering of individual line words works.

== Major Transaction Milestones ==

A typical HTTP transaction goes through a sequence of checks and may be shared with external helpers/services. Since these checks and services may modify the transaction and/or its metadata, it is often critical to know the order of their execution. For example, does the request target URI get rewritten before or after the store ID helper runs? There is currently no comprehensive documentation covering every major transaction milestone, but this section may answer many related FAQs.

=== Callout Sequence ===
<<Include(ProgrammingGuide/Architecture, , from="^##begin calloutseq", to="^##end calloutseq")>>

== Others ==

Some others have a simpler interaction, but ordering is still important.

 * refresh_pattern - top down first pattern match wins.
 * delay_pools + delay_class + delay_parameters - must be added in that order: pools, class, parameters.
 * cache_peer - order of individual cache_peer entries affects selection of default and first-available peer.


## ----
## Discuss this page using the "Discussion" link in the main menu
## 
## <<Include(/Discussion)>>
