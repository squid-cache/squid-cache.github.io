See [Discussed
Page](/Features/RockStore#)

Several bugs and issues have come into view when using RAM-only and COSS
Squid that are relevant to this.

Most of it is related to the way storage rebuild currently depends on a
global store\_rebuilding flag to allow other things in Squid to proceed.

The first issue is showing all signs of this rebuild flag not even
working, first storage \_type\_ to complete rebuild unsets it regardless
of other types being incomplete (COSS vs AUFS reload races; COSS looses
on high-end boxes).

Several of those things waiting for a rebuild only need \_a\_ cache for
objects to start running. The RAM-cache would be completely sufficient
for the first few minutes while disk storage indexes get loaded.

[AmosJeffries](/AmosJeffries#)
2009-04-24
