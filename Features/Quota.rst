##master-page:CategoryTemplate
#format wiki
#language en

## This is a Feature documentation template. Remove this comment and replace  placeholder questions with the actual information about the feature.

= Feature: Quota control =

 * '''Goal''': Usable quota controls

 * '''Status''': ''Not started''

 * '''ETA''': ''unknown''

 * '''Version''': Squid 3?

 * '''Developer''': 

 * '''More''': 


## Details
##
## Any other details you can document? This section is optional.
## If you have multiple sections and ToC, please place them here,
## leaving the above summary information in the page "header".

== Description ==

Squid needs a usable quota control. The existing approaches of using external acls or redirectors is somewhat limited in that they need to process access.log to calculate the bandwidth usage, plus that they are only evaluated at the start of the request. Because of these limitations users may go significantly over their quota before Squid reacts.

----
CategoryFeature CategoryWish
