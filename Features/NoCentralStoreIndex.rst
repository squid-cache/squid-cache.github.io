##master-page:CategoryTemplate
#format wiki
#language en

## This is a Feature documentation template. Remove this comment and replace  placeholder questions with the actual information about the feature.

= Feature: No in-memory central index =

 * '''Goal''': Allow store to grow unbounded by memory

 * '''Status''': ''Not started''

 * '''ETA''': unknown

 * '''Version''': What Squid version(s) will get this feature?

 * '''Developer''': Who is responsible for this feature? Use wiki names for developers who have a home page on this wiki.

 * '''More''': Where can folks find more information? Include references to other pages discussing or documenting this feature. Leave blank if unknown.

## Details
##
## Any other details you can document? This section is optional.
## If you have multiple sections and ToC, please place them here,
## leaving the above summary information in the page "header".

Squid is currently operating around a single in-memory index of all cached objects, which is quite good for performance but very resource demanding in bigger installations and also making it harder to add SMP support.

The big single in-memory store index is starting to become quite a burden. There is a need for something which scales better with both size and CPU.

We need to move away from this, providing an asyncronous store lookup mechanism allowing the index to be moved out from the core and down to the store layer. Ultimately even supporting shared stores used by multiple Squid frontends.

Goal of not having a central index, making it possible to push more of the store logics down..

----
CategoryFeature | CategoryWish
