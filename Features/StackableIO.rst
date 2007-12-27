##master-page:CategoryTemplate
#format wiki
#language en

= Feature: Stackable I/O =

 * '''Goal''': Abstract the actual low-level I/O from the upper level protocols, allowing for correct SSL implementations etc.
 * '''Status''': ''Not started''
 * '''ETA''': Unknown
## What is the estimated time of completion? Use either number of calendar days for not started features. Use an absolute date for started and completed features. Use ''unknown'' if unknown.
## * '''Developer''': Who is responsible for this feature? Use wiki names for developers who have a home page on this wiki.
## * '''More''': Where can folks find more information? Include references to other pages discussing or documenting this feature. Leave blank if unknown.


## Details
##
## Any other details you can document? This section is optional.
## If you have multiple sections and ToC, please place them here,
## leaving the above summary information in the page "header".

Move away from the fd centric I/O model into a model using abstract handles, allowing I/O layers to be stacked. Needed to make SSL I/O make sense, and also for adding new transport mechanisms such as compression.

Currently the network I/O is very filedescriptor centric, which do not fit very well with the needs of SSL and other middle layers where protocol level I/O operations do not match exactly the actual I/O.

----
CategoryFeature CategoryWish
