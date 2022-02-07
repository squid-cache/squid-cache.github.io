Getting squid going: SquidFaq/CompilingSquid and CvsInstructions

We're hitting this [[http://bugs.squid-cache.org/buglist.cgi?query_format=advanced&short_desc_type=allwordssubstr&short_desc=&target_milestone=3.0&long_desc_type=allwordssubstr&long_desc=&bug_file_loc_type=allwordssubstr&bug_file_loc=&status_whiteboard_type=allwordssubstr&status_whiteboard=&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&emailtype1=substring&email1=&emailtype2=substring&email2=&bugidtype=include&bug_id=&votes=&chfieldfrom=&chfieldto=Now&chfieldvalue=&cmdtype=doit&order=Reuse+same+sort+as+last+time&query_based_on=3.0+bugs&field0-0-0=noop&type0-0-0=noop&value0-0-0=|bug list]] all weekend.

We started with 42, and have addressed:

 * Bug:772
 * Bug:897
 * Bug:975
 * Bug:1402
 * Bug:1493
 * Bug:1567
 * Bug:1568
 * Bug:1598
 * Bug:1642
 * Bug:1716
 * Bug:1750
 * http://www.squid-cache.org/Versions/v3/3.0/changesets/10427.patch
Other useful bug views:

 . [[http://bugs.squid-cache.org/buglist.cgi?query_format=advanced&short_desc_type=allwordssubstr&short_desc=&long_desc_type=allwordssubstr&long_desc=&bug_file_loc_type=allwordssubstr&bug_file_loc=&status_whiteboard_type=allwordssubstr&status_whiteboard=PRE5&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&emailtype1=substring&email1=&emailtype2=substring&email2=&bugidtype=include&bug_id=&votes=&chfieldfrom=&chfieldto=Now&chfieldvalue=&cmdtype=doit&order=Reuse+same+sort+as+last+time&query_based_on=PRE5&field0-0-0=noop&type0-0-0=noop&value0-0-0=|3.0.PRE5]] [[http://bugs.squid-cache.org/buglist.cgi?query_format=advanced&short_desc_type=allwordssubstr&short_desc=&long_desc_type=allwordssubstr&long_desc=&bug_file_loc_type=allwordssubstr&bug_file_loc=&status_whiteboard_type=allwordssubstr&status_whiteboard=&bug_status=UNCONFIRMED&emailtype1=substring&email1=&emailtype2=substring&email2=&bugidtype=include&bug_id=&votes=&chfieldfrom=&chfieldto=Now&chfieldvalue=&cmdtype=doit&order=Reuse+same+sort+as+last+time&query_based_on=UNCONFIRMED&field0-0-0=noop&type0-0-0=noop&value0-0-0=|UNCONFIRMED]] [[http://bugs.squid-cache.org/buglist.cgi?query_format=advanced&short_desc_type=allwordssubstr&short_desc=&target_milestone=3.0&long_desc_type=allwordssubstr&long_desc=&bug_file_loc_type=allwordssubstr&bug_file_loc=&status_whiteboard_type=allwordssubstr&status_whiteboard=PATCH25&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&emailtype1=substring&email1=&emailtype2=substring&email2=&bugidtype=include&bug_id=&votes=&chfieldfrom=&chfieldto=Now&chfieldvalue=&cmdtype=doit&order=Reuse+same+sort+as+last+time&query_based_on=Port-3.0&field0-0-0=noop&type0-0-0=noop&value0-0-0=|Port to 3.0]] [[http://bugs.squid-cache.org/buglist.cgi?query_format=advanced&short_desc_type=allwordssubstr&short_desc=&version=3.0&target_milestone=---&long_desc_type=allwordssubstr&long_desc=&bug_file_loc_type=allwordssubstr&bug_file_loc=&status_whiteboard_type=allwordssubstr&status_whiteboard=&bug_status=NEW&bug_status=ASSIGNED&bug_status=REOPENED&emailtype1=substring&email1=&emailtype2=substring&email2=&bugidtype=include&bug_id=&votes=&chfieldfrom=&chfieldto=Now&chfieldvalue=&cmdtype=doit&order=Reuse+same+sort+as+last+time&query_based_on=3.0-unspecified&field0-0-0=noop&type0-0-0=noop&value0-0-0=|Not scheduled]]
Roberts configure option list for debugging: {{{'--prefix=/home/robertc/install/squid' '--enable-gopher' '--enable-ssl' '--enable-urn' '--enable-wais' '--enable-whois' '--enable-auth=negotiate,ntlm,basic,digest' '--enable-storeio=aufs,diskd,ufs,coss,null' '--enable-cache-digests' '--enable-htcp' '--enable-removal-policies=lru,heap' '--enable-snmp' '--enable-icmp' '--enable-debug-cbdata' '--enable-basic-auth-helpers=NCSA' '--enable-delay-pools' '--enable-maintainer-mode' '--enable-cpu-profiling' 'CFLAGS=-g -O2 -Wall' '--enable-esi' '--enable-icap-client' '--disable-inline' '--enable-for-via-db'}}}

Henriks build script. Use -g for debug build:

[[http://devel.squid-cache.org/hno/build.sh|Build script]]
